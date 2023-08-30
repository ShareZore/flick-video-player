import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import './multi_manager/flick_multi_manager.dart';
import './multi_manager/flick_multi_player.dart';
import '../utils/mock_data.dart';

class FeedPlayer extends StatefulWidget {
  FeedPlayer({Key? key}) : super(key: key);

  @override
  _FeedPlayerState createState() => _FeedPlayerState();
}

class _FeedPlayerState extends State<FeedPlayer> {
  List items = mockData['items'];

  late FlickMultiManager flickMultiManager;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    flickMultiManager = FlickMultiManager();
  }

  @override
  Widget build(BuildContext context) {
    print("top:${MediaQuery.of(context).padding.top}");

    print("bottom:${MediaQuery.of(context).padding.bottom}");

    print("height:${MediaQuery.of(context).size.height}");

    double h = MediaQuery.of(context).size.height -
        80 -
        MediaQuery.of(context).padding.top;

    print("高度:${h}");

    return VisibilityDetector(
      key: ObjectKey(flickMultiManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && this.mounted) {
          flickMultiManager.pause();
        }
      },
      child: Column(
        children: [
          Container(
            height: h,
            color: Colors.red,
            child: PageView.builder(
              physics: PageScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Container(
                  height: h,
                  child: FlickMultiPlayer(
                    url: items[index]['trailer_url'],
                    flickMultiManager: flickMultiManager,
                    image: items[index]['image'],
                  ),
                );
              },
            ),
            // child: ListView.builder(
            //   physics: PageScrollPhysics(),
            //   itemCount: items.length,
            //   itemBuilder: (context, index) {
            //     return Container(
            //       height: 600,
            //       child: FlickMultiPlayer(
            //         url: items[index]['trailer_url'],
            //         flickMultiManager: flickMultiManager,
            //         image: items[index]['image'],
            //       ),
            //     );
            //   },
            // ),
          ),
          Expanded(
            child: Container(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  //compute
  Future<void> csFuture() async {
    // await asyncCountEven(1000000000000);
    //参数1：静态方法名  参数2：方法参数（多参数用map）
    var result = await compute(asyncCountEven, 10000000);
    print(result);
  }

  static Future<int> asyncCountEven(int num) async {
    int count = 0;
    while (num > 0) {
      if (num % 2 == 0) {
        count++;
      }
      num--;
    }
    return count;
  }


}
