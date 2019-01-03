class BookInfo{

  int _id;                //书籍ID
  String _bookname;       //书名
  String _author;         //作者
  String _publishing;     //出版社
  String _ISBN;           //ISBN号
  String _public_time;    //出版时间
  double _favor_rate;     //喜爱程度
  String _remark;         //备注
  String _borrow_time;    //借入时间
  String _return_time;    //归还时间
  String _source;         //书籍来源，如购买，赠送....
  String _Owner;          //所有者
  String _category;       //书籍类别
  String  _flags;         //书籍标签
  int _image_index;       //书籍图片索引
  String _image_data;     //图片数据缓存

  int get id => _id;
  String get bookname => _bookname;
  String get author => _author;
  String get publishing => _publishing;
  String get ISBN => _ISBN;
  String get public_time => _public_time;
  double get favor_rate => _favor_rate;
  String get borrow_time => _borrow_time;
  String get return_time => _return_time;
  String get source => _source;
  String get Owner => _Owner;
  String get category => _category;
  String get flags => _flags;
  int get image_index => _image_index;
  String get remark => _remark;
  String get image_data => _image_data;

  BookInfo(this._id,
           this._bookname,
           this._author,
           this._publishing,
           this._ISBN,
           this._public_time,
           this._favor_rate,
           this._borrow_time,
           this._return_time,
           this._source,
           this._Owner,
           this._category,
           this._flags,
           this._image_index,
           this._remark);

  void setImageData(String data){
    _image_data = data;
  }

  void setBookId(int id){
    _id = id;
  }

  void setBorrowtime(String time){
    _borrow_time = time;
  }

  void setReturntime(String time){
    _return_time = time;
  }

  void setFavorrate(double rate){
    _favor_rate = rate;
  }

  void setSource(String source){
    _source = source;
  }

  void setOwner(String owner){
    _Owner = owner;
  }

  void setCategory(String category){
    _category = category;
  }

  void setFlags(String flag){
    _flags = flag;
  }

  void setRemark(String remark){
    _remark = remark;
  }

  Map<String, dynamic> toMap() =>{
    //'id' :_id,
   // 'bookname': _bookname,
    //'author': _author == null?'':_author,
    //'publishing':_publishing == null?'':_publishing,
    //'ISBN':_ISBN == null?'':_ISBN,
   // 'public_time':_public_time == null?'':_public_time,
    'favor_rate':_favor_rate,
    'remark':_remark,
    'borrow_time':_borrow_time,
    'return_time': _return_time,
    'source': _source,
    'Owner': _Owner,
    'category': _category,
    'flags': _flags,
    //'imageindex:': _image_index,
  };

  BookInfo.fromMap(Map<String,dynamic> map){
    _id = map['id'];
    _bookname = map['bookname'];
    _author = map['author'];
    _publishing = map['publishing'];
    _ISBN = map['ISBN'];
    _public_time = map['public_time'];
    _favor_rate = map['favor_rate'];
    _remark = map['remark'];
  //  _readStatus = map['readStatus'];
    _borrow_time = map['borrow_time'];
    _return_time = map['return_time'];
    //_buy_time = map['buy_time'];
    _source = map['source'];
    _Owner = map['Owner'];
    _category = map['category'];
    _flags = map['flags'];
    _image_index = map['imageindex'];
  }

}