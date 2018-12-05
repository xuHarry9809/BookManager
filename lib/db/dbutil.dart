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
  }


  //get all book category name
  static Future<List> getAllBookCategory() async{
     var dbClinet = await _database;
     var result = await dbClinet.query("bookcategory",columns: ['id','categoryname','iconindex']);
     return result.toList();
  }

  //remove the database
  static Future deleteDB() async{
    var databasepath = await getDatabasesPath();
    String dbpath = join(databasepath, _DbName);
    await deleteDatabase(dbpath);
  }
}