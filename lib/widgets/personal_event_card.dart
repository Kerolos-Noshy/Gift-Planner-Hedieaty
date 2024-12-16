import 'package:flutter/material.dart';
import 'package:hedieaty/models/repositories/user_repository.dart';
import 'package:hedieaty/models/user_model.dart';
import 'package:hedieaty/services/auth_service.dart';

class PersonalEventCard extends StatelessWidget {
  const PersonalEventCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 150,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),

                ),
                child: const Icon(Icons.cake_outlined),
              )
            ],
          ),
          const Divider(),
          const SizedBox(height: 5,),

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
                  // User friend = snapshot.data!;
                  return const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Gifts: 20"),
                          Text("Pledged Gifts: 8")
                        ]
                    ),
                  );
                }
              }
          ),
          const SizedBox(height: 15,),
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("20-Nov-2024"),
                Text("After -15 days")
              ],
            ),
          )
        ],
      ),
    );
  }
}
