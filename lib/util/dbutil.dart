import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/book.dart';

class dbutil{

  static final _VERSION = 1;
  static final _DbName = 'bookmanager';
  static final _BookInfoTable = 'bookinfo';
  static Database _database;

   static Future init() async{
    var databasepath = await getDatabasesPath();
    String dbpath = join(databasepath, _DbName);
    _database = await openDatabase(dbpath,version: _VERSION,
          onCreate: (Database db,int version) async {
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

            await db.transaction((txn) async{
              var batch = txn.batch();
              batch.insert("bookcategory", {"categoryname":"儿童文学","iconindex":58693});
              batch.insert("bookcategory", {"categoryname":"生活百科","iconindex":58295});
              batch.insert("bookcategory", {"categoryname":"科学知识","iconindex":60221});
              batch.insert("bookcategory", {"categoryname":"诗词文学","iconindex":58050});
              batch.insert("bookcategory", {"categoryname":"其他","iconindex":59692});
              await batch.commit();
            });
            debugPrint('create table success');
          }
    );
 //   await _database.close();
  }


  //get all book category name
  static Future<List> getAllBookCategory() async{

     var dbClient = await _database;
     var result = await dbClient.query("bookcategory",columns: ['id','categoryname','iconindex']);
    // await dbClient.close();
     return result.toList();
  }

  ///remove the database
  static Future deleteDB() async{
    var databasepath = await getDatabasesPath();
    String dbpath = join(databasepath, _DbName);
    await deleteDatabase(dbpath);
  }

  /// insert a new category
  static Future<bool> insertCategory(String category,int iconindex) async{

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
    }catch(exception){
      return false;
    }
  }

  //insert book cover image
  static Future<int> insertImage(File imageData,int bookId) async{
     int imageId = -1;
     try{
       var dbClient = await _database;
       String content = base64.encode(imageData.readAsBytesSync());
       imageId = await dbClient.rawInsert(
         "INSERT INTO bookimage(imagecontent) VALUES('$content')",
       );

       if(imageId > 0 ){
          await dbClient.rawUpdate(
             'UPDATE bookinfo SET imageindex = ? WHERE id = ?',
             [imageId,bookId]);
       }
       return imageId;
     }catch(exception){
       debugPrint(exception.toString());
       return -1;
     }
  }
  /// insert a bookinfo object
  static Future<int> insertBookInfo(BookInfo bookinfo) async{

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

      }catch(exception){
        debugPrint(exception.toString());
        return -1;
      }
  }

  ///update category name
  static Future<bool> updateCategory(String newcategory,int id) async{
    try {
      var dbClient = await _database;
      dbClient.transaction((txn) async {
        await txn.rawInsert(
          "UPDATE bookcategory SET categoryname = '$newcategory' where id = $id",
        );
      });
      return true;
    }catch(exception){
      return false;
    }
  }

  ///close the database
  static Future closeDB() async {
    var dbClient = await _database;
    dbClient.close();
  }

  static Future<int> getStatData() async {

    String query_allbook = 'select count(*) from bookinfo';
    try {
        var dbClient = await _database;
        var  result = await dbClient.rawQuery(query_allbook);
        return result[0]['count(*)'];
    }catch(exception){
      debugPrint(exception.toString());
      return -1;
    }
  }
}