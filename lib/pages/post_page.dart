import 'package:monitoring_hamil/res/constants.dart';
import 'package:monitoring_hamil/models/api_response.dart';
import 'package:monitoring_hamil/models/post.dart';
import 'package:monitoring_hamil/pages/comment_page.dart';
import 'package:monitoring_hamil/services/post_service.dart';
import 'package:monitoring_hamil/services/user_service.dart';
import 'package:flutter/material.dart';


import '../Components/Auth/login_page.dart';
import '../Components/any_form/post_form.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() =>
      _PostPageState(); // _PostPageState is a class defined below
}

class _PostPageState extends State<PostPage> {
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;

  // get all posts
  Future<void> retrievePosts() async {
    userId = await getUserId();
    ApiResponse response = await getPosts();

    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = _loading
            ? !_loading
            : _loading; // if loading is true then set it to false
      });
    } else if (response.error == unauthorized) {
      logout(context).then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false)
          });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    }
  }

  void _handleDeletePost(int postId) async {
    ApiResponse response = await deletePost(postId);
    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logout(context).then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false)
          });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.error}')));
      }
    }
  }

  // post like dislik
  void _handlePostLikeDislike(int postId) async {
    ApiResponse response = await likeUnlikePost(postId);

    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logout(context).then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false)
          });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.error}')));
      }
    }
  }

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : _postList.isEmpty
            ? const Center(child: Text('No Post Available Yet.'))
            : RefreshIndicator(
                onRefresh: () {
                  return retrievePosts();
                },
                child: ListView.builder(
                    itemCount: _postList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Post post = _postList[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                            image: post.user!.image != null
                                                ? DecorationImage(
                                                    image: NetworkImage(
                                                        '${post.user!.image}'))
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: const Color.fromARGB(
                                                255, 34, 34, 34)),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '${post.user!.name}', // Username/Name
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ),
                                post.user!.id == userId
                                    ? PopupMenuButton(
                                        child: const Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.more_vert,
                                              color: Colors.black,
                                            )),
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                              value: 'edit',
                                              child: Text('Edit')),
                                          const PopupMenuItem(
                                              value: 'delete',
                                              child: Text('Delete'))
                                        ],
                                        onSelected: (val) {
                                          if (val == 'edit') {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PostForm(
                                                          title: 'Edit Post',
                                                          post: post,
                                                        )));
                                          } else {
                                            _handleDeletePost(post.id ?? 0);
                                          }
                                        },
                                      )
                                    : const SizedBox()
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            post.image != null
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 6, right: 6),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 180,
                                      margin: const EdgeInsets.only(top: 5),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                                  NetworkImage('${post.image}'),
                                              fit: BoxFit.cover)),
                                    ),
                                  )
                                : SizedBox(
                                    height: post.image != null ? 0 : 10,
                                  ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 16),
                              child: Text(
                                '${post.header}',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 6, right: 6, bottom: 32),
                              child: Text(
                                '${post.subheader}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                '${post.body}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    height: 1.5),
                              ),
                            ),
                            Row(
                              children: [
                                kLikeAndComment(
                                    post.likesCount ?? 0,
                                    post.selfLiked == true
                                        ? Icons.thumb_up
                                        : Icons.thumb_up,
                                    post.selfLiked == true
                                        ? Colors.red
                                        : Colors.black54, () {
                                  _handlePostLikeDislike(post.id ?? 0);
                                }),
                                Container(
                                  height: 25,
                                  width: 0.5,
                                  color: Colors.black38,
                                ),
                                kLikeAndComment(post.commentsCount ?? 0,
                                    Icons.sms_outlined, Colors.black54, () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CommentPage(
                                            postId: post.id,
                                          )));
                                }),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 0.5,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      );
                    }),
              );
  }
}
