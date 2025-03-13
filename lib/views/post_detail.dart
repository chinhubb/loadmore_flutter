import 'package:flutter/material.dart';
import '../models/post_model.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;

  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(post.body, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
