import 'package:flutter/material.dart';
import 'package:subblogs/Screens/blog_list_screen.dart';
import 'package:subblogs/bloc/blog_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/blog.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Blog>(BlogAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SuBBlogs',
      home: BlocProvider(
        create: (context) => BlogBloc(),
        child: BlogListScreen(),
      ),
    );
  }
}
