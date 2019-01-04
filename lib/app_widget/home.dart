import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_search_bar/loader_search_bar.dart';
import 'drawer_widget.dart';
import '../util/dbutil.dart';
import '../util/networkutil.dart';
import 'custcontroller/FancyFab.dart';
import '../model/book.dart';
import 'forms/addbook_form.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

/*Material(color: Colors.blue,
          borderRadius: BorderRadius.circular(24.0),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(Icons.book,
                color: Colors.white, size: 30.0),
          ))),*/
class MyHomePageState extends State<HomePage> {
  int _counter = 0;

  static const double icon_size = 24;
  static const double number_size = 20;
  static const double text_size = 12;
  static const double circle_maxradius = 24;

  int all_number = 0;
  int borrow_number = 0;
  int return_number = 0;
  List<BookInfo> books = [];
  bool bSearchVisible = true;

//  final List<String> menu_texts = ['标记为已还','编辑','删除'];
  AccountInfoPage accountInfoPage =
      new AccountInfoPage(username: 'testuser', email: 'testuser@163.com');

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollController = ScrollController(); //listview的控制器

  @override
  void dispose(){
    super.dispose();
    _scrollController.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // dbutil.deleteDB();
    dbutil.init().then((onValue) {
      initData();
    });
    HttpUtil.getBingImageUrl().then((url) {
      accountInfoPage.setImageUrl(url);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        debugPrint('滑动到了最底部');
      }
    });

  }

  void initData() {
    String query_allbook = 'select count(*) from bookinfo';
    String query_borrowbook =
        query_allbook + " where borrow_time != '' and return_time == ''";
    String query_returnbook = query_allbook + " where return_time != ''";
    dbutil.getStatData(query_allbook).then((retAll) {
      all_number = retAll;
      //debugPrint(all_number.toString());
      dbutil.getStatData(query_borrowbook).then((retBorrow) {
        borrow_number = retBorrow;
        //debugPrint(borrow_number.toString());
        dbutil.getStatData(query_returnbook).then((retReturn) {
          // debugPrint(return_number.toString());
          return_number = retReturn;
          setState(() {
            _buildStatBlock();
          });
        });
      });
    });
    dbutil.getAllBook().then((bookitems) {
      setState(() {
        books = bookitems;
        if (bookitems.length > 0) {
          for (int i = 0; i < bookitems.length; i++) {
            _getImageData(bookitems[i].image_index, i);
          }
        }
        _buildBooksView(bookitems);
      });
    });
  }

  ImageProvider showImage(String image_data) {
    if (image_data != null && image_data.length > 0) {
      return MemoryImage(base64.decode(image_data));
    } else {
      return AssetImage('image/bookcover.jpg');
    }
  }

  void _getImageData(int image_index, int index) {
    if (image_index < 0)
      books[index].setImageData("");
    else {
      dbutil.getImage(image_index).then((data) {
        books[index].setImageData(data);
      });
    }
  }

  Future<void> _askedToLoad(BookInfo book) async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('删除确认对话框'),
            content: new Text('确定要删除' + book.bookname + "吗?",
                style: new TextStyle(fontSize: 17.0)),
            actions: <Widget>[
              new FlatButton(
                child: new Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                  dbutil.deleteBook(book.id, book.image_index).then((bResult) {
                    String message = book.bookname + '已删除';
                    var back_color = Colors.green;
                    if (!bResult) {
                      message = book.bookname + '删除失败';
                      var back_color = Colors.red;
                    }
                    setState(() {
                      Fluttertoast.showToast(
                          msg: message,
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: back_color,
                          textColor: Colors.white);
                    });
                    initData();
                  });
                },
              )
            ],
          );
        });
  }

  void _remarkbook(BookInfo book) {
    dbutil.remarkBook(book.id).then((bSuccess) {
      setState(() {
        initData();
      });
    });
  }

  createTile(BookInfo book) => Hero(
      tag: book.bookname,
      child: Material(
        elevation: 15.0,
        shadowColor: Colors.grey.shade100,
        child: InkWell(
          onLongPress: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 170,
                    child: new ListView(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('编辑'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddBookForm(
                                          bookinfo: book,
                                        ))).whenComplete(() {
                              initData();
                            });
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.flag),
                          title: Text('标记为已还'),
                          onTap: () {
                            Navigator.pop(context);
                            _remarkbook(book);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('删除'),
                          onTap: () {
                            Navigator.pop(context);
                            _askedToLoad(book);
                          },
                        )
                      ],
                    ),
                  );
                });
            /*
            showMenu<String>(
                context: context,
                position: ,
                items:menu_texts.map((String val){
                  return new PopupMenuItem<String>(
                      child: new ListTile(
                        leading: Icon(Icons.visibility),
                        title: new Text(val),

                      )
                  );
                }).toList(),
            );*/
          },
          onTap: () {
            //   Navigator.pushNamed(context, 'detail/${book.title}');
          },
          child: Stack(
              // alignment: const FractionalOffset(0.9, 0.1),
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(5),
                    color: Colors.white,
                    child: Image(
                        image: book.image_index < 0
                            ? AssetImage('image/bookcover.jpg')
                            : showImage(book.image_data),
                        fit: BoxFit.cover)),
                Positioned(
                    left: 0,
                    bottom: 10,
                    child: Opacity(
                      opacity: 0.8,
                      child: Container(
                          color: Colors.green,
                          child: Text(book.bookname,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal))),
                    )),
                Positioned(
                    right: 0,
                    top: 10,
                    child: Opacity(
                      opacity: 0.8,
                      child: Container(
                          color: Colors.red,
                          child: Text(book.category,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal))),
                    )),
              ]),
        ),
      ));

  Widget _buildBooksView(List<BookInfo> list_book) {
    if (list_book != null && list_book.length > 0) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: CustomScrollView(
          primary: false,
          shrinkWrap: true,
          slivers: <Widget>[
            SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverGrid.count(
                  childAspectRatio: 2 / 3,
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20.0,
                  children: list_book
                      .map<Widget>((book) => createTile(book))
                      .toList(),
                ))
          ],
        ),
      );
    } else
      return Container(
        width: 0,
        height: 0,
      );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x702196F3),
        color: Colors.white,
        child: InkWell(child: child));
  }

  Widget _buildStatBlock() {
    return Padding(
      padding: EdgeInsets.all(18),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      if (choice.title == '刷新')
        initData();
      else if (choice.title == '查找') {
        setState(() {
          bSearchVisible = false;
        });
      }
    });
  }

  Widget _buildSearchWidget() {
    return new Container(
        height: 70.0,
        color: Colors.grey[100],
        child: new Padding(
            padding: const EdgeInsets.all(5),
            child: new Card(
                child: new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.search),
                    iconSize: 26,
                    color: Colors.green,
                    onPressed: () {},
                  ),
                  new Container(
                    //height: double.infinity, //This is extra
                    width: MediaQuery.of(context).size.width -
                        115.0, // Subtract sums of paddings and margins from actual width
                    child: new TextField(
                      controller: new TextEditingController(),
                      decoration: new InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                      // onChanged: onSearchTextChanged,
                    ),
                  ),
                  new IconButton(
                    icon: new Icon(Icons.cancel),
                    iconSize: 26,
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        bSearchVisible = true;
                      });
                      // onSearchTextChanged('');
                    },
                  ),
                ],
              ),
            ))));
  }
  Future<Null> _getData() {
    final Completer<Null> completer = new Completer<Null>();

    // 启动一下 [Timer] 在3秒后，在list里面添加一条数据，关完成这个刷新
   /* new Timer(Duration(seconds: 1), () {
      // 添加数据，更新界面
      setState(() {

      });

      // 完成刷新
      completer.complete(null);
    });*/

    return completer.future;
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
                PopupMenuButton<Choice>(
                  onSelected: _select,
                  itemBuilder: (BuildContext context) {
                    return choices.map((Choice choice) {
                      return PopupMenuItem<Choice>(
                          value: choice,
                          child: Row(
                            children: <Widget>[
                              Icon(choice.icon),
                              Text(choice.title),
                            ],
                          ));
                    }).toList();
                  },
                ),
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
            body: Stack(children: <Widget>[
              Column(
                children: <Widget>[
                  _buildStatBlock(),
                  Flexible(
                      child: RefreshIndicator(
                          key: _refreshIndicatorKey,
                          onRefresh: _getData,
                          child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _scrollController,
                              padding: new EdgeInsets.symmetric(vertical: 8.0),
                              children: <Widget>[_buildBooksView(books)])))
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Offstage(
                    offstage: bSearchVisible, child: _buildSearchWidget()),
              ),
            ]),
            drawer: accountInfoPage,
            floatingActionButton: new FancyFab());
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

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '刷新', icon: Icons.refresh),
  const Choice(title: '查找', icon: Icons.search),
];
