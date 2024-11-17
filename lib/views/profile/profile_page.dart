import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/styles/app_styles.dart';

import '../../widgets/notification_circle.dart';

class ProfilePage extends StatelessWidget {

  const ProfilePage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf1f4f9),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height:40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(50),
                //   ),
                //   child: IconButton(
                //       onPressed: ()=>{},
                //       icon: const Icon(FluentSystemIcons.ic_fluent_settings_regular ,size: 28,)
                //   ),
                // ),
                Stack(
                  alignment: const Alignment(2.7, -1.2),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(1, 5),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: ()=>{},
                        icon: const Icon(CupertinoIcons.bell ,size: 28,),
                        tooltip: "Notifications",

                      ),
                    ),
                    const NotificationCircle(num: 5,)
                  ]
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(1, 5),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: ()=>{},
                    icon: const Icon(Icons.menu ,size: 28,),
                    tooltip: "Menu",
                  ),
                ),
              ],
            ),
              Container (
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  image: const DecorationImage(image: AssetImage("assets/images/messi.jpeg"), fit: BoxFit.cover),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(1, 5),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20,),
            SizedBox(
              child: Text(
                "Leo Messi",
                style: AppStyles.headLineStyle2.copyWith(fontFamily: "SanFrancisco"),
              ),
            ),
            const SizedBox(
              child: Text(
                "@leo_messi",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              height: 1,
              width: 360,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(1, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "360",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Events",
                          style:  GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[500]
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(1, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "100",
                        style:  TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            fontFamily: "SanFrancisco"
                        ),
                      ),
                      Text(
                        "Friends",
                          style:  GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[500]
                            ),
                          )
                      )
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(vertical: 10,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(1, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "30",
                        style:  TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            fontFamily: "SanFrancisco"
                        ),
                      ),
                      Text(
                        "Gifts",
                          style:  GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[500]
                            ),
                          )
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
