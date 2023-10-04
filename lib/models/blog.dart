import 'package:hive/hive.dart';

part 'blog.g.dart';

@HiveType(typeId: 0)
class Blog {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String blogimage;
  @HiveField(3)
  bool isFavorite;

  Blog({
    required this.id,
    required this.title,
    required this.blogimage,
    this.isFavorite = false,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      title: json['title'],
      blogimage: json['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'blogimage': blogimage,
      'isFavorite': isFavorite,
    };
  }
}
