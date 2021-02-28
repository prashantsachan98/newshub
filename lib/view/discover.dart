import 'package:flutter/material.dart';
import 'package:newshub/main.dart';
import 'package:flutter/cupertino.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  List data = [
    'all_news',
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
                  Navigator.of(context).push(new PageRouteBuilder(
                      opaque: true,
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (BuildContext context, _, __) {
                        return MyHomePage();
                      },
                      transitionsBuilder:
                          (_, Animation<double> animation, __, Widget child) {
                        return new SlideTransition(
                          child: child,
                          position: new Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                        );
                      }));
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Opacity(
                      opacity: 1,
                      child: Image.asset(
                        "assets/icons/${data[index]}.png",
                        height: 95,
                        width: 80,
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
