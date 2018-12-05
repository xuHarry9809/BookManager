import 'package:flutter/material.dart';
import 'app_widget/home.dart';
import 'package:bookmanager/app_widget/forms/editcategory_form.dart';

void main() => runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.green,
      highlightColor: Color.fromRGBO(255,255, 255,0.5),
      splashColor: Colors.white70,
    ),
    routes: <String,WidgetBuilder>{
      EditCategoryForm.routeName:(BuildContext context) =>  new EditCategoryForm()
    },
    home:HomePage(title: 'NDB书籍管理'),

));

/*
class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        highlightColor: Color.fromRGBO(255,255, 255,0.5),
        splashColor: Colors.white70,
      ),
      home: HomePage(title: 'NDB书籍管理'),
    );
  }
}*/

