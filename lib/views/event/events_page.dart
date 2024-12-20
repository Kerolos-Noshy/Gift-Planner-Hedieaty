import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/models/event_model.dart';
import 'package:hedieaty/services/auth_service.dart';
import 'package:hedieaty/services/user_service.dart';
import 'package:hedieaty/views/event/add_event_page.dart';
import 'package:hedieaty/widgets/event_card_big.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../models/repositories/event_repository.dart';
import '../../models/user_model.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Event> events = [];
  String _sortCriterion = 'Name';

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    events = await EventRepository().getUserEvents(AuthService().getCurrentUser().uid);
    _sortEvents();
    setState(() {
    });
  }

  void _sortEvents() {
    setState(() {
      events.sort((a, b) {

        switch (_sortCriterion) {
          case 'Category':
            return a.eventType.compareTo(b.eventType);
          case 'Status':
            // Sort upcoming and past events
            final statusA = a.date.isAfter(DateTime.now()) ? 0 : 1;
            final statusB = b.date.isAfter(DateTime.now()) ? 0 : 1;
            return statusA.compareTo(statusB);
          case 'Date':
            return a.date.compareTo(b.date);
          case 'Name':
          default:
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFf5f4f3),
        surfaceTintColor: const Color(0xFFf5f4f3),
        shadowColor: Colors.grey,
        title: Text(
          "My Events",
          style: GoogleFonts.markaziText(
            textStyle: const TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEventPage(
                    onEventAdded: _fetchEvents, event: null,
                  ),
                ),
              );
            },
            icon: const Icon(FluentSystemIcons.ic_fluent_calendar_add_regular, size: 27),
            tooltip: "Add Event",
            padding: const EdgeInsets.symmetric(horizontal: 0),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.sort_outlined),
          const SizedBox(width: 5),
          DropdownButton<String>(
            value: _sortCriterion,
            dropdownColor: Colors.white,
            items: [
              DropdownMenuItem(
                value: 'Name',
                child: Text('Name', style: GoogleFonts.markaziText(textStyle: const TextStyle(fontSize: 22))),
              ),
              DropdownMenuItem(
                value: 'Category',
                child: Text('Category', style: GoogleFonts.markaziText(textStyle: const TextStyle(fontSize: 22))),
              ),
              DropdownMenuItem(
                value: 'Status',
                child: Text('Status', style: GoogleFonts.markaziText(textStyle: const TextStyle(fontSize: 22))),
              ),
              DropdownMenuItem(
                value: 'Date',
                child: Text('Date', style: GoogleFonts.markaziText(textStyle: const TextStyle(fontSize: 22))),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _sortCriterion = value;
                });
                _sortEvents();
              }
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFf5f4f3),
      body: SafeArea(
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return FutureBuilder(
              future: UserService().getUser(event.userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child:
                  LoadingAnimationWidget.threeRotatingDots(
                    color: Colors.orange,
                    size: 30,
                  ),);
                } else if (!snapshot.hasData || snapshot.data == null || events.isEmpty) {
                  return const Center(child: Text('No events found.'));
                } else {
                  User? user = snapshot.data!;
                  return EventCardBig(
                    event: event,
                    eventCreator: user,
                    onEventDeleted: _fetchEvents,
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
