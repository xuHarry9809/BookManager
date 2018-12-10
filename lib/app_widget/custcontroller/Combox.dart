import 'dart:math';
import 'package:flutter/material.dart';
import '../../util/networkutil.dart';

class Combox extends StatefulWidget{
  int currentVal;
  int getValue(){
    return currentVal;
  }
  @override
  _ComboxState  createState()=> new _ComboxState();
}
class _ComboxState extends State<Combox>{

  List icon_datas = [0xe192,0xe92c,0xe84f,0xe003,0xe854,0xe195,0xe226,0xeb3e,
                     0xe1a7,0xe865,0xe3ac,0xe6dd,0xe308,0xe52f,0xe568,0xe63f,
                     0xe87a,0xe87b,0xe87d,0xe3e3,0xe3e4,0xe23a,0xe1b3,0xe885];

  List<int> _itemvalues=[];
  int _currentIconIndex;
  final int itemsCount = 5;

  @override
  void initState() {
    // TODO: implement initState
    _itemvalues = getItems();
    _currentIconIndex = _itemvalues.first;
    widget.currentVal= _currentIconIndex;
    /*for(int val in _itemvalues)
      debugPrint(val.toString() + "\n");
    debugPrint(_currentIconIndex.toString());*/

    super.initState();
  }

  //generate 5 icon with random
  List<int> getItems(){
    List<int> items = new List();
    Random rd = new Random();
    int length = icon_datas.length - 1;

    //generate 5 number that noRepeat
    for(var i=0;i< itemsCount;i++){
      int index = rd.nextInt(length);
      items.add(icon_datas[index]);
      icon_datas.removeAt(index);
      length = icon_datas.length - 1;
        /*bool isValid = true;
        int index = 0;
        do{
          index = rd.nextInt(23);
          for(int val in items){
              if(val == icon_datas[index]){
                isValid = false;
                break;
              }
          }
        }while(!isValid);*/
        //items.add(icon_datas[index]);
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
                value: _currentIconIndex,
                items: _itemvalues.map((int val){
                    return DropdownMenuItem(
                        value: val,
                        child:Icon(IconData(val, fontFamily: 'MaterialIcons'))
                    );
                }).toList(),
                isDense: true,
                iconSize: 32,
                onChanged: changedDropDownItem,
              )
            ],
          ),
      );
  }
  void changedDropDownItem(int selected) {
    setState(() {
        _currentIconIndex = selected;
        widget.currentVal = _currentIconIndex;
    });
  }
}