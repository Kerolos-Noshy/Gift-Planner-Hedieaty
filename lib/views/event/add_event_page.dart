import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/models/event_model.dart';
import 'package:hedieaty/services/auth_service.dart';

import '../../models/repositories/event_repository.dart';
import '../../services/event_service.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _eventType;
  bool _isPublic = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFf5f4f3),
        surfaceTintColor: const Color(0xFFf5f4f3),
        shadowColor: Colors.grey,
        title: Text(
            "Add New Event",
            style: GoogleFonts.markaziText(
                textStyle: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600
                )
            )
        ),
      ),
      backgroundColor: const Color(0xFFf5f4f3),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5,),
                  // Event Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Event Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the event name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
          
                  // Event Type Field
                  DropdownButtonFormField<String>(
                    value: _eventType,
                    items: const [
                      // weddings,
                      // engagements, graduations, and holidays
                      DropdownMenuItem(value: 'Birthday', child: Text('Birthday')),
                      DropdownMenuItem(value: 'Engagement', child: Text('Engagement')),
                      DropdownMenuItem(value: 'Graduation', child: Text('Graduation')),
                      DropdownMenuItem(value: 'Holiday', child: Text('Holiday')),
                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                    ],
                    decoration: const InputDecoration(labelText: 'Event Type', border: OutlineInputBorder(),),
                    onChanged: (value) {
                      setState(() {
                        _eventType = value!;
                      });
                    },
                    validator: (value) => value == null ? 'Please enter the event type' : null,
                  ),
          
                  const SizedBox(height: 16),
          
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: GestureDetector(
                          onTap: _pickDate,
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: const InputDecoration(
                                labelText: "Event Date",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (_selectedDate == null) {
                                  return "Please select a date";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: GestureDetector(
                          onTap: _pickTime,
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _timeController,
                              decoration: const InputDecoration(
                                labelText:  "Event Time",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (_selectedTime == null) {
                                  return "Please select a time";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          
                  const SizedBox(height: 16),
          
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: "Event Location",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the event location";
                      }
                      return null;
                    },
                  ),
          
                  const SizedBox(height: 16),
          
                  // Event Description Field
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Event Description (Optional)",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
          
                  SwitchListTile(
                    // inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFFf5f4f3),
                    activeTrackColor: Colors.green,
                    title: const Text("Make It Public?", style: TextStyle(fontSize: 17),),
                    secondary: const Icon(Icons.public, size: 26,),
                    value: _isPublic,
                    onChanged: (value) {
                      setState(() {
                        _isPublic = value;
                      });
                    },
                  ),
          
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      width: 160,
                      child: IconButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        ),

                        icon: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add, color: Colors.white,),
                              const SizedBox(width: 2,),
                              Text(
                                  "Add Event",
                                  style: GoogleFonts.breeSerif(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                  )
                              ),
                              const SizedBox(width: 8,),
                            ]
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = _selectedDate!.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = _selectedTime!.format(context);
      });
    }

  }

  DateTime? getEventDateTime() {
    if (_selectedDate != null && _selectedTime != null) {
      return DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
    }
    return null; // If either date or time is not selected
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {

      final newEvent = Event(
        name: _nameController.text.trim(),
        date: getEventDateTime()!,
        location: _locationController.text.trim(),
        description: _descriptionController.text.trim(),
        userId: AuthService().getCurrentUser().uid,
        eventType: _eventType!,
        isPublic: _isPublic
      );

      if (_isPublic) {
        // Add to Firestore
        await EventService().addEvent(newEvent);
        print('event added to firestore');
      }

      // Add to local database
      await EventRepository().addEvent(newEvent);
      print ('event added to local database');


      // Show success message or navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event added successfully!")),
      );

      Navigator.pop(context);

      _nameController.clear();
      _locationController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedDate = null;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}