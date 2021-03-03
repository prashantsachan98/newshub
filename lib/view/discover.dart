import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/controller/controller.dart';
import './homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:newshub/view/searched.dart';

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
    var _controller = TextEditingController();
    final controller = Get.put(Controller());
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
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Card(
                margin: EdgeInsets.all(5),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 2,
                      color: Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                // decoration: BoxDecoration(shape: BoxShape.circle),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (searchedNews) {
                          Get.off(Search(searchedNews));
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          hintText: 'Search...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.16,
                      child: IconButton(
                        onPressed: () => _controller.clear(),
                        icon: Icon(Icons.clear),
                      ),
                    )
                  ],
                )),
            Container(
              height: MediaQuery.of(context).size.height * 0.886,
              child: GridView.builder(
                padding: EdgeInsets.all(0),
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return Transform.scale(
                    scale: controller.newsType == data[index] ? 1.2 : 1,
                    child: Container(
                      child: InkWell(
                        splashColor: Colors.blue,
                        onTap: () {
                          controller.newsType = data[index].toString();
                          print(data[index].toString());
                          Navigator.of(context).push(new PageRouteBuilder(
                              opaque: true,
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                              pageBuilder: (BuildContext context, _, __) {
                                return MyHomePage();
                              },
                              transitionsBuilder: (_,
                                  Animation<double> animation,
                                  __,
                                  Widget child) {
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
                            Opacity(
                              opacity:
                                  controller.newsType == data[index] ? 1 : 0.4,
                              child: Image.asset(
                                "assets/icons/${data[index]}.png",
                                height: 80,
                                width: 75,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Text(
                              data[index],
                              style: controller.newsType == data[index]
                                  ? TextStyle(
                                      // color: Color(0xff8192A3),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)
                                  : TextStyle(
                                      // color: Color(0xff777777),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
