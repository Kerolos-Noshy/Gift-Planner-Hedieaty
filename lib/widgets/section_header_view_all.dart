import 'package:flutter/material.dart';

import '../../constants/styles/app_styles.dart';

class SectionHeaderViewAll extends StatelessWidget {
  final String text;
  final String route;
  const SectionHeaderViewAll({super.key, required this.text, required this.route});

  @override
  Widget build(BuildContext context) {
      return Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: AppStyles.headLineStyle2,),
          IconButton(
            enableFeedback: false,
            tooltip: "View All",
            // highlightColor: Colors.transparent,
            onPressed: () => Navigator.pushNamed(context, route),
            padding: const EdgeInsets.all(4),
            iconSize: 14,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    spreadRadius: 1,
                    blurRadius: 10,
                    // offset: const Offset(1, 5),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 1.5),
                ),
                child: const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.black,)
              ),
            )
          )
        ],
    );
  }
}
