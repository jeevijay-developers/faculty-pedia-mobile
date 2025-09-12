import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/educator_model.dart';
import '../../utils/snackbar_utils.dart';
import '../../utils/constants.dart';

const Color kPrimaryColor = Color(0xFF4A90E2);

class FollowedEducatorsScreen extends StatefulWidget {
  const FollowedEducatorsScreen({Key? key}) : super(key: key);

  @override
  _FollowedEducatorsScreenState createState() =>
      _FollowedEducatorsScreenState();
}

class _FollowedEducatorsScreenState extends State<FollowedEducatorsScreen> {
  List<Educator> followedEducators = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadFollowedEducators();
  }

  Future<void> _loadFollowedEducators() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getString('userId');

      if (token == null || userId == null) {
        setState(() {
          error = 'Authentication required';
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('$MAIN_URL/follow/followed/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> educatorsData = data['followedEducators'] ?? [];

        setState(() {
          followedEducators = educatorsData
              .map((json) => Educator.fromJson(json))
              .toList();
          isLoading = false;
        });
      } else {
        print(
          'Failed to load followed educators. Status: ${response.statusCode}',
        );
        print('Response body: ${response.body}');
        setState(() {
          error =
              'Failed to load followed educators. Status: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading followed educators: $e');
      setState(() {
        error = 'Network error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _unfollowEducator(String educatorId, int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getString('userId');

      if (token == null || userId == null) return;

      final response = await http.put(
        Uri.parse('$MAIN_URL/follow/update/followers'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'educatorid': educatorId,
          'studentid': userId,
          'action': 'unfollow',
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          followedEducators.removeAt(index);
        });
        SnackBarUtils.showSuccess(context, 'Educator unfollowed successfully');
      } else {
        SnackBarUtils.showError(context, 'Failed to unfollow educator');
      }
    } catch (e) {
      SnackBarUtils.showError(context, 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back, color: kPrimaryColor, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Following',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadFollowedEducators,
        color: kPrimaryColor,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: kPrimaryColor),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              error!,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFollowedEducators,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (followedEducators.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No followed educators',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Follow educators to see them here',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: followedEducators.length,
      itemBuilder: (context, index) {
        final educator = followedEducators[index];
        return _buildEducatorCard(educator, index);
      },
    );
  }

  Widget _buildEducatorCard(Educator educator, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Profile Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kPrimaryColor.withOpacity(0.1),
                    image: educator.image?.url != null
                        ? DecorationImage(
                            image: NetworkImage(educator.image!.url!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: educator.image?.url == null
                      ? Icon(Icons.person, color: kPrimaryColor, size: 30)
                      : null,
                ),
                const SizedBox(width: 12),

                // Name and Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        educator.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        educator.specialization ?? educator.subject,
                        style: TextStyle(
                          fontSize: 12,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (educator.experience != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          educator.experience!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Unfollow Button
                IconButton(
                  onPressed: () => _showUnfollowDialog(educator, index),
                  icon: Icon(
                    Icons.person_remove,
                    color: Colors.red[400],
                    size: 20,
                  ),
                ),
              ],
            ),

            // Bio
            if (educator.bio != null) ...[
              const SizedBox(height: 12),
              Text(
                educator.bio!,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // Stats Row
            const SizedBox(height: 12),
            Row(
              children: [
                if (educator.rating != null) ...[
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    educator.rating!.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                if (educator.totalFollowers != null) ...[
                  Icon(Icons.people, color: Colors.grey[600], size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '\${educator.totalFollowers} followers',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUnfollowDialog(Educator educator, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unfollow Educator'),
          content: Text('Are you sure you want to unfollow \${educator.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _unfollowEducator(educator.id, index);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Unfollow'),
            ),
          ],
        );
      },
    );
  }
}
