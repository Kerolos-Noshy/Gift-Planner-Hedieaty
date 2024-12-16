import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/views/profile/notification_item.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    List<String> items = ["data 1", "data 2", "data 3", "data 4", ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFf5f4f3),
        surfaceTintColor: const Color(0xFFf5f4f3),
        shadowColor: Colors.grey,
        title: Text(
          "Notifications",
          style: GoogleFonts.markaziText(
            textStyle: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w600
            )
          )
        ),
      ),
      backgroundColor: const Color(0xFFf5f4f3),
      body: SafeArea(
        // width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            // const SizedBox(height: 15,),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int i) {
                  // final item = items[i];
                  return Dismissible(
                    // key: ValueKey(i),
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.green,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Icon(Icons.delete)
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        items.removeAt(i);
                      });
                    },
                    child: NotificationItem(
                      text: items[i],
                      date: "12-Nov-2024",
                    ),
                  );
                },
              ),
            ),
          ],
        )
      )
    );
  }
}
