import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hedieaty/views/res/styles/app_styles.dart';

import '../../widgets/notification_circle.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf1f4f9),
      body: Container(
        child: Column(
          children: [
            SizedBox(height:30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
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
                    alignment: Alignment(2.7, -1.2),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),

                        ),
                        child: IconButton(
                            onPressed: ()=>{},
                            icon: const Icon(CupertinoIcons.bell ,size: 28,)
                        ),
                      ),
                      NotificationCircle(upcomingEventsNum: 5,)
                    ]
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                        onPressed: ()=>{},
                        icon: const Icon(Icons.menu ,size: 28,)
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                image: const DecorationImage(image: AssetImage("assets/images/messi.jpeg"), fit: BoxFit.cover),
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
                Column(
                  children: [
                    const Text(
                      "360",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Post",
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
                Column(
                  children: [
                    const Text(
                      "160k",
                      style:  TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          fontFamily: "SanFrancisco"
                      ),
                    ),
                    Text(
                      "Follower",
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
                Column(
                  children: [
                    const Text(
                      "140k",
                      style:  TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          fontFamily: "SanFrancisco"
                      ),
                    ),
                    Text(
                      "Following",
                        style:  GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[500]
                          ),
                        )
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
