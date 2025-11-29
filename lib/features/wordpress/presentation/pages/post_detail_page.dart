import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';
import 'post_detail_page_view.dart';

class PostDetailPage extends StatelessWidget {
  final PostEntity post;
  final String? heroTag;

  const PostDetailPage({
    super.key,
    required this.post,
    this.heroTag,
  });

  static Route<dynamic> route(PostEntity post, {String? heroTag}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/post_detail'),
      builder: (_) => PostDetailPage(post: post, heroTag: heroTag),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PostDetailPageView(post: post, heroTag: heroTag);
  }
}

