import 'package:equatable/equatable.dart';
import 'package:subblogs/models/blog.dart';
abstract class BlogState extends Equatable {
  const BlogState();

  @override
  List<Object> get props => [];
}

class BlogInitial extends BlogState {}

class BlogLoading extends BlogState {}

class BlogLoaded extends BlogState {
  final List<Blog> blogs;

  BlogLoaded({required this.blogs});

  @override
  List<Object> get props => [blogs];
}

class BlogError extends BlogState {
  final String error;

  BlogError({required this.error});

  @override
  List<Object> get props => [error];
}
