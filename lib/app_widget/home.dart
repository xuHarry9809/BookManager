import 'package:flutter/material.dart';
import 'package:loader_search_bar/loader_search_bar.dart';
import 'drawer_widget.dart';
import '../util/dbutil.dart';
import '../util/networkutil.dart';
import 'custcontroller/FancyFab.dart';
import 'forms/allbookview.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/*Material(color: Colors.blue,
          borderRadius: BorderRadius.circular(24.0),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(Icons.book,
                color: Colors.white, size: 30.0),
          ))),*/
class _MyHomePageState extends State<HomePage> {
  int _counter = 0;

  static const double icon_size = 30;
  static const double number_size = 28;
  static const double text_size = 16;
  static const double circle_maxradius = 28;

  int all_number = 0;
  int borrow_number = 0;
  int return_number = 0;

  AccountInfoPage accountInfoPage =
      new AccountInfoPage(username: 'testuser', email: 'testuser@163.com');

  @override
  void initState() {
   // dbutil.init();
   // initData();




    // TODO: implement initState
    super.initState();
    //dbutil.deleteDB();

    dbutil.init().then((onValue){
      dbutil.getStatData().then((retVal){
        setState(() {
          all_number = retVal;
          _buildStatBlock();
        });
      });
    });
    HttpUtil.getBingImageUrl().then((url) {
      accountInfoPage.setImageUrl(url);
    });

  }

  void initData(){
    dbutil.getStatData().then((retVal){
      setState(() {
        all_number = retVal;
        _buildStatBlock();
      });
    });

   // String query_allbook = 'select count(*) from bookinfo';
   // String query_borrowbook = query_allbook + " where borrow_time != ''";
   // String query_returnbook = query_allbook + " where return_time != ''";
    /*dbutil.getStatData(query_allbook).then((retAll){
        all_number = retAll;
        debugPrint(all_number.toString());
        dbutil.getStatData(query_borrowbook).then((retBorrow){
            borrow_number = retBorrow;
            debugPrint(borrow_number.toString());
            dbutil.getStatData(query_returnbook).then((retReturn){
              debugPrint(return_number.toString());
               return_number = retReturn;
               setState(() {
                   _buildStatBlock();
               });

            });
        });
    });*/

  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x702196F3),
        color: Colors.white,
        child: InkWell(child: child));
  }

  Widget _buildStatBlock(){
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: <Widget>[
          _buildTile(
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          new CircleAvatar(
                            child: Icon(Icons.book,
                                color: Colors.white, size: icon_size),
                            backgroundColor: Colors.blue,
                            maxRadius: circle_maxradius,
                          ),
                          SizedBox(width: 6),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('全部',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: text_size)),
                              Text(all_number.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: number_size))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          new CircleAvatar(
                            child: Icon(Icons.bookmark,
                                color: Colors.white, size: icon_size),
                            backgroundColor: Colors.blue,
                            maxRadius: circle_maxradius,
                          ),
                          SizedBox(width: 6),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('在借',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: text_size)),
                              Text(borrow_number.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: number_size))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          new CircleAvatar(
                            child: Icon(Icons.done,
                                color: Colors.white, size: icon_size),
                            backgroundColor: Colors.blue,
                            maxRadius: circle_maxradius,
                          ),
                          SizedBox(width: 6),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('已还',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: text_size)),
                              Text(return_number.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: number_size))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return /*DefaultTabController(
      length: 3,
      child:*/
        Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.refresh),
                    tooltip: '刷新',
                    onPressed: () { initData(); }),
                IconButton(
                      icon: Icon(Icons.search),
                      tooltip: '查找',
                      onPressed: () => debugPrint('查找书籍')
                )
              ],
              elevation: 20.0, //阴影
              /*bottom: TabBar(
                  unselectedLabelColor: Colors.black12,
                  indicatorColor: Colors.white12,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 2.0,
                  tabs: <Widget>[
                    Tab(icon:Icon(Icons.book),text: '全部',),
                    Tab(icon:Icon(Icons.bookmark_border),text: '在借',),
                    Tab(icon:Icon(Icons.library_books),text:'已还',),
                  ],
                ),*/
            ),
            body:Column(
              children: <Widget>[
                _buildStatBlock()
              ],
            ),
            drawer: accountInfoPage,
            floatingActionButton:
            new FancyFab()
        );
          /*TabBarView(
          children: <Widget>[
          //  Icon(Icons.book,size: 128.0,color: Colors.black12),
            new AllBookView(),
            Icon(Icons.book,size: 128.0,color: Colors.red),
            Icon(Icons.book,size: 128.0,color: Colors.red),
          ],
        ),*/
           /*FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: '扫描添加书籍',
          child: Icon(Icons.add_a_photo),
        ),*/ // This trailing comma makes auto-formatting nicer for build methods.
            // ),


  }
}
