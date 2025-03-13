import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/post_model.dart';
import 'views/post_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Load More Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PostListPage(),
    );
  }
}

class PostListPage extends StatefulWidget {
  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final ApiService _apiService = ApiService();
  List<Post> _posts = [];
  int _page = 1;
  final int _limit = 10;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchPosts();
      }
    });
  }

  Future<void> _fetchPosts() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      List<Post> newPosts = await _apiService.fetchPosts(_page, _limit);
      setState(() {
        _posts.addAll(newPosts);
        _isLoading = false;
        _page++;
        if (newPosts.length < _limit) _hasMore = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts List')),
      body: ListView.separated(
        controller: _scrollController,
        itemCount: _posts.length + 1,
        separatorBuilder: (context, index) => Divider(color: Colors.grey[300], thickness: 1),
        itemBuilder: (context, index) {
          if (index < _posts.length) {
            return ListTile(
              title: Text(
                _posts[index].title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_posts[index].body),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailPage(post: _posts[index]),
                  ),
                );
              },
            );
          } else if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
