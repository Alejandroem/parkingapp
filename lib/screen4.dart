// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';

import '../services/webview.dart';
import '../constants.dart';

class screen4 extends StatefulWidget {
  const screen4({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<screen4> createState() => screen4State();
}

class screen4State extends State<screen4> {
  // const screen4({super.key});

  List<NewsModel> newsModels = [];

  void rssResponse() {
    final client = http.Client();
    // RSS feed
    client.get(Uri.parse('https://www.turbo.fr/global.xml')).then((response) {
      return response.body;
    }).then((bodyString) {
      final channel = RssFeed.parse(bodyString);
      channel.items.forEach((e) {
        newsModels.add(NewsModel(e.title, e.description, e.link,
            e.pubDate));   //, e.enclosure as List<Enclosure>? ));
      });
      return channel;
    });
  }

  @override
  void initState() {
    rssResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: newsModels.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: InkWell(
                    onTap: () {
                         Navigator.of(context).push(
                             MaterialPageRoute(builder: (context) => webview(url: newsModels[index].link, title:"")));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
/*
                          (newsModels[index].enclosure?.first.url != null)
                           ? Image.network(newsModels[index].enclosure!.first.url.toString(),
                            fit:BoxFit.cover, height:80, width:80)
                           : Text("no image"),
*/
                        Text(
                          newsModels[index].title!,
                          style: TextStyle_regular),

                        Text(newsModels[index].description!,
                            style: TextStyle_small,
                            maxLines: 4,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis),
                        Text(
                          "Publié le : " + newsModels[index].pubDate!,
                            style: TextStyle_veryverysmall),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NewsModel {
  String? title;
  String? description;
  String? link;
  String? pubDate;
//  List<Enclosure>? enclosure;
  NewsModel(this.title, this.description, this.link, this.pubDate); //, this.enclosure);
}

class Enclosure {
  String? url;
  String? type;
  String? length;
  Enclosure(this.url, this.type, this.length);
}
