import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/models/friend_model.dart';
import 'package:hedieaty/models/repositories/user_repository.dart';
import 'package:hedieaty/services/auth_service.dart';
import 'package:hedieaty/services/friend_service.dart';
import 'package:hedieaty/widgets/friend_avatar.dart';

import '../../constants/styles/app_styles.dart';
import '../../models/repositories/event_repository.dart';
import '../../models/repositories/friend_repository.dart';
import '../../models/user_model.dart';

class AllFriends extends StatefulWidget {
  const AllFriends({super.key});

  @override
  State<AllFriends> createState() => _AllFriendsState();
}

class _AllFriendsState extends State<AllFriends> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _showAddFriendDialog() async {
    _phoneController.clear();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Friend'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Friend\'s Phone Number'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                if (value.length != 11) {
                  return 'Phone number must be 11 digits';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final phoneNumber = _phoneController.text;

                  bool  success = await _addFriend(phoneNumber);
                  Navigator.of(context).pop();

                  if (success)
                    setState(() {});

                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _addFriend(String phoneNumber) async {
    try {
      User? currentUser = await UserRepository().getUserById(AuthService().getCurrentUser().uid);

      if (phoneNumber == currentUser!.phone) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You Can not add yourself')
          )
        );
        return false;
      }
      // Check if the phone number exists in the database
      User? friendData = await UserRepository().getUserByPhone(phoneNumber);

      if (friendData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('User not found')
            )
        );
        return false;
      }

      bool friendshipExist = await FriendRepository().friendshipExists(currentUser.id, friendData.id);
      if (friendshipExist) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("${friendData.name.split(' ')[0]} is already friend")
          )
        );

        return false;
      }
      else {
        Friend friend = Friend(userId: currentUser.id, friendId:  friendData.id);
        await FriendRepository().addFriend(
            friend
        );
        print('friend added to database');
        FriendService().addFriend(friend);
        print('friend added to fire store');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Friend added successfully")
          )
        );
        return true;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: Text(
            "All Friends",
            style: GoogleFonts.markaziText(
                textStyle: const TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.w600
                )
            )
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, size: 26,),
            tooltip: "Search",
            onPressed: () {
              showSearch(context) {

              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add_alt_rounded, size: 26,),
            tooltip: "Add Friend",
            onPressed: _showAddFriendDialog,
          )
        ],
      ),
      body: Column(
        children: [
          // const SizedBox(height: 20,),
          FutureBuilder<List<User>>(
            future: FriendRepository().getAllFriends(AuthService().getCurrentUser().uid),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No friends found.'));
              } else {
                // Now we have the friends data from the database
                List<User> friends = snapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: friends.map((singleFriend) {
                      return FutureBuilder<int>(
                        // TODO: check the number of events for each friend is correct
                        future: EventRepository().getEventsCountByUserId(singleFriend.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        FriendAvatar(
                                          friend: singleFriend,
                                          showEventsNotification: false,
                                          showName: false,
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              singleFriend.name,
                                              style: GoogleFonts.lato(
                                                textStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              "Loading events...",
                                              style: AppStyles.headLineStyle4
                                                  .copyWith(color: Colors.grey[700]),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 1,
                                  width: 400,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 15),
                              ],
                            );
                          }

                          // If there's an error, show a fallback message
                          if (snapshot.hasError) {
                            return const Text(
                              "Error loading events",
                              style: TextStyle(color: Colors.red),
                            );
                          }

                          // Display the upcoming events count
                          int eventCount = snapshot.data ?? 0;
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      FriendAvatar(
                                        friend: singleFriend,
                                        showEventsNotification: false,
                                        showName: false,
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            singleFriend.name,
                                            style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Upcoming Events: $eventCount",
                                            style: AppStyles.headLineStyle4
                                                .copyWith(color: Colors.grey[700]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 1,
                                width: 400,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 15),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
