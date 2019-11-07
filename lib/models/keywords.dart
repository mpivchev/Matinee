// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Keywords keywordsFromJson(String str) => Keywords.fromJson(json.decode(str));

String keywordsToJson(Keywords data) => json.encode(data.toJson());

class Keywords {
    int id;
    List<Keyword> keywords;

    Keywords({
        this.id,
        this.keywords,
    });

    factory Keywords.fromJson(Map<String, dynamic> json) => new Keywords(
        id: json["id"],
        keywords: new List<Keyword>.from(json["keywords"].map((x) => Keyword.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "keywords": new List<dynamic>.from(keywords.map((x) => x.toJson())),
    };
}

class Keyword {
    int id;
    String name;

    Keyword({
        this.id,
        this.name,
    });

    factory Keyword.fromJson(Map<String, dynamic> json) => new Keyword(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
