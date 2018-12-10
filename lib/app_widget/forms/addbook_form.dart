import 'package:flutter/material.dart';

class AddBookForm extends StatefulWidget{

  static final String routeName ='/addbookform';

  @override
  State<StatefulWidget>   createState() => new AddBookFormState();
}

class AddBookFormState extends State<AddBookForm>{
  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: const Icon(Icons.close),
          color:Colors.white,
          onPressed:() => _closeForm(context)
        ),
        title:new Text('添加/编辑书籍',style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[500],
      ),
      body: new Container(),
    );
  }

  _closeForm(BuildContext context){
      Navigator.of(context).pop();
  }
}