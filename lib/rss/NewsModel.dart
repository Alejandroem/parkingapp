class NewsModel{

  String? title;
  String? description;
  String? link;
  String? pubDate;
  Enclosure? enclosure;

  NewsModel(this.title, this.description, this.link, this.pubDate, this.enclosure);

}

class Enclosure {

  String? url;
  String? type;
  String? length;

  Enclosure(this.url, this.type, this.length);
}