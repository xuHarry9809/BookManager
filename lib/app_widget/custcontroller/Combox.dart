import 'dart:math';
import 'package:flutter/material.dart';

class Combox extends StatefulWidget{
  @override
  _ComboxState  createState()=> new _ComboxState();
}
class _ComboxState extends State<Combox>{

  List icon_datas = [0xe192,0xe92c,0xe84f,0xe003,0xe854,0xe195,0xe226,0xeb3e,
                     0xe1a7,0xe865,0xe3ac,0xe6dd,0xe308,0xe52f,0xe568,0xe63f,
                     0xe87a,0xe87b,0xe87d,0xe3e3,0xe3e4,0xe23a,0xe1b3,0xe885];

  List<DropdownMenuItem<int>> _dropDownMenuItems;
  int _currentIconIndex;
  final int itemsCount = 5;

  @override
  void initState() {
    // TODO: implement initState
    _dropDownMenuItems = getDropdownMenuItems();
    _currentIconIndex = _dropDownMenuItems[0].value;
    super.initState();

  }

  List<DropdownMenuItem<int>> getDropdownMenuItems(){
    List<DropdownMenuItem<int>> items = new List();
    Random rd = new Random();
    for(var i=0;i< itemsCount;i++){
        int index = rd.nextInt(23);
        items.add(new DropdownMenuItem(
            value: icon_datas[index],
            child:Icon(IconData(icon_datas[index], fontFamily: 'MaterialIcons'))
        ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context){
      return new Container(
       // color: Colors.grey[500],
        padding: EdgeInsets.only(top:10.0),
        child: new Row(
           // crossAxisAlignment: CrossAxisAlignment.start,
           // mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Text("请选择分类图标: ",textAlign: TextAlign.left),
              new Container(
                padding: new EdgeInsets.all(5.0),
              ),
              new DropdownButton(
                value: _currentIconIndex ==""?null:_currentIconIndex,
                items: _dropDownMenuItems,
                iconSize: 32,
                onChanged: changedDropDownItem,
              )
            ],
          ),
      );
  }
  void changedDropDownItem(int selected) {
    setState(() {
      if(selected < 0 || selected == null)
        _currentIconIndex = null;
      else
        _currentIconIndex = selected;
    });
  }
}