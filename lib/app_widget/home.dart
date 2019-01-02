import 'dart:convert';
import 'package:flutter/material.dart';
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
//  final List<String> menu_texts = ['标记为已还','编辑','删除'];
  AccountInfoPage accountInfoPage =
      new AccountInfoPage(username: 'testuser', email: 'testuser@163.com');

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
  }

  void initData() {
    String query_allbook = 'select count(*) from bookinfo';
    String query_borrowbook = query_allbook + " where borrow_time != '' and return_time == ''";
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
        if(books.length > 0){
            for(int i=0;i<books.length;i++){
               _getImageData(books[i].image_index,i);
            }
        }
        _buildBooksView();
      });
    });
  }

  ImageProvider showImage(String image_data){
     if(image_data != null && image_data.length > 0){
       return MemoryImage(base64.decode(image_data));
     }else{
      return AssetImage('image/bookcover.jpg');
     }
  }

  void _getImageData(int image_index,int index){
      if(image_index < 0)
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
            title:Text('删除确认对话框'),
            content: new Text('确定要删除'+ book.bookname + "吗?", style: new TextStyle(fontSize: 17.0)),
            actions: <Widget>[
              new FlatButton(
                child: new Text('取消'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('确定'),
                onPressed: (){
                  Navigator.of(context).pop();
                  dbutil.deleteBook(book.id, book.image_index);
                },
              )
            ],
          );
        }
    );
  }
  createTile(BookInfo book) => Hero(
      tag: book.bookname,
      child: Material(
        elevation: 15.0,
        shadowColor: Colors.grey.shade100,
        child: InkWell(
          onLongPress: (){
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context){
                return Container(
                  height: 170,
                  child: new ListView(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('编辑'),
                        onTap: (){
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddBookForm(bookinfo: book,))
                          ).whenComplete((){
                            initData();
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.flag),
                        title: Text('标记为已还'),
                        onTap: (){
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('删除'),
                        onTap: (){
                          Navigator.pop(context);
                          _askedToLoad(book);
                        },
                      )
                    ],
                  ),
                );
              }

            );
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
              alignment: const FractionalOffset(0.9, 0.1),
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(5),
                    color: Colors.white,
                    child: Image(
                        image:book.image_index < 0 ?AssetImage('image/bookcover.jpg'):showImage(book.image_data),
                        fit: BoxFit.cover
                    )
                ),
                Opacity(
                  opacity: 0.8,
                  child:Container(
                    color: Colors.green,
                    child:Text(book.bookname,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.normal))),
                )
              ]),
        ),
      ));

  Widget _buildBooksView() {
    if (books != null && books.length > 0) {
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
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20.0,
                  children:
                      books.map<Widget>((book) => createTile(book)).toList(),
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
                    onPressed: () {
                      initData();
                    }),
                IconButton(
                    icon: Icon(Icons.search),
                    tooltip: '查找',
                    onPressed: () => debugPrint('查找书籍'))
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
            body: Column(
              children: <Widget>[_buildStatBlock(), _buildBooksView()],
            ),
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
