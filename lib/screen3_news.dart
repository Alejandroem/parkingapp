// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:animated_loading_indicators/animated_loading_indicators.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';

import '../services/webview.dart';
import '../constants.dart';

class screen3_news extends StatefulWidget {
  const screen3_news({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<screen3_news> createState() => screen3_newsState();
}

class screen3_newsState extends State<screen3_news> {
  // const screen3_news({super.key});

  List<NewsModel> newsModels = [];


  void newrssResponse() {
    // RssFeed feed = RssFeed.parse(xmlString);
    final client = http.Client();
      client.get(Uri.parse('https://www.turbo.fr/global.xml')).then((response) {
        return response.body;
      }).then((bodyString) {
        final channel = RssFeed.parse(bodyString);
        channel.items.forEach((e) {
          String? imageUrl = '';
          if (e.enclosure != null && e.enclosure!.type == 'image/jpeg') {
            imageUrl = e.enclosure!.url;
          }

          newsModels.add(NewsModel(
            title: e.title ?? '',
            link: e.link ?? '',
            description: e.description ?? '',
            pubDate: e.pubDate ?? '',
            creator: e.dc!.creator ?? '',
            imageUrl: imageUrl!,
          ));

           //, e.enclosure as List<Enclosure>? ));
        });


        return channel;
      });
    }




  @override
  void initState() {
    newrssResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height - 120,
        child: Column(
          children: [
            Expanded(
              child: newsModels.isEmpty
                  ? UpDownLoader(
                        size: 12,
                        firstColor: Colors.teal,
                        secondColor: Colors.black,
                        //  duration: Duration(milliseconds: 600),
                      )
                  : ListView.builder(
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
                          newsModels[index].imageUrl.isNotEmpty
                              ? Image.network(newsModels[index].imageUrl)
                              : SizedBox(),
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
      ),
    );
  }
}

class NewsModel {
  String title;
  String link;
  String description;
  String pubDate;
  String creator;
  String imageUrl;

  NewsModel({
    required this.title,
    required this.link,
    required this.description,
    required this.pubDate,
    required this.creator,
    this.imageUrl = '',
  });
}

