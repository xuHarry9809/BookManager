import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';
import '../custcontroller/rating_bar.dart';

class AddBookForm extends StatefulWidget{

  static final String routeName ='/addbookform';

  @override
  State<StatefulWidget>   createState() => new AddBookFormState();
}

class AddBookFormState extends State<AddBookForm>{

  Future<File> _imageFile;

  List<Widget> widget_list = [];
  static final backColors = Colors.yellow[400];

  String error;
  TextEditingController bookname_controller = new TextEditingController();
  TextEditingController author_controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  _buildWidget();
  }

  List<Widget> _buildWidget(){
      widget_list = [];
      widget_list..addAll(_buildBookBaseInfo());
  }

  Widget _previewImage(){
     return FutureBuilder<File>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot){
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Image.file(snapshot.data);
          } else if (snapshot.error != null) {
              return new Icon(Icons.book,size: 144);
          } else {
            return new Image(
              image: AssetImage('image/bookcover.jpg'),
              fit: BoxFit.cover,
            );
          }
        });
  }
  List<Widget> _buildBookBaseInfo(){

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


  Widget _buildTopRight(){
    return  Column(
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
              '价格',
              isBold: true,
              padding: EdgeInsets.only(right: 8.0),
            ),
            RatingBar(rating: 3.5)
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
              child:Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Chip(
                    label: Text('儿童文学'),
                    padding: EdgeInsets.all(8.0),
                    labelStyle: TextStyle(fontSize: 20,color: Colors.white),
                    backgroundColor: Colors.blue,

                  )
              ),
            ),
            SizedBox(width:8.0),
            Material(
              borderRadius: BorderRadius.circular(20.0),
              shadowColor: Colors.black87,
              color: Colors.red[400],
              elevation: 15.0,
              child:Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Chip(
                    label: Text('课外读物'),
                    padding: EdgeInsets.all(8.0),
                    labelStyle: TextStyle(fontSize: 20,color: Colors.white),
                    backgroundColor: Colors.red[400],

                  )
              ),
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

  Widget _buildTopLeft(){
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

  Widget _buildtopContent(){
    return Container(
      color: backColors,//Colors.yellow[300],
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

  Widget _buildbottomContent(){
    return new Expanded(child: Container(
      color:backColors,// Colors.yellow[300],
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Spacer(),
              Text('书籍详情    ',style: TextStyle(fontSize: 20,color: Colors.black45)),
            ],
          ),
          new Divider(),
          SizedBox(height: 16),
          Row(
            children: <Widget>[
              Flexible(
                  flex: 2,
                  child: new ListTile(
                      leading: Icon(Icons.assignment,size: 32),
                      title: TextField(
                        controller: bookname_controller,
                        style:new TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey
                        ),
                        decoration: new InputDecoration(
                          border: null,
                          labelText: '书名',
                          errorText:error,
                          //counterText: categorynodes_list[i].category
                        ),

                      )
                  ),
              ),
              Flexible(
                flex: 2,
                child: new ListTile(
                    leading: Icon(Icons.person,size: 32),
                    title: TextField(
                      controller: author_controller,
                      style:new TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey
                      ),
                      decoration: new InputDecoration(
                        border: null,
                        labelText: '作者',
                        errorText:error,
                        //counterText: categorynodes_list[i].category
                      ),

                    )
                ),
              )
            ],
          ),
        ],
      ),
    ));
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
  Widget build(BuildContext context){
    //final topRight =
    //final topLeft =
    //final topContent =
    return Scaffold(
      appBar: new AppBar(
        backgroundColor:backColors,//Colors.yellow[300],
        elevation: 0.5,
        leading: new IconButton(
          icon: const Icon(Icons.close),
          color:Colors.black45,
          onPressed:() => _closeForm(context)
        ),
        title:new Text('添加/编辑书籍信息',style: TextStyle(color: Colors.black45),),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              color: Colors.black45,
              tooltip: '保存',
              onPressed: () => debugPrint('书籍信息已保存')
          ),
        ],
        //backgroundColor: Colors.green[500],
      ),
      body: Column(
        children: <Widget>[
            _buildtopContent(),
           _buildbottomContent()
        ],
      ),
    );
  }

  _closeForm(BuildContext context){
      Navigator.of(context).pop();
  }
}