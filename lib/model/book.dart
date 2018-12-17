class BookInfo{

  int _id;                //书籍ID
  String _bookname;       //书名
  String _author;         //作者
  String _publishing;     //出版社
  String _ISBN;           //ISBN号
  String _public_time;    //出版时间
  double _favor_degree;   //喜爱程度
  String _remark;         //备注
  String _readStatus;     //阅读状态
  String _borrow_time;    //借入时间
  String _return_time;    //归还时间
  String _buy_time;       //购买时间
  String _source;         //书籍来源，如购买，赠送....
  int _Owner;             //所有者
  int _categoryId;        //书籍类别
  String  _flags;         //书籍标签
  int _image_index;       //书籍图片索引

  int get id => _id;
  String get bookname => _bookname;
  String get author => _author;
  String get publishing => _publishing;
  String get ISBN => _ISBN;
  String get public_time => _public_time;
  double get favor_degree => _favor_degree;
  String get remark => _remark;
  String get readStatus => _readStatus;
  String get borrow_time => _borrow_time;
  String get return_time => _return_time;
  String get buy_time => _buy_time;
  String get source => _source;
  int get Owner => _Owner;
  int get categoryId => _categoryId;
  String get flags => _flags;
  int get image_index => _image_index;

  Map<String, dynamic> toMap(){
    var map = new Map<String,dynamic>();
    if(_id != null)
      map['id'] = _id;
    map['bookname'] = _bookname;
    map['author'] = _author;
    map['publishing'] = _publishing;
    map['ISBN'] = _ISBN;
    map['public_time'] = _public_time;
    if(_favor_degree != null)
      map['favor_degree'] = _favor_degree;
    map['remark'] = _remark;
    map['readStatus'] = _readStatus;
    map['borrow_time'] = _borrow_time;
    map['return_time'] = _return_time;
    map['buy_time'] = _buy_time;
    map['source'] = _source;
    if(_Owner != null)
      map['Owner'] = _Owner;
    if(_categoryId != null)
      map['categoryId'] = _categoryId;
    map['flags'] = _flags;
    if(_image_index != null)
      map["image_index"] = _image_index;

  }

  BookInfo.fromMap(Map<String,dynamic> map){
    _id = map['id'];
    _bookname = map['bookname'];
    _author = map['author'];
    _publishing = map['publishing'];
    _ISBN = map['ISBN'];
    _public_time = map['public_time'];
    _favor_degree = map['favor_degree'];
    _remark = map['remark'];
    _readStatus = map['readStatus'];
    _borrow_time = map['borrow_time'];
    _return_time = map['return_time'];
    _buy_time = map['buy_time'];
    _source = map['source'];
    _Owner = map['Owner'];
    _categoryId = map['categoryId'];
    _flags = map['flags'];
    _image_index = map["image_index"];
  }

}