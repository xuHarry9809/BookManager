import 'package:flutter/material.dart';
import '../custcontroller/Combox.dart';
class EditCategoryForm extends StatefulWidget{

  static final String routeName='/editcategoryform';

  @override
  State<StatefulWidget>   createState() => new EditCategoryFormState();
}

class EditCategoryFormState extends State<EditCategoryForm>{

  final TextEditingController _controller = new TextEditingController();
  String error;

  List<Widget> categoryList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _buildCategories();
  }
  @override
  Widget build(BuildContext context){

    return new Scaffold(
      appBar: new AppBar(
          leading: new IconButton(
              icon: const Icon(Icons.close),
              color:Colors.white,
              onPressed:() => _closeForm(context)),
          title:new Text('添加/编辑分类',style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.green[500],
      ),
      body: new Container(
          child:new ListView(
            children: categoryList,
          ),
      ),
    );

  }

  _closeForm(BuildContext context){
    Navigator.of(context).pop();
  }

  List<Widget> _buildCategories(){
    categoryList = [];
    categoryList.add(
       new ListTile(
         leading: new IconButton(
             icon: Icon(Icons.close),
             color: Colors.grey,
             onPressed:_clearText
         ),
         title: new Theme(
                  data: new ThemeData(primaryColor: Colors.grey[500]),
                  child: new Column(
                    children: <Widget>[
                        new TextField(
                          controller: _controller,
                          style:TextStyle(
                            fontSize: 18.0,
                            color: Colors.green[700]
                          ),
                          decoration: new InputDecoration(
                            errorText: error,
                            labelText: '新建分类名',
                            labelStyle: new TextStyle(
                              color:Colors.grey[400]
                            )
                          ),
                        ),
                        new Combox(),
                    ],
                  )
         ),

       )
    );

  }

  // clear input text
  _clearText(){
    setState(() {
      _controller.clear();
      error = null;
      _buildCategories();
    });


  }
}