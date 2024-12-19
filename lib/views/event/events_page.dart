import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/models/event_model.dart';
import 'package:hedieaty/services/auth_service.dart';
import 'package:hedieaty/services/event_service.dart';
import 'package:hedieaty/services/user_service.dart';
import 'package:hedieaty/views/event/add_event_page.dart';
import 'package:hedieaty/widgets/event_card_big.dart';

import '../../models/repositories/event_repository.dart';
import '../../models/user_model.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Event> events = [];

  Future<void> _fetchEvents() async {
    events = await EventService().fetchUserEvents(AuthService.getCurrentUserId());
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFf5f4f3),
        surfaceTintColor: const Color(0xFFf5f4f3),
        shadowColor: Colors.grey,
        title: Text(
            "All Events",
            style: GoogleFonts.markaziText(
                textStyle: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600
                )
            )
        ),
        actions: [
          IconButton(
              onPressed: (){
                // Navigator.pushNamed(context, AppRoutes.addEvent);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEventPage(

                      onEventAdded: _fetchEvents, event: null,
                    ),
                  ),
                );
              },
              icon: const Icon(
                FluentSystemIcons.ic_fluent_calendar_add_regular,
                size: 27,
              ),
            tooltip: "Add Event",
            padding: const EdgeInsets.symmetric(horizontal: 0),
          ),
          const SizedBox(width: 15,)
        ],
      ),
      backgroundColor: const Color(0xFFf5f4f3),
      body: SafeArea(
        child: FutureBuilder<List<Event>>(
          future: EventRepository().getUserEvents(AuthService().getCurrentUser().uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No events found.'));
            } else {
              final events = snapshot.data!;
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  // return EventCardBig(event: event, eventCreator: ,);
                  return FutureBuilder(
                    future: UserService().getUser(event.userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(child: Text('No events found.'));
                      } else {
                        User? user = snapshot.data!;
                        return EventCardBig(event: event, eventCreator: user, onEventDeleted: _fetchEvents,);
                      }
                    }
                  );
                },
              );
            }
          },
        )
      ),
    );
  }
}
