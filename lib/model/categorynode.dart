class CategoryNode{
  int _id;
  String _category;
  int _iconindex;

  CategoryNode();

  int get id => _id;
  String get category => _category;
  int get iconindex => _iconindex;

  Map<String, dynamic> toMap(){
    var map = new Map<String,dynamic>();
    if(_id != null)
      map['id'] = _id;

    map['categoryname'] = _category;
    map['iconindex'] = _iconindex;
  }

  CategoryNode.fromMap(Map<String,dynamic> map){
      _id = map['id'];
      _category = map['categoryname'];
      _iconindex = map['iconindex'];
  }
}