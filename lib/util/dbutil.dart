import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/book.dart';
import 'localfileutil.dart';

class dbutil {

  static final _VERSION = 1;
  static final _DbName = 'bookmanager';
  static final _BookInfoTable = 'bookinfo';
  static Database _database;

  static Future init() async {
    var databasepath = await getDatabasesPath();
    String dbpath = join(databasepath, _DbName);
    _database = await openDatabase(dbpath, version: _VERSION,
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE bookcategory(id INTEGER PRIMARY KEY, categoryname TEXT,iconindex int);"
          );
          await db.execute(
              "CREATE TABLE booktype(id INTEGER PRIMARY KEY, typename TEXT);"
          );

          //create bookinfo table
          await db.execute(
              "CREATE TABLE bookinfo(id INTEGER PRIMARY KEY, bookname TEXT,author TEXT, publishing TEXT, ISBN TEXT, public_time TEXT, favor_rate DOUBLE, borrow_time TEXT,return_time TEXT,source TEXT, Owner TEXT,category TEXT,flags TEXT,imageindex INTEGER,remark TEXT );"
          );

          //create book image table
          await db.execute(
              "CREATE TABLE bookimage(id INTEGER PRIMARY KEY, imagecontent TEXT);"
          );

          await db.transaction((txn) async {
            var batch = txn.batch();
            batch.insert(
                "bookcategory", {"categoryname": "儿童文学", "iconindex": 58693});
            batch.insert(
                "bookcategory", {"categoryname": "生活百科", "iconindex": 58295});
            batch.insert(
                "bookcategory", {"categoryname": "科学知识", "iconindex": 60221});
            batch.insert(
                "bookcategory", {"categoryname": "诗词文学", "iconindex": 58050});
            batch.insert(
                "bookcategory", {"categoryname": "其他", "iconindex": 59692});

            await batch.commit();
          });
          debugPrint('create table success');
        }
    );
    //   await _database.close();
  }


  //get all book category name
  static Future<List> getAllBookCategory() async {
    var dbClient = await _database;
    var result = await dbClient.query(
        "bookcategory", columns: ['id', 'categoryname', 'iconindex']);
    // await dbClient.close();
    return result.toList();
  }

  ///remove the database
  static Future deleteDB() async {
    var databasepath = await getDatabasesPath();
    String dbpath = join(databasepath, _DbName);
    await deleteDatabase(dbpath);
  }

  /// insert a new category
  static Future<bool> insertCategory(String category, int iconindex) async {

    /*  var databasepath = await getDatabasesPath();
    String dbpath = join(databasepath, _DbName);*/
    try {
      var dbClient = await _database;
      dbClient.transaction((txn) async {
        await txn.rawInsert(
          "INSERT INTO bookcategory(categoryname, iconindex) VALUES('$category',$iconindex)",
        );
      });
      // await dbClient.close();
      return true;
    } catch (exception) {
      return false;
    }
  }

  //insert book cover image
  static Future<int> insertImage(File imageData, int bookId, String bookname) async {
    int imageId = -1;
    try {
     // debugPrint("book id " + bookId.toString());
      var dbClient = await _database;
      String filename = bookname + ".data";
      File file = await LocalFileUtil.getLocalFile(filename);
      String content = base64.encode(imageData.readAsBytesSync());
      file.writeAsStringSync(content);

      imageId = await dbClient.rawInsert(
        "INSERT INTO bookimage(imagecontent) VALUES('$filename')",
      );

      if (imageId > 0) {
        await dbClient.rawUpdate(
            'UPDATE bookinfo SET imageindex = ? WHERE id = ?',
            [imageId, bookId]);
      }
      return imageId;
    } catch (exception) {
      debugPrint(exception.toString());
      return -1;
    }
  }

  static Future<String> getImage(int imageId) async {
    try {
      //debugPrint(imageId.toString());
      var dbClient = await _database;
      List<Map> maps = await dbClient.query('bookimage',
                columns: ['imagecontent'],
                where: 'id = ?',
                whereArgs: [imageId]);

      String filename =  maps[0]['imagecontent'].toString();
      File file = await LocalFileUtil.getLocalFile(filename);
      String content = file.readAsStringSync();
    //  debugPrint(content);
      return content;
    }catch(exception){
      return "";
    }
  }
  /// insert a bookinfo object
  static Future<int> insertBookInfo(BookInfo bookinfo) async {
    int resultId = -1;
    try {
      var dbClient = await _database;
      String bookname = bookinfo.bookname;
      double favor_rate = bookinfo.favor_rate;
      String borrow_time = bookinfo.borrow_time;
      String return_time = bookinfo.return_time;
      String source = bookinfo.source;
      String owner = bookinfo.Owner;
      String category = bookinfo.category;
      String flags = bookinfo.flags;
      String remark = bookinfo.remark;
      int imageindex = bookinfo.image_index;

      resultId = await dbClient.rawInsert(
        "INSERT INTO bookinfo(bookname,favor_rate,borrow_time,return_time,source,owner,category,flags,imageindex,remark) VALUES('$bookname',$favor_rate,'$borrow_time','$return_time','$source','$owner','$category','$flags',$imageindex,'$remark' )",
      );

      // resultId = await dbClient.insert(_BookInfoTable, bookinfo.toMap(),{""});
      return resultId;
    } catch (exception) {
      debugPrint(exception.toString());
      return -1;
    }
  }

  ///update category name
  static Future<bool> updateCategory(String newcategory, int id) async {
    try {
      var dbClient = await _database;
      dbClient.transaction((txn) async {
        await txn.rawInsert(
          "UPDATE bookcategory SET categoryname = '$newcategory' where id = $id",
        );
      });
      return true;
    } catch (exception) {
      return false;
    }
  }

  ///close the database
  static Future closeDB() async {
    var dbClient = await _database;
    dbClient.close();
  }

  static Future<bool> deleteBook(int bookId,int image_index) async{
    String filepath = "";
    try {
      var dbClient = await _database;
      if(image_index != null && image_index > 0) {
        var result = await dbClient.rawQuery("select imagecontent from bookimage where id = $image_index");
        filepath = result[0]["imagecontent"].toString();
      }

      //delete book info and image with transaction
      dbClient.transaction((txn) async {
        var batch = txn.batch();
        batch.delete("bookinfo",where: "id = ?",whereArgs: [bookId]);
        if(image_index != null && image_index > 0)
          batch.delete("bookimage",where: "id = ?", whereArgs: [image_index]);
        await batch.commit().then((onValue) async {
          //delete image file
          if(filepath.length > 0) {
            File file = await LocalFileUtil.getLocalFile(filepath);
           // debugPrint(file.path);
            file.delete();
          }
        });
      });
      return true;
    } catch (exception) {
      debugPrint(exception.toString());
      return false;
    }
  }
  static Future<int> getStatData(String query_sql) async {
    try {
      var dbClient = await _database;
      var result = await dbClient.rawQuery(query_sql);
      return result[0]['count(*)'];
    } catch (exception) {
      debugPrint(exception.toString());
      return -1;
    }
  }

  static Future<List<BookInfo>> getAllBook() async {
    String query_sql = 'select * from bookinfo order by id desc';
    List<BookInfo> books = [];
    try {
      var dbClient = await _database;
      List<Map> maps = await dbClient.rawQuery(query_sql);
      maps.forEach((item) => books.add(BookInfo.fromMap(item)));
      return books;
    }catch (exception) {
      debugPrint(exception.toString());
      return [];
    }
  }

  //flag the book that already return
  static Future<bool> remarkBook(int bookId) async{
    try {
      var dbClient = await _database;
      String return_date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      int count = await dbClient.rawUpdate("update bookinfo SET return_time = ? where id = ?",['$return_date',bookId]);
      return count > 0 ? true:false;
    }catch (exception) {
      debugPrint(exception.toString());
      return false;
    }
  }
  //update book info and image data
  static Future<bool> updateBook(BookInfo book,File image_data,bool bReplace) async {
      try{
        var dbClient = await _database;
        int count  = await dbClient.update("bookinfo", book.toMap(),where: "id = ?",whereArgs: [book.id]);
        if(bReplace){
          String filepath = book.bookname + ".data";
          File file = await LocalFileUtil.getLocalFile(filepath);
          if(file != null){
            String content = base64.encode(image_data.readAsBytesSync());
            file.writeAsStringSync(content);
          }

          if(book.image_index < 0){
            var imageId = await dbClient.rawInsert(
              "INSERT INTO bookimage(imagecontent) VALUES('$filepath')",
            );

            if (imageId > 0) {
              await dbClient.rawUpdate(
                  'UPDATE bookinfo SET imageindex = ? WHERE id = ?',
                  [imageId, book.id]);
            }
          }
        }
        return count > 0?true:false;
      }catch(exception){
          debugPrint(exception.toString());
          return false;
      }
  }
}