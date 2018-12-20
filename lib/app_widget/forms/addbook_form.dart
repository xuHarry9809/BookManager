import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
//import 'package:flutter_date_picker/flutter_date_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../custcontroller/rating_bar.dart';
import '../custcontroller/TextCombox.dart';
import '../../util/dbutil.dart';
import '../../model/categorynode.dart';

class AddBookForm extends StatefulWidget {
  static final String routeName = '/addbookform';

  @override
  State<StatefulWidget> createState() => new AddBookFormState();
}

class AddBookFormState extends State<AddBookForm> {
  Future<File> _imageFile;

  List<Widget> widget_list = [];
  static final backColors = Colors.yellow[400];
  static final fontsize = 16.0;

  String error;
  TextEditingController bookname_controller = new TextEditingController();
  TextEditingController author_controller = new TextEditingController();
  TextEditingController borrowtime_controller = new TextEditingController();
  TextEditingController returntime_controller = new TextEditingController();
  TextEditingController buytime_controller = new TextEditingController();
  TextEditingController owner_controller = new TextEditingController();
  TextEditingController category_controller = new TextEditingController();

  static List<String> category_texts = [];

  TextCombox categroyCombo =
      new TextCombox(datasrc: TextCombox.CATEGORY, title: '书籍分类:');

  int groupValue = 1;
  double favor_rating = 5;
  bool _isSaveButtonEnabled = false;

  @override
  void initState() {

    initData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void initData() {
    //borrowtime_controller.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    dbutil.getAllBookCategory().then((categorynodes) {
      setState(() {
        category_texts.clear();
        categorynodes.forEach((node) {
          category_texts.add(CategoryNode.fromMap(node).category);
        });
        category_controller.text = category_texts[0];
        //  debugPrint(category_list.length.toString());
      });
    });
  }

  List<Widget> _buildWidget() {
    widget_list = [];
    widget_list..addAll(_buildBookBaseInfo());
  }

  Widget _previewImage() {
    return FutureBuilder<File>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Image.file(snapshot.data);
          } else if (snapshot.error != null) {
            return new Icon(Icons.book, size: 144);
          } else {
            return new Image(
              image: AssetImage('image/bookcover.jpg'),
              fit: BoxFit.cover,
            );
          }
        });
  }

  List<Widget> _buildBookBaseInfo() {
    return [
      new Column(
        children: <Widget>[
          new Container(
            child: _previewImage(),
          ),
        ],
      )
    ];
  }

  Widget _buildTopRight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        text('书名',
            //color: Colors.white,
            size: 18,
            isBold: true,
            padding: EdgeInsets.only(top: 16.0)),
        text(
          '作者',
          //  color: Colors.white,
          size: 16,
          padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
        ),
        text(
          '出版社',
          // color: Colors.white,
          size: 16,
          padding: EdgeInsets.only(top: 0, bottom: 16.0),
        ),
        text(
          '出版时间',
          //   color: Colors.white,
          size: 16,
          padding: EdgeInsets.only(top: 0, bottom: 16.0),
        ),
        text(
          'ISBN:890412345',
          //  color: Colors.white,
          size: 16,
          padding: EdgeInsets.only(top: 0, bottom: 16.0),
        ),
        Row(
          children: <Widget>[
            text(
              '推荐指数',
              isBold: true,
              padding: EdgeInsets.only(right: 8.0),
            ),
            RatingBar(color: Colors.red[800], starCount: 3, rating: 2.5)
          ],
        ),
        SizedBox(height: 32.0),
        Row(
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Colors.black87,
              color: Colors.blue,
              elevation: 15.0,
              child: Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Chip(
                    label: Text('儿童文学'),
                    padding: EdgeInsets.all(8.0),
                    labelStyle: TextStyle(fontSize: 20, color: Colors.white),
                    backgroundColor: Colors.blue,
                  )),
            ),
            SizedBox(width: 8.0),
            Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Colors.black87,
              color: Colors.red[400],
              elevation: 15.0,
              child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Chip(
                    label: Text('课外读物'),
                    padding: EdgeInsets.all(8.0),
                    labelStyle: TextStyle(fontSize: 20, color: Colors.white),
                    backgroundColor: Colors.red[400],
                  )),
            )
          ],
        )

        /*Material(
          borderRadius: BorderRadius.circular(20.0),
          shadowColor: Colors.blue.shade200,
          color: Colors.blue,
          elevation: 5.0,
          child: MaterialButton(
            onPressed: () {},
            minWidth: 160.0,
            height: 40.0,
            color: Colors.blue,
            child: text('BUY IT NOW', color: Colors.white, size: 13),
          ),
        )*/
      ],
    );
  }

  Widget _buildTopLeft() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Hero(
            tag: 'tag1',
            child: Material(
              elevation: 15.0,
              shadowColor: Colors.yellow.shade900,
              child: Image(
                //height: 256,
                image: AssetImage('image/bookcover.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        text('示例图片', color: Colors.black45, size: 12)
      ],
    );
  }

  Widget _buildtopContent() {
    return Container(
      color: backColors, //Colors.yellow[300],
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(flex: 2, child: _buildTopLeft()),
          Flexible(flex: 3, child: _buildTopRight()),
        ],
      ),
    );
  }

  void _updateRadioVal(val) {
    setState(() {
      this.groupValue = val;
    });
  }

  void _saveBookInfo(){

  }

  Widget _buildbottomContent() {
    return new Container(
        color: backColors, // Colors.yellow[300],
        child:
            ListView(padding: EdgeInsets.all(4.0), shrinkWrap: true, children: <
                Widget>[
          //Column(
          //  children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 16,
              ),
              new RaisedButton(
                  color: Colors.green,
                  padding: EdgeInsets.all(5.0),
                  child:Text('保存', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  textColor: Colors.white,
                  //  textTheme:ButtonTextTheme.primary ,//按钮的主题
                  //  highlightColor: Colors.blueAccent,
                  colorBrightness: Brightness.light, //按钮主题高亮
                  elevation: 10.0, //按钮下面的阴影
                  highlightElevation: 10.0, //高亮时候的阴影
                  disabledElevation: 10.0, //按下的时候的阴影
                  onPressed: _isSaveButtonEnabled ? null : _saveBookInfo
              ),
              Spacer(),
              Text('书籍详情    ',
                  style: TextStyle(fontSize: 20, color: Colors.black45)),
            ],
          ),
          new Divider(),
          //  SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: RadioListTile(
                      value: 1,
                      groupValue: groupValue,
                      title: Text('借阅'),
                      onChanged: (int val) {
                        _updateRadioVal(val);
                      })),
              Flexible(
                  flex: 1,
                  child: RadioListTile(
                      value: 2,
                      groupValue: groupValue,
                      title: Text('购买'),
                      onChanged: (int val) {
                        _updateRadioVal(val);
                      })),
              Flexible(
                  flex: 1,
                  child: RadioListTile(
                      value: 3,
                      groupValue: groupValue,
                      title: Text('赠送'),
                      onChanged: (int val) {
                        _updateRadioVal(val);
                      })),
              Flexible(
                  flex: 1,
                  child: RadioListTile(
                      value: 4,
                      groupValue: groupValue,
                      title: Text('其他'),
                      onChanged: (int val) {
                        _updateRadioVal(val);
                      })),
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                  flex: 8,
                  child: new ListTile(
                      leading: Icon(Icons.assignment, size: 32),
                      title: TextField(
                        controller: bookname_controller,
                        onChanged: (text) {},
                        style: new TextStyle(
                            fontSize: fontsize, color: Colors.grey),
                        decoration: new InputDecoration(
                          border: null,
                          labelText: '书名(必填)',
                          errorText: error,
                          //counterText: categorynodes_list[i].category
                        ),
                      ))),
              Flexible(
                  flex: 1,
                  child: IconButton(
                      icon: Icon(Icons.image, size: 32, color: Colors.green),
                      tooltip: '添加书籍图片',
                      onPressed: null))
            ],
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: new ListTile(
                  leading: Icon(Icons.brightness_high, size: 32),
                  title: TextField(
                    controller: borrowtime_controller,
                    //任意写一个正则表达式，限制用户手动输入，选择输入不受影响
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp('dddd-dd-dd'))
                    ],
                    style:
                        new TextStyle(fontSize: fontsize, color: Colors.grey),
                    decoration: new InputDecoration(
                      border: null,
                      labelText: '借阅时间',
                      errorText: error,
                      //counterText: categorynodes_list[i].category
                    ),
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.date_range),
                      color: Colors.green,
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true, onChanged: (date) {
                          borrowtime_controller.text =
                              DateFormat('yyyy-MM-dd').format(date);
                        }, onConfirm: (date) {
                          borrowtime_controller.text =
                              DateFormat('yyyy-MM-dd').format(date);
                        }, currentTime: DateTime.now(), locale: LocaleType.zh);
                        /*showDatePicker(
                                context: context,
                                initialDate: new DateTime.now(),
                                firstDate: new DateTime.now()
                                    .subtract(new Duration(days: 3650)),
                                lastDate: new DateTime.now()
                                    .add(new Duration(days: 3650)))
                            .then((DateTime val) {
                          borrowtime_controller.text =
                              DateFormat('yyyy-MM-dd').format(val);
                        }).catchError((err) {});*/
                      }),
                ),
              ),
              Flexible(
                flex: 2,
                child: new ListTile(
                  leading: Icon(Icons.brightness_5, size: 32),
                  title: TextField(
                    controller: returntime_controller,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp('dddd-dd-dd'))
                    ],
                    style:
                        new TextStyle(fontSize: fontsize, color: Colors.grey),
                    decoration: new InputDecoration(
                      border: null,
                      labelText: '归还时间',
                      errorText: error,
                      //counterText: categorynodes_list[i].category
                    ),
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.date_range),
                      color: Colors.green,
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true, onChanged: (date) {
                          returntime_controller.text =
                              DateFormat('yyyy-MM-dd').format(date);
                        }, onConfirm: (date) {
                          returntime_controller.text =
                              DateFormat('yyyy-MM-dd').format(date);
                        }, currentTime: DateTime.now(), locale: LocaleType.zh);
                        /*   showDatePicker(
                                context: context,
                                initialDate: new DateTime.now(),
                                firstDate: new DateTime.now()
                                    .subtract(new Duration(days: 3650)),
                                lastDate: new DateTime.now()
                                    .add(new Duration(days: 3650)))
                            .then((DateTime val) {
                          returntime_controller.text =
                              DateFormat('yyyy-MM-dd').format(val);
                        }).catchError((err) {});*/
                      }),
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                  flex: 2,
                  //  child:Container(child:categroyCombo)
                  child: ListTile(
                    leading: Icon(
                      Icons.category,
                      size: 32,
                    ),
                    title: TextField(
                      controller: category_controller,
                      style:
                          new TextStyle(fontSize: fontsize, color: Colors.grey),
                      decoration: new InputDecoration(
                        border: null,
                        labelText: '书籍分类',
                        errorText: error,
                        //counterText: categorynodes_list[i].category
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        size: 32,
                        color: Colors.green,
                      ),
                      onSelected: (String val) {
                        category_controller.text = val;
                      },
                      itemBuilder: (BuildContext context) {
                        return category_texts
                            .map<PopupMenuItem<String>>((String value) {
                          return new PopupMenuItem(
                              child: new Text(value), value: value);
                        }).toList();
                      },
                    ),
                  )),
              Flexible(
                flex: 2,
                child: new ListTile(
                  leading: Icon(Icons.person_add, size: 32),
                  title: TextField(
                    controller: owner_controller,
                    style:
                        new TextStyle(fontSize: fontsize, color: Colors.grey),
                    decoration: new InputDecoration(
                      border: null,
                      labelText: '所有人',
                      errorText: error,
                      //counterText: categorynodes_list[i].category
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: new ListTile(
                      leading: Icon(Icons.flag, size: 32),
                      title: TextField(
                        controller: bookname_controller,
                        style: new TextStyle(
                            fontSize: fontsize, color: Colors.grey),
                        decoration: new InputDecoration(
                          border: null,
                          labelText: '书籍标签',
                          errorText: error,
                          //counterText: categorynodes_list[i].category
                        ),
                      ))),
              Flexible(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 32),
                      Flexible(
                          flex: 1,
                          child: Text(
                            '推荐指数',
                            style: TextStyle(
                                fontSize: fontsize, color: Colors.black45),
                          )),
                      SizedBox(width: 16),
                      Flexible(
                          flex: 2,
                          child: SmoothStarRating(
                            allowHalfRating: true,
                            onRatingChanged: (v) {
                              favor_rating = v;
                              setState(() {});
                            },
                            starCount: 3,
                            rating: favor_rating,
                            size: 32,
                            color: Colors.red[700],
                            borderColor: Colors.green,
                          ))
                    ],
                  ))
            ],
          ),

          new ListTile(
              leading: Icon(Icons.comment, size: 32),
              title: TextField(
                controller: bookname_controller,
                style: new TextStyle(fontSize: fontsize, color: Colors.grey),
                decoration: new InputDecoration(
                  border: null,
                  labelText: '备注',
                  errorText: error,
                  //counterText: categorynodes_list[i].category
                ),
              )),
        ]));
  }

  ///create text widget
  text(String data,
          {Color color = Colors.black87,
          num size = 14,
          EdgeInsetsGeometry padding = EdgeInsets.zero,
          bool isBold = false}) =>
      Padding(
        padding: padding,
        child: Text(
          data,
          style: TextStyle(
              color: color,
              fontSize: size.toDouble(),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      );
  @override
  Widget build(BuildContext context) {
    //final topRight =
    //final topLeft =
    //final topContent =
    return Scaffold(
        backgroundColor: backColors,
        appBar: new AppBar(
          backgroundColor: backColors, //Colors.yellow[300],
          elevation: 0.5,
          leading: new IconButton(
              icon: const Icon(Icons.close),
              color: Colors.black45,
              onPressed: () => _closeForm(context)),
          title: new Text(
            '添加/编辑书籍信息',
            style: TextStyle(color: Colors.black45),
          ),
          /* actions: <Widget>[
            IconButton(
                icon: Icon(Icons.save),
                color: Colors.black45,
                tooltip: '保存',
                onPressed: () => debugPrint('书籍信息已保存')),
          ],*/
          //backgroundColor: Colors.green[500],
        ),
        body: ListView(
          children: <Widget>[_buildtopContent(), _buildbottomContent()],
        ));
  }

  _closeForm(BuildContext context) {
    Navigator.of(context).pop();
  }
}
