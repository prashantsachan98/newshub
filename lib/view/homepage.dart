import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:newshub/view/searched.dart';
import 'package:newshub/view/source.dart';
import 'package:screenshot/screenshot.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share/share.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../networking/api.dart';
import 'package:flutter/widgets.dart';
import '../model/news.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../transformers/transformer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/controller.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      })),
      // title: 'Flutter Demo',

      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = Get.put(Controller());

  PageController pageView = PageController();

  String url;

  var _webViewController;

  final _screenshotController = ScreenshotController();

  final List data = [
    'all_news',
    'trending',
    'top_stories',
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
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    var futureBuilder = FutureBuilder<News>(
      future: RestApiManager().fetchNews(controller.newsType),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                      scale: 0.5,
                      child: Container(
                        child: Center(
                            child: Image.asset('assets/images/newshub.png')),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.5,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                      ),
                    ),
                    //Padding(
                    //padding: EdgeInsets.only(top: 20.0),
                    //child: Text("Checking Your Internet Connection."),
                    //),
                  ],
                ),
              ),
            );
          default:
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else
              return createListView(context, snapshot);
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.black,
      /*appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        title: Container(
          width: MediaQuery.of(context).size.width * 1,
          child: Card(
            shadowColor: Color.fromRGBO(229, 19, 36, 1),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Text(
                'News Hub',
                style: GoogleFonts.lobster(
                    letterSpacing: 1,
                    fontSize: 30,
                    color: Color.fromRGBO(229, 19, 36, 1)),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
      ),*/
      body: futureBuilder,
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    return PageView(
      allowImplicitScrolling: true,
      onPageChanged: (_) {
        _webViewController?.loadUrl(controller.urlType);
      },
      controller: PageController(
        initialPage: 1,
      ),
      children: [
        Scaffold(
          body: Container(
            color: Colors.white,
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: Get.isDarkMode ? Colors.black87 : Colors.white,
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  color: Get.isDarkMode ? Colors.black87 : Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CupertinoSearchTextField(
                    padding: EdgeInsets.all(15),
                    onSubmitted: (searchText) {
                      searchText.isNotEmpty
                          ? Navigator.of(context).push(new PageRouteBuilder(
                              opaque: true,
                              transitionDuration:
                                  const Duration(microseconds: 1000),
                              pageBuilder: (BuildContext context, _, __) {
                                return Search(searchText);
                              },
                              transitionsBuilder: (_,
                                  Animation<double> animation,
                                  __,
                                  Widget child) {
                                return new SlideTransition(
                                  child: child,
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                );
                              }))
                          // ignore: unnecessary_statements
                          : null;
                    },
                    placeholder: 'search',
                    itemSize: 40,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Get.isDarkMode ? Colors.black87 : Colors.white,
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      itemCount: data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
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
                                    controller.newsType == data[index] ? 1 : 1,
                                child: Image.asset(
                                  "assets/icons/${data[index]}.png",
                                  height: 80,
                                  width: 75,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                data[index],
                                style: Get.isDarkMode
                                    ? TextStyle(
                                        // color: Color(0xff8192A3),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white)
                                    : TextStyle(
                                        // color: Color(0xff777777),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Screenshot(
          controller: _screenshotController,
          child: InkWell(
            onTap: () {
              _options(context);
            },
            child: TransformerPageView(
              onPageChanged: (_) {
                PaintingBinding.instance.imageCache.clear();
                PaintingBinding.instance.imageCache.clearLiveImages();
              },
              //pageController: TransformerPageController(viewportFraction: 0.),
              scrollDirection: Axis.vertical,
              transformer: DeepthPageTransformer(),
              curve: Curves.easeInBack,
              itemCount: snapshot.data.total,
              itemBuilder: (BuildContext context, int index) {
                controller.urlType = snapshot.data.articles[index].sourceUrl;
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 2, vertical: 1),

                  elevation: 10,
                  //color: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: Colors.blueGrey,
                                child: Image(
                                  height:
                                      MediaQuery.of(context).size.height * 0.45,
                                  width: MediaQuery.of(context).size.width * 1,
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    snapshot.data.articles[index].imageUrl,
                                    // scale: 0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                snapshot.data.articles[index].title,
                                style: GoogleFonts.roboto(
                                    fontSize: 19, fontWeight: FontWeight.w500),
                                softWrap: true,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Author :   ',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    snapshot.data.articles[index].authorName,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                snapshot.data.articles[index].description,
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  height: 1.5,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7),
                        InkWell(
                          splashColor: Colors.black,
                          onTap: null,
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 1,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.grey,
                              shadowColor: Colors.amberAccent,
                              // margin: EdgeInsets.symmetric(vertical: 10),
                              child: InkWell(
                                onTap: () {
                                  Get.to(Source(controller.urlType));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    //crossAxisAlignment: CrossAxisAlignment.b,
                                    children: [
                                      Text(
                                        ' Read more at ${snapshot.data.articles[index].sourceName}',
                                        style: TextStyle(
                                            // color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            shadowColor: Color.fromRGBO(0, 0, 0, 0),
            backgroundColor: Color.fromRGBO(0, 0, 0, 0),
          ),
          body: WebView(
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            initialUrl: controller.urlType,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        )
      ],
    );
  }

  void _takeScreenshot() async {
    final imageFile = await _screenshotController.capture(
      pixelRatio: 2,
    );
    Share.shareFiles([imageFile.path], text: 'Sent via newsHub');
  }

  void _options(BuildContext ctx) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Get.isDarkMode ? Colors.blueGrey : Colors.white,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                    Get.isDarkMode
                        ? Get.changeTheme(ThemeData.light())
                        : Get.changeTheme(ThemeData.dark());
                  },
                  child: Container(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.lightBlue,
                        ),

                        // padding: EdgeInsets.all(15.0),

                        Text(
                          Get.isDarkMode ? 'Light Mode' : 'Dark Mode',
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _takeScreenshot();
                  },
                  child: Container(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.share_rounded,
                          color: Colors.lightBlue,
                        ),
                        Text(
                          'Share',
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            height: 50,
          ),
        );
      },
    );
  }
}
