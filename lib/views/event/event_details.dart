import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../gifts/gift_item.dart';
import 'text_field_with_icon.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.55,
      maxChildSize: 1,
      snap: true,
      snapSizes: const [0.55,1],
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Column(
              // mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Event Details",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 0.8, height: 0,),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      offset: const Offset(1, 5),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(100),
                                  image: const DecorationImage(
                                    image: AssetImage("assets/images/male-avatar.png"), fit: BoxFit.cover,
                                  )
                              ),
                            ),
                            Text(
                                "Leo Messi",
                                style: GoogleFonts.lato(
                                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)
                                )
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50,),

                      // const SizedBox(height: 20,),
                      const TextFieldWithIcon(
                        ico: Icons.celebration_rounded,
                        text: "Birthday Party",
                        // icon_bg_color: Color(0xB62C0A98)
                      ),
                      const SizedBox(height: 20,),
                      // Row(
                      //   children: [
                      //     Icon(Icons.calendar_month, color: Colors.grey[800], size: 26,),
                      //     const SizedBox(width: 20,),
                      //     Text(
                      //         "20-12-2024",
                      //         style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 20,),
                      const TextFieldWithIcon(
                        ico: Icons.calendar_month,
                        text: "20-12-2024",
                        // icon_bg_color: Color(0xB62C0A98)
                      ),
                      const SizedBox(height: 20,),
                      const TextFieldWithIcon(
                        ico: Icons.location_on_rounded,
                        text: "30 Abdu Basha st, Cairo",
                      ),
                      const SizedBox(height: 20,),
                      const TextFieldWithIcon(
                          ico: Icons.view_headline_sharp,
                          text: "No Description No Description No Description No Description No Description No Description"
                      ),
                      const SizedBox(height: 30,),
                      const Divider(),
                      const SizedBox(height: 10,),
                      Text(
                        "Gifts List",
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)
                        ),
                      ),
                      const SizedBox(height: 15,),
                      const GiftItem(
                          text: "Messi's T-Shirt",
                          isPledged: true,
                        // icon_bg_color: Colors.grey,
                      ),
                      const GiftItem(text: "Messi's T-Shirt Messi's T-Shirt Messi's T-Shirt", ),
                      const GiftItem(text: "Messi's T-Shirt"),
                      const GiftItem(text: "Messi's T-Shirt",),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
