import 'package:flutter/material.dart';
import '../forms/addbook_form.dart';
import '../home.dart';
class FancyFab extends StatefulWidget {

  FancyFab(/*{this.onPressed, this.tooltip, this.icon}*/);

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;


  @override
  initState() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});

      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.green,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget add() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'manual_input',
        mini: true,
        onPressed:() {
          //Navigator.pop(context);
          Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBookForm(bookinfo: null,))
          ).whenComplete((){
             MyHomePageState myhomepagestate = context.ancestorStateOfType(const TypeMatcher<MyHomePageState>());
             myhomepagestate.initData();
             
          });

        },
        tooltip: '手动录入',
        child: Icon(Icons.add),
      ),
    );
  }
  _onTapCategoryEditForm(BuildContext context){
    Navigator.pop(context);
    Navigator.of(context).pushNamed(AddBookForm.routeName);
  }
/*
  Widget image() {
    return Container(
      child: FloatingActionButton(
        onPressed: null,
        tooltip: 'Image',
        child: Icon(Icons.image),
      ),
    );
  }
*/
  Widget inbox() {
    return Container(
      child: FloatingActionButton(
        //mini: true,
        heroTag: 'scan_input',
        onPressed: ()=> _showMessage(),
        tooltip: '扫描添加',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  _showMessage(){
    setState(() {
      showDialog(
          context: context,
          child: new AlertDialog(
            content:new Text('Hello World'),
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
      //initData();
    });
  }
  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: add(),
        ),
       /* Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: image(),
        ),*/
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: inbox(),
        ),
        toggle(),
      ],
    );
  }
}