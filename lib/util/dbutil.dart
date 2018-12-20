import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class dbutil{

  static final _VERSION = 1;
  static final _DbName = 'bookmanager';
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
            await db.execute(
                "CREATE TABLE bookinfo(id INTEGER PRIMARY KEY, typename TEXT);"
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
}