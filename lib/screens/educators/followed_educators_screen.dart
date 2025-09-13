import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/educator_model.dart';
import '../../utils/snackbar_utils.dart';
import '../../utils/constants.dart';
import 'educator_profile_page.dart';

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
        print('Followed educators API response: $data'); // Debug log
        final List<dynamic> educatorsData = data['followedEducators'] ?? [];
        print('Educators data count: ${educatorsData.length}'); // Debug log

        // Debug each educator
        for (int i = 0; i < educatorsData.length; i++) {
          print('Educator $i: ${educatorsData[i]}');
        }

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
        shadowColor: Colors.black.withOpacity(0.1),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kPrimaryColor.withOpacity(0.1),
                  Colors.blue.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: kPrimaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(Icons.arrow_back, color: kPrimaryColor, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.favorite, color: kPrimaryColor, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              'Following',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () => _loadFollowedEducators(),
              icon: Icon(Icons.refresh, color: kPrimaryColor, size: 16),
              label: Text(
                'Refresh',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
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
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline,
                size: 60,
                color: kPrimaryColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Following Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Follow educators to see them here',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kPrimaryColor, kPrimaryColor.withBlue(255)],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.search, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Explore Educators',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
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
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _navigateToProfile(educator),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                // Header section with profile and unfollow
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        kPrimaryColor.withOpacity(0.1),
                        Colors.blue.shade100.withOpacity(0.3),
                        Colors.purple.shade50.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Enhanced Profile Image
                      Stack(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: educator.image?.url != null
                                  ? Image.network(
                                      educator.image!.url!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              _buildDefaultAvatar(),
                                    )
                                  : _buildDefaultAvatar(),
                            ),
                          ),
                          // Online indicator
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 16),

                      // Educator Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name with verified badge
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    educator.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.verified,
                                  color: kPrimaryColor,
                                  size: 16,
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            // Subject with modern chip design
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    kPrimaryColor.withOpacity(0.1),
                                    Colors.purple.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: kPrimaryColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                educator.specialization ?? educator.subject,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Experience badge
                            if (educator.experience != null &&
                                educator.experience!.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.green.shade200,
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  educator.experience!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Unfollow Button - Modern design
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () => _showUnfollowDialog(educator, index),
                          icon: Icon(
                            Icons.person_remove_outlined,
                            color: Colors.red[400],
                            size: 20,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content Section
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bio section
                      if (educator.bio != null && educator.bio!.isNotEmpty) ...[
                        Text(
                          educator.bio!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Stats Row with modern design
                      Row(
                        children: [
                          // Rating
                          if (educator.rating != null &&
                              educator.rating! > 0) ...[
                            _buildStatChip(
                              Icons.star,
                              educator.rating!.toStringAsFixed(1),
                              Colors.amber,
                              Colors.amber.shade50,
                            ),
                            const SizedBox(width: 12),
                          ],

                          // Followers
                          if (educator.totalFollowers != null &&
                              educator.totalFollowers! > 0) ...[
                            _buildStatChip(
                              Icons.people,
                              '${_formatFollowerCount(educator.totalFollowers!)}',
                              Colors.purple,
                              Colors.purple.shade50,
                            ),
                            const SizedBox(width: 12),
                          ],

                          const Spacer(),

                          // View Profile Button
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  kPrimaryColor,
                                  kPrimaryColor.withBlue(255),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: kPrimaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  "View Profile",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
          content: Text('Are you sure you want to unfollow ${educator.name}?'),
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

  String _formatFollowerCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kPrimaryColor, kPrimaryColor.withBlue(255)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.person, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildStatChip(
    IconData icon,
    String text,
    Color iconColor,
    Color backgroundColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: iconColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToProfile(Educator educator) {
    print('Navigating to profile for educator: ${educator.name}'); // Debug
    print('Educator ID: ${educator.id}'); // Debug
    print('Educator email: ${educator.email}'); // Debug
    print('Educator mobileNumber: ${educator.mobileNumber}'); // Debug

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EducatorProfilePage(
          id: educator.id,
          name: educator.name.isNotEmpty ? educator.name : 'Unknown Educator',
          subject: educator.subject,
          description: educator.bio ?? 'No description available',
          education: 'N/A', // Not available in the model
          experience: educator.experience ?? 'N/A',
          rating: educator.rating ?? 0.0,
          reviews: 0, // Not available in the model
          followers: educator.totalFollowers ?? 0,
          tag: educator.specialization ?? educator.subject,
          imageUrl: educator.image?.url ?? 'https://placehold.co/150.png',
          youtubeUrl: 'N/A', // Not available in the model
          email: educator.email,
          phone: educator.mobileNumber ?? 'N/A',
          socialLinks: {}, // Not available in the model
        ),
      ),
    );
  }
}
