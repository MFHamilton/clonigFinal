import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../widgets/post_card.dart';
import '../models/post.dart';
import '../providers/user_provider.dart';
import 'upload_screen.dart';
import 'profile_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    Widget body;
    switch (_currentIndex) {
      case 1:
        body = const UploadScreen();
        break;
      case 2:
        body = const ProfileScreen();
        break;
      default:
        body = StreamBuilder<List<PostModel>>(
          stream: FirestoreService().postsStream(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final posts = snap.data ?? [];
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: posts.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PostCard(post: posts[i]),
              ),
            );
          },
        );
    }

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text('Hola, ${user?.displayName ?? 'Amigo'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthService>().signOut();
              context.read<UserProvider>().clear();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: body,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: 'Post'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        onTap: (idx) => setState(() => _currentIndex = idx),
      ),
    );
  }
}

