import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/constants/styles/app_styles.dart';
import 'package:hedieaty/views/event/event_card_field_small.dart';
import 'package:hedieaty/views/event/event_details.dart';
import 'dart:math' as math;


class EventCardBig extends StatelessWidget {
  // final Event event;
  const EventCardBig({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Stack(
        alignment: const AlignmentDirectional(-1, -0.75),
        children: [
          Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 35, bottom: 30),
                padding: const EdgeInsets.only(right: 20, left: 20, top: 45, bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 0.2,
                      blurRadius: 3,
                      offset: const Offset(0, 1.5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "Leo Messi",
                            style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EventCardFieldSmall(
                                ico: Icons.celebration_rounded,
                                text: "Birthday Party"
                            ),
                            // Row(
                            //   children: [
                            //     Icon(Icons.cake, color: Colors.grey[800]),
                            //     const SizedBox(width: 5,),
                            //     Text(
                            //         "Birthday Party",
                            //         style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))
                            //     ),
                            //   ],
                            // ),
                            EventCardFieldSmall(
                                ico: Icons.card_giftcard_rounded,
                                text: "Remaining Gifts: 4"
                            ),
                          ],
                        ),
                        SizedBox(width: 10,),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EventCardFieldSmall(
                                ico: Icons.calendar_month,
                                text: "30-12-2024"
                            ),
                            // Row(
                            //   children: [
                            //     Icon(Icons.calendar_month, color: Colors.grey[800]),
                            //     const SizedBox(width: 5,),
                            //     Text(
                            //         "30-12-2024",
                            //         style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))
                            //     ),
                            //   ],
                            // ),
                            EventCardFieldSmall(
                                ico: Icons.timer_outlined,
                                text: "After 34 days",
                            ),
                            // Text(
                            //     "After 34 days",
                            //     style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))
                            // ),
                          ],
                        ),
                      ],
                    ),

                    MaterialButton(
                      child: Text(
                        "See Details",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueAccent
                          )
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: const Color(0xFFebebeb),
                          showDragHandle: true,
                          useSafeArea: true,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return const EventDetails();
                          },
                        );
                      },
                    )
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    vertical: BorderSide(width: 3, color: AppStyles.bgColor),
                    horizontal:  BorderSide(width: 3, color: AppStyles.bgColor),
                  ),
                  borderRadius: BorderRadius.circular(100),

                ),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/male-avatar.png"), fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        spreadRadius: 0.2,
                        blurRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          ),
          Transform.rotate(
              angle: - math.pi / 4,
            child:
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                // borderRadius: BorderRadius.circular(100),
                // image: DecorationImage(
                //   image: AssetImage("assets/images/bow.png"), fit: BoxFit.cover,
                // ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}
