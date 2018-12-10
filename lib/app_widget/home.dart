import 'package:flutter/material.dart';
import 'drawer_widget.dart';
import '../util/dbutil.dart';
import '../util/networkutil.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int _counter = 0;
  AccountInfoPage accountInfoPage  = new AccountInfoPage(username:'testuser',email:'testuser@163.com');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 //   dbutil.deleteDB();
    dbutil.init();
    HttpUtil.getBingImageUrl().then((url){
       accountInfoPage.setImageUrl(url);
    });
  }
  void _incrementCounter() {
   // HttpUtil.getBingImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          /*
          leading: IconButton(
              icon: Icon(Icons.menu),
              tooltip: '账户',
              onPressed: () => debugPrint('显示个人账户')
          ),*/
          title: Text(widget.title),
          centerTitle: true,

          actions: <Widget>[

            IconButton(
                icon: Icon(Icons.search),
                tooltip: '查找',
                onPressed: () => debugPrint('查找书籍')
            ),

          ],
          elevation: 20.0,//阴影
          bottom: TabBar(
            unselectedLabelColor: Colors.black12,
            indicatorColor: Colors.white12,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2.0,
            tabs: <Widget>[
              Tab(icon:Icon(Icons.book),text: '全部',),
              Tab(icon:Icon(Icons.bookmark_border),text: '在借',),
              Tab(icon:Icon(Icons.library_books),text:'已还',),
            ],
          ),
        ),
        body:TabBarView(
          children: <Widget>[
            Icon(Icons.book,size: 128.0,color: Colors.black12),
            Icon(Icons.book,size: 128.0,color: Colors.red),
            Icon(Icons.book,size: 128.0,color: Colors.red),
          ],
        ),
        drawer:accountInfoPage,

        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: '扫描添加书籍',
          child: Icon(Icons.add_a_photo),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),

    );

  }
}
