import 'dart:math';
import 'package:flutter/material.dart';
import '../../util/networkutil.dart';
import '../../util/dbutil.dart';
import '../../model/categorynode.dart';

class TextCombox extends StatefulWidget{
  String currentVal;
  String title;
  int datasrc;

  static const int CATEGORY = 1;

  TextCombox({this.datasrc,this.title});

  String getValue(){
    return currentVal;
  }
  @override
  _TextComboxState  createState()=> new _TextComboxState();
}
class _TextComboxState extends State<TextCombox>{

  String _currentVal;
  List<String> select_list = [];
  @override
  void initState() {
    // TODO: implement initState
    /*for(int val in _itemvalues)
      debugPrint(val.toString() + "\n");
    debugPrint(_currentIconIndex.toString());*/
    switch(widget.datasrc){
      case TextCombox.CATEGORY:
        dbutil.getAllBookCategory().then((categorynodes){
          setState(() {
            select_list.clear();
            categorynodes.forEach((node){
              select_list.add(CategoryNode.fromMap(node).category);
            });
            //  debugPrint(category_list.length.toString());
          });
        });
        break;
    }
    super.initState();
  }

  //generate 5 icon with random


  @override
  Widget build(BuildContext context){
      return new Container(
       // color: Colors.grey[500],
        padding: EdgeInsets.only(left: 16.0),
        child: new Row(
           // crossAxisAlignment: CrossAxisAlignment.start,
           // mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Text(widget.title,textAlign: TextAlign.left,style: TextStyle(fontSize: 16,color: Colors.black45),),
              new Container(
                padding: new EdgeInsets.all(5.0),
              ),
              new DropdownButton(
                value: _currentVal,
                items: select_list.map((String val){
                    return DropdownMenuItem(
                        value: val,
                        child:Text(val,style: TextStyle(fontSize: 16),)
                    );
                }).toList(),
                isDense: true,
                iconSize: 32,
                onChanged:(selected){
                    setState(() {
                      _currentVal = selected;
                      widget.currentVal = _currentVal;
                    });
                  } ,
              )
            ],
          ),
      );
  }

}