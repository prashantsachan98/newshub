import 'package:flutter/material.dart';
import 'package:newshub/main.dart';
import 'package:flutter/cupertino.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  List data = [
    'all',
    'trending',
    'top stories',
    'national',
    'business',
    'politics',
    'sports',
    'technology',
    'startups',
    'entertainment',
    'education',
    'international',
    'automobile',
    'science',
    'fashion',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          if (details.primaryVelocity > 10) {
            // User swiped Left

          } else if (details.primaryVelocity < 10) {
            // User swiped Right
            Navigator.pop(context);
          }
        },
        child: Container(
          child: GridView.builder(
            itemCount: data.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                splashColor: Colors.black45,
                onTap: () {
                  setState(() {
                    newsType = data[index].toString();
                  });
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute<bool>(
                      //fullscreenDialog: true,
                      builder: (BuildContext context) => MyHomePage(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Opacity(
                      opacity: 1,
                      child: Image.asset(
                        "assets/icons/${data[index]}.png",
                        height: 70,
                        width: 70,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(data[index])
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
