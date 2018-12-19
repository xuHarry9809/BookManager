import 'package:flutter/material.dart';
import '../custcontroller/Combox.dart';
import '../../util/dbutil.dart';
import '../../model/categorynode.dart';

class EditCategoryForm extends StatefulWidget{

  static final String routeName='/editcategoryform';

  @override
  State<StatefulWidget>   createState() => new EditCategoryFormState();
}

class EditCategoryFormState extends State<EditCategoryForm>{

  final TextEditingController _controller = new TextEditingController();
  TextEditingController _updateController = new TextEditingController();

  String error;
  String updateError;
  List<Widget> categoryList = [];

  Combox combox = new Combox();

  List<CategoryNode> categorynodes_list = new List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();

  }

  void initData(){
    dbutil.getAllBookCategory().then((categorynodes){
      setState(() {
        categorynodes_list.clear();
        categorynodes.forEach((node){
          categorynodes_list.add(CategoryNode.fromMap(node));
        });
        _buildCategories(null);
        //  debugPrint(category_list.length.toString());
      });
    });

  }

  @override
  Widget build(BuildContext context){

    return new Scaffold(
      appBar: new AppBar(
          leading: new IconButton(
              icon: const Icon(Icons.close),
              color:Colors.black87,
              onPressed:() => _closeForm(context)),
          title:new Text('添加/编辑分类',style: const TextStyle(color: Colors.black87)),
          backgroundColor: Colors.green,
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

  List<Widget> _buildCategories(int editindex){
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
                        combox,
                    ],
                  )
         ),
         trailing: new IconButton(
             padding: EdgeInsets.only(right: 20.0),
             icon: const Icon(Icons.check),
             color:Colors.green,
             onPressed: _onSave),
       )
    );

    for(int i=0;i<categorynodes_list.length;i++){
      if(editindex !=null && editindex == i){
          if(updateError == null || updateError.isEmpty)
              _updateController = new TextEditingController(text:categorynodes_list[i].category);
          categoryList.add(
            new ListTile(
                leading: new IconButton(
                    icon: const Icon(Icons.close),
                    onPressed:() => _onCacelEdit(i)
                ),
                title: new Theme(
                    data: new ThemeData(
                      primaryColor: Colors.green[500],
                    ),
                    child:new TextField(
                        controller: _updateController,
                        autofocus: true,
                        style:new TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey
                        ),
                        decoration: new InputDecoration(
                          border: null,
                          errorText: updateError,
                          counterText: categorynodes_list[i].category
                        ),
                    ),
                ),
              trailing: new IconButton(
                  padding: EdgeInsets.only(right: 20.0),
                  icon: const Icon(Icons.check),
                  color: Colors.green,
                  onPressed: ()=>_updateCategory(i)
              ),
            )
          );

      }else{
          categoryList.add(
            new ListTile(
              leading: new CircleAvatar(
                backgroundColor: Colors.blue.shade400,
                child: new Text(categorynodes_list[i].id.toString(),style: TextStyle(color: Colors.white),),
              ),/* new IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: null
              )*/
              title:new Text(categorynodes_list[i].category),
              trailing: new IconButton(
                  padding: EdgeInsets.only(right: 20.0),
                  icon: const Icon(Icons.edit),
                  onPressed:() => _editCategoryAt(i)
              ),
            )
          );
      }
    }
  }


  _updateCategory(index){
    if(_updateController.text.isNotEmpty){
      dbutil.updateCategory(_updateController.text, categorynodes_list[index].id).then((bSuccess){
          String message = '更新失败';
          if(bSuccess)
            message='更新成功';
          setState(() {
            showDialog(
                context: context,
                child: new AlertDialog(
                  content:new Text(message),
                  actions: <Widget>[
                    new FlatButton(
                        onPressed:(){
                          Navigator.pop(context);
                        },
                        child: new Text('确定')
                    )
                  ],
                )
            );
            initData();
          });

      });
    }else{
      updateError= '请输入合法分类名';
      _buildCategories(null);
    }

  }

  _editCategoryAt(index){
    setState(() {
       _updateController.clear();
       updateError = null;
       _buildCategories(index);
    });
  }
  ///cancel edit status
  _onCacelEdit(index){
      setState(() {
          _buildCategories(null);
      });
  }

  ///clear input text
  _clearText() {
    setState(() {
      _controller.clear();
      error = null;
      _buildCategories(null);
    });
  }

  ///save category
  _onSave(){

    if(_controller.text.isEmpty){
        setState(() {
          showDialog(
            context: context,
            child: new AlertDialog(
              content:new Text('分类名不能为空'),
              actions: <Widget>[
                new FlatButton(
                    onPressed:(){
                      Navigator.pop(context);
                    },
                    child: new Text('确定')
                )
              ],
            )
          );
        });
        return;
    }
    dbutil.insertCategory(_controller.text, combox.getValue()).then((bSuccess){
        String retVal='插入失败';
        if(bSuccess)
          retVal = '插入成功';
        setState(() {
          showDialog(
              context: context,
              child: new AlertDialog(
                content:new Text(retVal),
                actions: <Widget>[
                  new FlatButton(
                      onPressed:(){
                        Navigator.pop(context);
                      },
                      child: new Text('确定')
                  )
                ],
              )
          );
        });
    });



  }
}