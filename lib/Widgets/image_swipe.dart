import 'package:flutter/material.dart';

class ImageSwipe extends StatefulWidget {
final List? imagelist;
     ImageSwipe({this.imagelist});

  @override
  State<ImageSwipe> createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {

  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Stack(
        children: [
          PageView(
            onPageChanged: (num) {
              setState(() {
                _selectedPage = num;
              });
            },
            children: [
              for(var i=0; i < widget.imagelist!.length; i++)
                Container(
                  child: Image.network(""
                      "${widget.imagelist![i]}",
                    fit: BoxFit.cover,
                  ),
                )
            ],
          ),
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(var i=0; i < widget.imagelist!.length; i++)
                  AnimatedContainer(
                    duration: Duration(
                      milliseconds: 300,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    curve: Curves.easeOutCubic,
                    height: 10.0,
                    width: _selectedPage == i ? 35.0 : 10.0,
                   decoration: BoxDecoration(
                     color: Colors.black.withOpacity(0.3),
                     borderRadius: BorderRadius.circular(12.0),
                   ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
