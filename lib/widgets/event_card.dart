import 'package:flutter/material.dart';
import 'package:hedieaty/models/repositories/user_repository.dart';
import 'package:hedieaty/models/user_model.dart';
import 'package:hedieaty/services/auth_service.dart';
import 'package:hedieaty/widgets/friend_avatar.dart';


class EventCard extends StatelessWidget {
  final String date;
  const EventCard({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 0.2,
            blurRadius: 2,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Birthday Party"),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),

                ),
                child: const Icon(Icons.cake_outlined),
              )
            ],
          ),
          const Divider(),

          FutureBuilder<User?>(
            future: UserRepository().getUserById(AuthService().getCurrentUser().uid),
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No event found.'));
              } else {
                User friend = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FriendAvatar(friend: friend,
                          showEventsNotification: false,
                          showName: false,),
                        Text(friend.name)
                      ]
                  ),
                );
              }
            }
          ),
          const SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(date)
            ],
          )
        ],
      ),
    );
  }
}
