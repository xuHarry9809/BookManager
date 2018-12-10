import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/dbutil.dart';
import '../util/networkutil.dart';
import '../model/categorynode.dart';
import 'forms/editcategory_form.dart';

class AccountInfoPage extends StatefulWidget{

  final String username;
  final String email;
  String image_url;
  /*'https://cdn.pixabay.com/photo/2018/11/23/18/07/autumn-leaves-3834298_960_720.jpg'*/
  AccountInfoPage({this.username,this.email});
  //set bing picture url
  void setImageUrl(url){
    image_url = url;
  //  debugPrint(this.image_url);
  }
  @override
  State<StatefulWidget> createState(){
      return new _AccountInfoPageState();
  }
}

class _AccountInfoPageState extends State<AccountInfoPage>{

  List<CategoryNode> category_list = new List();
  @override
  void initState(){
    super.initState();
    getAllBookCategory();
  }

  //get book category from db
  void getAllBookCategory(){
    dbutil.getAllBookCategory().then((categorynodes){
      setState(() {
        categorynodes.forEach((node){
          category_list.add(CategoryNode.fromMap(node));
        });
      //  debugPrint(category_list.length.toString());
      });
    });
  }

  // add Drawer Widgets
  Widget build(BuildContext context){
        return  new Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: _buildDrawList(context),
          ),
        );
  }

  List<Widget> _buildDrawList(BuildContext context){
    List<Widget> children = [];
    children..addAll(_buildUserAccount(context))
      ..addAll(_buildActions(context))
      ..addAll([new Divider()])
      ..addAll(_buildBookCategory(context))
      ..addAll([new Divider()])
      ..addAll(_buildBottomControl(context));
    return children;
  }


  List<Widget> _buildBottomControl(BuildContext context) {
    return [
      new ListTile(
        trailing: Icon(Icons.help),
        title: Text('关于',textAlign: TextAlign.left),
      )
    ];
  }

  List<Widget> _buildUserAccount(BuildContext context){
      return [
        new UserAccountsDrawerHeader(
          accountName: Text(widget.username,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.blue)),
          accountEmail: Text(widget.email,style:TextStyle(fontSize: 12,color: Colors.blue)),
          currentAccountPicture: CircleAvatar(
            backgroundImage: new AssetImage('image/header3.jpeg'),
            radius: 35.0,
          ),
          decoration: BoxDecoration(
            color: Colors.green[400],
            image: DecorationImage(
                image:NetworkImage(widget.image_url),
                fit:BoxFit.cover,
                colorFilter:ColorFilter.mode(
                  Colors.green[100].withOpacity(0.3),
                  BlendMode.hardLight,
                )
            ),
          ),
        )
      ];
  }

  List<Widget> _buildBookCategory(BuildContext context){
     List<Widget> categoryListTiles = [];
     
     category_list.forEach((node){
        categoryListTiles.add(
            new ListTile(
              trailing: /*new CircleAvatar(child:*/Icon(IconData(node.iconindex, fontFamily: 'MaterialIcons'))/*)*/,
              title: Text(node.category,textAlign: TextAlign.left),
            )
        );
     });

     categoryListTiles.add(
         new ListTile(
           leading: Icon(Icons.add),
           title: Text('添加/编辑分类',textAlign: TextAlign.center,style: TextStyle(color: Colors.red[900])),
           onTap:() => _onTapCategoryEditForm(context),
         )
     );
     return categoryListTiles;
  }

  _onTapCategoryEditForm(BuildContext context){
     Navigator.pop(context);
     Navigator.of(context).pushNamed(EditCategoryForm.routeName);
  }
  List<Widget> _buildActions(BuildContext context){
    return [
      new ListTile(
        leading: Icon(Icons.account_circle),
        title:Text('账户',textAlign: TextAlign.left,style: TextStyle(color: Colors.blue[800]))
      ),
      new ListTile(
          leading: Icon(Icons.settings),
          title:Text('设定',textAlign: TextAlign.left,style: TextStyle(color: Colors.blue[800]))
      ),
      new ListTile(
          leading: Icon(Icons.search),
          title:Text('搜索',textAlign: TextAlign.left,style: TextStyle(color: Colors.blue[800]))
      )
    ];
  }

}