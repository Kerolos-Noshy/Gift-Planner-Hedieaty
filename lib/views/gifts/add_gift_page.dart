import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/models/repositories/gift_repository.dart';
import 'package:hedieaty/services/auth_service.dart';
import 'package:hedieaty/services/gift_service.dart';

import '../../models/event_model.dart';
import '../../models/gift_model.dart';

class AddGiftPage extends StatefulWidget {
  final Gift? gift;
  final Event event;
  final VoidCallback onGiftAdded;
  const AddGiftPage({
    super.key,
    required this.gift,
    required this.event,
    required this.onGiftAdded,
  });

  @override
  State<AddGiftPage> createState() => _AddGiftPageState();
}

class _AddGiftPageState extends State<AddGiftPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String? _selectedCategory;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.gift != null) {
      _nameController.text = widget.gift!.name;
      _descriptionController.text = widget.gift!.description ?? "";
      _priceController.text = widget.gift!.price.toString();
      _selectedCategory = widget.gift!.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: add gift photo
      appBar: AppBar(
        backgroundColor: const Color(0xFFf5f4f3),
        surfaceTintColor: const Color(0xFFf5f4f3),
        shadowColor: Colors.grey,
        title: Text(
            widget.gift == null? "Add Gift" : "Edit Gift",
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Gift Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a gift name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ['Gaming',
                        'Electronics',
                        'Clothing',
                        'Souvenir',
                        'Accessory',
                        'Other']
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                validator: (value) => value == null ? 'Please enter the gift category' : null,
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Please enter a valid number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),

              IconButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // TODO: remove status
                    Gift gift = Gift(
                      id: widget.gift?.id,
                      name: _nameController.text.trim(),
                      description: _descriptionController.text,
                      category: _selectedCategory!,
                      price: double.parse(_priceController.text),
                      status: _selectedCategory!,
                      eventId: widget.event.id!,
                      giftCreatorId: AuthService()
                          .getCurrentUser()
                          .uid,
                      eventDocId: widget.event.documentId ?? "",
                    );

                    if (widget.gift == null) {
                      // Add a new gift
                      try {
                        String? docId;
                        if (widget.event.isPublic) {
                          docId = await GiftService.addGift(
                            widget.event.userId,
                            widget.event.documentId!,
                            gift,
                          );
                          gift.documentId = docId;
                        }
                        int giftId = await GiftRepository().addGift(gift);
                        gift.id = giftId;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gift added successfully!')),
                        );

                        widget.onGiftAdded();
                        Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add gift: $e')),
                        );
                      }
                    } else {
                      // Update an existing gift
                      try {
                        // Update the existing gift instance
                        widget.gift!
                          ..name = _nameController.text.trim()
                          ..description = _descriptionController.text
                          ..category = _selectedCategory!
                          ..price = double.parse(_priceController.text);

                        if (widget.event.isPublic) {
                          await GiftService.updateGift(
                            widget.event.userId,
                            widget.event.documentId!,
                            widget.gift!,
                          );
                        }

                        await GiftRepository().updateGift(widget.gift!);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gift updated successfully!')),
                        );

                        Navigator.of(context).pop();
                        widget.onGiftAdded();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update gift: $e')),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),

                icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.gift == null?Icons.add:Icons.edit, color: Colors.white,),
                      const SizedBox(width: 2,),
                      Text(
                          widget.gift == null?"Add Gift":"Edit Gift",
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
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
