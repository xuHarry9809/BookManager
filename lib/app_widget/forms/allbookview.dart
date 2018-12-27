import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AllBookView extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new AllBookViewState();
}

class AllBookViewState extends State< AllBookView> {
  @override
  Widget build(BuildContext context) {

    return StaggeredGridView.count(
        crossAxisCount: null,
      staggeredTiles: ,
    );
  }
}