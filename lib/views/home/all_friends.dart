import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/models/friend_model.dart';
import 'package:hedieaty/routes/app_routes.dart';
import 'package:hedieaty/services/auth_service.dart';
import 'package:hedieaty/services/friend_service.dart';
import 'package:hedieaty/services/user_service.dart';
import 'package:hedieaty/widgets/friend_avatar.dart';

import '../../constants/styles/app_styles.dart';
import '../../models/repositories/event_repository.dart';
import '../../models/user_model.dart';
import '../profile/friend_profile.dart';

class AllFriends extends StatefulWidget {
  const AllFriends({super.key});

  @override
  State<AllFriends> createState() => _AllFriendsState();
}

class _AllFriendsState extends State<AllFriends> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  List<User> allFriends = [];
  bool friendAdded = false;

  @override
  void initState() {
    super.initState();
    _fetchFriends();
  }

  Future<void> _fetchFriends() async {
    try {
      List<User> friends = await FriendService().getFriends(
          AuthService().getCurrentUser().uid
      );
      setState(() {
        allFriends = friends;
      });
    } catch (error) {
      print("Error fetching friends: $error");
    }
  }


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
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Text(
                  "Cancel",
                  style: GoogleFonts.breeSerif(
                    textStyle: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 15,

                    ),
                  )
              ),
            ),
            IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final phoneNumber = _phoneController.text;

                  bool  success = await _addFriend(phoneNumber);
                  Navigator.of(context).pop();

                  if (success)
                    setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 1),
              ),
              icon: SizedBox(
                width: 80,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(FluentSystemIcons.ic_fluent_person_add_regular, color: Colors.white, size: 22,),
                      const SizedBox(width: 8,),
                      Text(
                          "Add",
                          style: GoogleFonts.breeSerif(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          )
                      ),
                      const SizedBox(width: 4,),
                    ]
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _addFriend(String phoneNumber) async {
    try {
      User? currentUser = await UserService().getUser(AuthService().getCurrentUser().uid);

      if (phoneNumber == currentUser!.phone) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You Can not add yourself')
          )
        );
        return false;
      }
      
      User? friendData = await UserService().getUserByPhone(phoneNumber);

      if (friendData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('User not found')
            )
        );
        return false;
      }

      bool friendshipExist = await FriendService().friendshipExists(currentUser.id, friendData.id);
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
        // local table for friends is useless
        // await FriendRepository().addFriend(
        //     friend
        // );
        // print('friend added to database');
        FriendService().addFriend(friend.userId ,friend.friendId);
        print('friend added to fire store');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Friend added successfully")
          )
        );
        friendAdded = true;
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
      backgroundColor: const Color(0xFFf5f4f3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFf5f4f3),
        surfaceTintColor: const Color(0xFFf5f4f3),
        shadowColor: Colors.grey,
        title: Text(
          "All Friends",
          style: GoogleFonts.markaziText(
            textStyle: const TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.w600
            )
          )
        ),
        leading: IconButton(
            onPressed: () {
              print("********* $friendAdded");
              if (friendAdded) {
                friendAdded = false;
                Navigator.pushReplacementNamed(context, AppRoutes.homePage);
              }
              else
                Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              FluentSystemIcons.ic_fluent_search_regular,
              size: 26,
            ),
            tooltip: "Search",
            onPressed: () {
              showSearch(
                context: context,
                delegate: FriendSearchDelegate(allFriends),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              FluentSystemIcons.ic_fluent_person_add_regular,
              size: 26,
            ),
            tooltip: "Add Friend",
            onPressed: _showAddFriendDialog,
          )
        ],
      ),
      body: Column(
        children: [
          // const SizedBox(height: 20,),
          FutureBuilder<List<User>>(
            future: FriendService().getFriends(AuthService().getCurrentUser().uid),
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
                  child: Column(
                    children: friends.map((singleFriend) {
                      return FutureBuilder<int>(
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
                              IconButton(
                                color: Colors.red,
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FriendProfile(friendData: singleFriend,),
                                      )
                                  );
                                },
                                icon: Row(
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

class FriendSearchDelegate extends SearchDelegate<User?> {
  final List<User> allFriends;

  FriendSearchDelegate(this.allFriends);

  @override
  String get searchFieldLabel => "Search friends";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<User> searchResults = allFriends
        .where((friend) =>
        friend.name.toLowerCase().contains(query.trim().toLowerCase()))
        .toList();

    if (searchResults.isEmpty) {
      return const Center(
        child: Text("No friends found."),
      );
    }

    return Container(
      color: const Color(0xFFf5f4f3),
      child: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final friend = searchResults[index];
          return IconButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriendProfile(friendData: friend,),
                  )
              );
            },
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    FriendAvatar(
                      friend: friend,
                      showEventsNotification: false,
                      showName: false,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      friend.name,
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<User> suggestions = allFriends
        .where((friend) =>
        friend.name.toLowerCase().contains(query.trim().toLowerCase()))
        .toList();

    return Container(
      color: const Color(0xFFf5f4f3),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final friend = suggestions[index];
          return IconButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => FriendProfile(friendData: friend,),
                )
              );
            },
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    FriendAvatar(
                      friend: friend,
                      showEventsNotification: false,
                      showName: false,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      friend.name,
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

