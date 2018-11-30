import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountInfoPage extends StatefulWidget{

  final String username;
  final String email;
  AccountInfoPage({this.username,this.email});

  @override
  State<StatefulWidget> createState(){
      return new _AccountInfoPageState();
  }
}

class _AccountInfoPageState extends State<AccountInfoPage>{
  @override
  void initState(){
    super.initState();
  }

  Widget build(BuildContext context){
        return  new Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[

            UserAccountsDrawerHeader(
               accountName: Text(widget.username,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
               accountEmail: Text(widget.email,style:TextStyle(fontSize: 12)),
               currentAccountPicture: CircleAvatar(
                 backgroundImage: new AssetImage('image/header3.jpeg'),
                 radius: 35.0,
               ),
              decoration: BoxDecoration(
                color: Colors.green[400],
                image: DecorationImage(
                    image:NetworkImage('https://cdn.pixabay.com/photo/2018/11/23/18/07/autumn-leaves-3834298_960_720.jpg'),
                    fit:BoxFit.cover,
                    colorFilter:ColorFilter.mode(
                        Colors.green[400].withOpacity(0.6),
                        BlendMode.hardLight,
                    )
                ),
              ),
            ),
            new Divider(),
            ListTile(
                leading: new CircleAvatar(child:Icon(Icons.local_florist),backgroundColor: Colors.blue,),
                title: Text('儿童文学',textAlign: TextAlign.left),
              ),
            ],
          ),
        );
  }
}