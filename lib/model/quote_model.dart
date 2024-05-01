class QuoteModel {
  late String text;
  late String author;

  QuoteModel({required this.text, required this.author});

  QuoteModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    author = json['author'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['author'] = author;
    return data;
  }
}