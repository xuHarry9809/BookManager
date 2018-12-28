import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AllBookView extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new AllBookViewState();
}

class AllBookViewState extends State< AllBookView> {

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () { print('Not set yet'); },
            child: child
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return StaggeredGridView.count(
              crossAxisCount:1,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: <Widget>[
                _buildTile(
                  Padding
                    (
                    padding: const EdgeInsets.all(24.0),
                    child: Row
                      (
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>
                        [
                          Column
                            (
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>
                            [
                              Text('Total Views', style: TextStyle(color: Colors.blueAccent)),
                              Text('265K', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0))
                            ],
                          ),
                          Material
                            (
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(24.0),
                              child: Center
                                (
                                  child: Padding
                                    (
                                    padding: const EdgeInsets.all(16.0),
                                    child: Icon(Icons.timeline, color: Colors.white, size: 30.0),
                                  )
                              )
                          )
                        ]
                    ),
                  ),
                ),
              ],
              staggeredTiles: [
                StaggeredTile.extent(2, 110.0),
             ]
    );
  }
}