import 'package:flutter/material.dart';
import 'package:loader_search_bar/loader_search_bar.dart';

class AllBookView extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new AllBookViewState();
}

class AllBookViewState extends State< AllBookView> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: SearchBar(
          defaultBar: new AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            leading: new IconButton(
                icon: const Icon(Icons.search),
                color: Colors.black45,
                onPressed: null),

            /* actions: <Widget>[
            IconButton(
                icon: Icon(Icons.save),
                color: Colors.black45,
                tooltip: '保存',
                onPressed: () => debugPrint('书籍信息已保存')),
          ],*/
            //backgroundColor: Colors.green[500],
          ),),
    );
  }
}