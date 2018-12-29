import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../custcontroller/rating_bar.dart';
import '../custcontroller/TextCombox.dart';
import '../../util/dbutil.dart';
import '../../util/localfileutil.dart';
import '../../model/categorynode.dart';
import '../../model/book.dart';

class AddBookForm extends StatefulWidget {
  static final String routeName = '/addbookform';

  BookInfo bookinfo;
  AddBookForm({this.bookinfo});

  @override
  State<StatefulWidget> createState() => new AddBookFormState();
}

class AddBookFormState extends State<AddBookForm> {
  Future<File> _imageFile;

  List<Widget> widget_list = [];
  static final backColors = Colors.yellow[400];
  static final fontsize = 16.0;
  static final String time_suffix = " 00:00:00";

  String error;
  TextEditingController bookname_controller = new TextEditingController();
  TextEditingController author_controller = new TextEditingController();
  TextEditingController borrowtime_controller = new TextEditingController();
  TextEditingController returntime_controller = new TextEditingController();
  TextEditingController buytime_controller = new TextEditingController();
  TextEditingController owner_controller = new TextEditingController();
  TextEditingController category_controller = new TextEditingController();
  TextEditingController flag_controller = new TextEditingController();
  TextEditingController remark_controller = new TextEditingController();

  File _image;
 // MemoryImage _m_image;
  String _image_tip = '请添加图片';
  static List<String> category_texts = [];

  TextCombox categroyCombo =
      new TextCombox(datasrc: TextCombox.CATEGORY, title: '书籍分类:');

  String groupValue = '借阅';
  double favor_rating = 5;
  bool _isSaveButtonEnabled = false;
  bool _isBorrowType = true;


  @override
  void initState() {
    super.initState();
    initData();
    initControl();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void initControl(){
    if(widget.bookinfo != null) {
      this.bookname_controller.text = widget.bookinfo.bookname;
      this.borrowtime_controller.text = widget.bookinfo.borrow_time;
      this.returntime_controller.text = widget.bookinfo.return_time;
      this.favor_rating = widget.bookinfo.favor_rate;
      this.remark_controller.text = widget.bookinfo.remark;
      this.groupValue = widget.bookinfo.source;
      this.flag_controller.text = widget.bookinfo.flags;
    }
  }
  void initData() {
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

  ImageProvider getImage(){
    if(widget.bookinfo != null
        && widget.bookinfo.image_data!= null
        && widget.bookinfo.image_data.length > 0){
      return MemoryImage(base64.decode(widget.bookinfo.image_data));
    }else{
      return AssetImage('image/bookcover.jpg');
    }
  }

  Widget _buildTopRight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildtextline('书名', 0),
        _buildtextline('作者', 1),
        _buildtextline('出版社', 2),
        _buildtextline('出版时间', 3),
        _buildtextline('ISBN', 4),
        Row(
          children: <Widget>[
            text(
              '推荐指数',
              size: 16,
              isBold: true,
              padding: EdgeInsets.only(right: 8.0),
            ),
            RatingBar(
                color: Colors.red[800],
                starCount: 3,
                rating:
                    widget.bookinfo == null ? 0 : widget.bookinfo.favor_rate)
          ],
        ),
        SizedBox(height: 32.0),
        Row(children: _buildcategoryandflags())
      ],
    );
  }

  Widget _buildtextline(String default_text, int info_type) {
    bool _isBold = false;
    double top_margin = 8.0;

    if (info_type == 0) {
      top_margin = 16.0;
      _isBold = true;
    }

    if (widget.bookinfo == null) {
      return text(
        default_text,
        size: 16,
        isBold: _isBold,
        padding: EdgeInsets.only(top: top_margin, bottom: 16.0),
      );
    } else {
      String text_val = '';
      switch (info_type) {
        case 0:
          text_val = widget.bookinfo.bookname;
          break;
        case 1:
          text_val = widget.bookinfo.author;
          break;
        case 2:
          text_val = widget.bookinfo.publishing;
          break;
        case 3:
          text_val = widget.bookinfo.public_time;
          break;
        case 4:
          text_val = widget.bookinfo.ISBN;
          break;
      }
      if (text_val != null && text_val.length > 0)
        return text(
          text_val,
          isBold: _isBold,
          size: 16,
          padding: EdgeInsets.only(top: top_margin, bottom: 16.0),
        );
      else
        return Container(width: 0, height: 0);
    }
  }

  List<Widget> _buildcategoryandflags() {
    if (widget.bookinfo != null) {
      return [
        Material(
          borderRadius: BorderRadius.circular(20.0),
          shadowColor: Colors.black87,
          color: Colors.blue,
          elevation: 15.0,
          child: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Chip(
                label: Text(widget.bookinfo.category),
                padding: EdgeInsets.all(4.0),
                labelStyle: TextStyle(fontSize: 12, color: Colors.white),
                backgroundColor: Colors.blue,
              )),
        ),
        SizedBox(width: 4.0),
        _buildFlags()
      ];
    } else
      return [];
  }

  Widget _buildFlags(){
      if(widget.bookinfo != null && widget.bookinfo.flags.length > 0){
        return Material(
          borderRadius: BorderRadius.circular(20.0),
          shadowColor: Colors.black87,
          color: Colors.red[400],
          elevation: 15.0,
          child: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Chip(
                label: Text(widget.bookinfo.flags),
                padding: EdgeInsets.all(4.0),
                labelStyle: TextStyle(fontSize: 12, color: Colors.white),
                backgroundColor: Colors.red[400],
              )),
        );
      }else
        return Container(width: 0,height: 0,);
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
              child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(5),
                  child: Image(
                    image: _image == null
                        ? getImage()
                        :FileImage(_image),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
        ),
        text(_image_tip, color: Colors.black45, size: 12)
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
      if (this.groupValue != '借阅') {
        _isBorrowType = false;
        borrowtime_controller.clear();
        returntime_controller.clear();
      } else
        _isBorrowType = true;
    });
  }

  Future _selectImage() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return new Container(
              height: 200,
              child: new Column(
                children: <Widget>[
                  SizedBox(height: 16),
                  Text('图片来源选择', style: TextStyle(fontSize: 16)),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text('相册', textAlign: TextAlign.center),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text('摄像头', textAlign: TextAlign.center),
                      )
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: IconButton(
                            icon: Icon(Icons.photo_library),
                            iconSize: 96,
                            color: Colors.green,
                            highlightColor: Colors.yellow,
                            tooltip: '相册',
                            onPressed: () {
                              Navigator.pop(context);
                              showImage(ImageSource.gallery);
                            }),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            // padding:EdgeInsets.only(bottom: 5),
                            child: IconButton(
                                icon: Icon(Icons.camera_alt),
                                iconSize: 96,
                                color: Colors.green,
                                highlightColor: Colors.yellow,
                                tooltip: '摄像头',
                                onPressed: () {
                                  Navigator.pop(context);
                                  showImage(ImageSource.camera);
                                })),
                      )
                    ],
                  ),
                ],
              ));
        });
  }

  void showImage(var src) async {
    var image = await ImagePicker.pickImage(source: src);
    setState(() {
      //must select a image
      if (image != null) {
        _image = image;
        _image_tip = '待保存图片';
      }
    });
  }
  void _saveBookInfo() {
    /*dbutil.getImage(1).then((image_str){
      setState(() {
        _m_image = MemoryImage(base64.decode(image_str));
        _buildTopLeft();
      });

    });*/
    if (borrowtime_controller.text != null &&
        borrowtime_controller.text.length > 0 &&
        returntime_controller.text != null &&
        returntime_controller.text.length > 0) {
      DateTime borrowtime =
          DateTime.parse(borrowtime_controller.text + time_suffix);
      DateTime returntime =
          DateTime.parse(returntime_controller.text + time_suffix);
      if (borrowtime.isAfter(returntime) ||
          borrowtime.isAtSameMomentAs(returntime)) {
        setState(() {
          showDialog(
              context: context,
              child: new AlertDialog(
                content: new Text('借阅时间不能大于等于归还时间'),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: new Text('确定'))
                ],
              ));
        });
        return;
      }
    }
    if (widget.bookinfo == null) {
      widget.bookinfo = new BookInfo(
          null,
          bookname_controller.text,
          '',
          '',
          '',
          '',
          favor_rating,
          borrowtime_controller.text,
          returntime_controller.text,
          groupValue,
          owner_controller.text,
          category_controller.text,
          flag_controller.text,
          -1,
          remark_controller.text);

      dbutil.insertBookInfo(widget.bookinfo).then((retVal) {
        String message = '添加书籍成功';
        var back_color = Colors.green;
        if (retVal < 0) {
          message = '添加书籍失败';
          back_color = Colors.red;
          setState(() {
            Fluttertoast.showToast(
                msg: message,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: back_color,
                textColor: Colors.white);
          });
        } else {
          widget.bookinfo.setBookId(retVal);
          if (_image != null) {
            dbutil.insertImage(_image, widget.bookinfo.id, widget.bookinfo.bookname).then((imageId) {
              if (imageId < 0) message += ',图片添加失败';
            });
          }
          setState(() {
            Fluttertoast.showToast(
                msg: message,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: back_color,
                textColor: Colors.white);
            _image_tip = '图片已保存';
            _buildtopContent();
          });
        }
      });
    }
  }

  /* ListView(padding: EdgeInsets.all(4.0), shrinkWrap: true, children: <
                Widget>[*/
  Widget _buildbottomContent() {
    return new Container(
        color: backColors, // Colors.yellow[300],
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 16,
              ),
              new RaisedButton(
                  color: Colors.green,
                  padding: EdgeInsets.all(5.0),
                  child: Text('保存',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  textColor: Colors.white,
                  colorBrightness: Brightness.light,
                  //按钮主题高亮
                  elevation: 10.0,
                  //按钮下面的阴影
                  highlightElevation: 10.0,
                  //高亮时候的阴影
                  disabledElevation: 10.0,
                  //按下的时候的阴影
                  onPressed: _isSaveButtonEnabled ? _saveBookInfo : null),
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
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: '借阅',
                      groupValue: groupValue,
                      title: Text('借阅', style: TextStyle(fontSize: 14)),
                      onChanged: (String val) {
                        _updateRadioVal(val);
                      })),
              Flexible(
                  flex: 1,
                  child: RadioListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: '购买',
                      groupValue: groupValue,
                      title: Text('购买', style: TextStyle(fontSize: 14)),
                      onChanged: (String val) {
                        _updateRadioVal(val);
                      })),
              Flexible(
                  flex: 1,
                  child: RadioListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: '赠送',
                      groupValue: groupValue,
                      title: Text('赠送', style: TextStyle(fontSize: 14)),
                      onChanged: (String val) {
                        _updateRadioVal(val);
                      })),
              Flexible(
                  flex: 1,
                  child: RadioListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: '其他',
                      groupValue: groupValue,
                      title: Text('其他', style: TextStyle(fontSize: 14)),
                      onChanged: (String val) {
                        _updateRadioVal(val);
                      })),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 16),
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
          Row(
            children: <Widget>[
              Flexible(
                  flex: 8,
                  child: new ListTile(
                      leading: Icon(Icons.assignment, size: 32),
                      title: TextField(
                        controller: bookname_controller,
                        onChanged: (text) {
                          if (text != null && text.length > 0) {
                            setState(() {
                              _isSaveButtonEnabled = true;
                            });
                          } else {
                            setState(() {
                              _isSaveButtonEnabled = false;
                            });
                          }
                        },
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
                      onPressed: _selectImage))
            ],
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                flex: 1,
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
                  trailing: new IconButton(
                      icon: Icon(Icons.date_range),
                      color: Colors.green,
                      onPressed: _isBorrowType
                          ? () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true, onChanged: (date) {
                                borrowtime_controller.text =
                                    DateFormat('yyyy-MM-dd').format(date);
                              }, onConfirm: (date) {
                                borrowtime_controller.text =
                                    DateFormat('yyyy-MM-dd').format(date);
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.zh);
                            }
                          : null),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                flex: 1,
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
                      onPressed: _isBorrowType
                          ? () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true, onChanged: (date) {
                                returntime_controller.text =
                                    DateFormat('yyyy-MM-dd').format(date);
                              }, onConfirm: (date) {
                                returntime_controller.text =
                                    DateFormat('yyyy-MM-dd').format(date);
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.zh);
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
                            }
                          : null),
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                  flex: 1,
                  //  child:Container(child:categroyCombo)
                  child: ListTile(
                    leading: Icon(
                      Icons.category,
                      size: 32,
                    ),
                    title: TextField(
                      controller: category_controller,
                      //任意写一个正则表达式，限制用户手动输入，选择输入不受影响
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp('dddd-dd-dd'))
                      ],
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
                        Icons.arrow_drop_down,
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
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: new ListTile(
                  leading: Icon(Icons.person_add, size: 32),
                  title: TextField(
                    controller: owner_controller,
                    style:
                        new TextStyle(fontSize: fontsize, color: Colors.grey),
                    decoration: new InputDecoration(
                      border: null,
                      labelText: '书籍所有人',
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
                        controller: flag_controller,
                        style: new TextStyle(
                            fontSize: fontsize, color: Colors.grey),
                        decoration: new InputDecoration(
                          border: null,
                          labelText: '书籍标签',
                          errorText: error,
                          //counterText: categorynodes_list[i].category
                        ),
                      ))),
            ],
          ),
          new ListTile(
              leading: Icon(Icons.comment, size: 32),
              title: TextField(
                controller: remark_controller,
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
