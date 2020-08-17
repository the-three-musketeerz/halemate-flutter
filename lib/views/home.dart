import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hale_mate/Services/Alert/alertService.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/webfeed.dart';

class HomeScreen extends StatefulWidget {

  static const String id = 'Home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: EdgeInsets.all(15.0),
          child: RSSHealth(),
        ),
        floatingActionButton: Container(
            height: 100.0,
            width: 100.0,
            child: FittedBox(
              child: FloatingActionButton(
                  child: Icon(Icons.warning),
                  backgroundColor: Colors.red[500],
                  onPressed: () {
                    showDialog(context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) => AlertWidget());
                  }),
            )
        )
    );
  }
}

class RSSHealth extends StatefulWidget{
  RSSHealth () : super();

  @override
  RSSHealthState createState() => RSSHealthState();
}

class RSSHealthState extends State<RSSHealth> {
  static const String FEED_URL = 'https://health.economictimes.indiatimes.com/rss/topstories';
  RssFeed _feed;
  GlobalKey<RefreshIndicatorState> _refreshKey;

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  Future<void> openFeed(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
      );
      return;
    }
  }

  load() async {
    loadFeed().then((result) {
      if (null == result || result.toString().isEmpty) {
        return;
      }
      updateFeed(result);
    });
  }

  Future<RssFeed> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(FEED_URL);
      return RssFeed.parse(response.body);
    } catch (e) {
      //
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    load();
  }

  title(title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(subTitle) {
    return Text(
      subTitle,
      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    );
  }

  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }

  list() {
    return ListView.builder(
      itemCount: _feed.items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _feed.items[index];
        return Material(
          child: InkWell(
            child: Container(
              height: 250,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3,
                margin: EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: title(item.title),
                      ),
                      ListTile(
                        title: subtitle(item.description),
                      )
                    ],
                  ),
                )

              ),
            ),
            onTap:() => openFeed(item.link),
          ),
        );
      },
    );
  }

  isFeedEmpty() {
    return null == _feed || null == _feed.items;
  }

  body() {
    return isFeedEmpty()
        ? Center(
      child: CircularProgressIndicator(),
    )
        : RefreshIndicator(
      key: _refreshKey,
      child: list(),
      onRefresh: () => load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

}



