import 'package:flutter/material.dart';

import '../views/res/styles/app_styles.dart';

class AppDoubleText extends StatelessWidget {
  final String bigText;
  final String smallText;
  final String route;
  const AppDoubleText({super.key, required this.bigText, required this.smallText, required this.route});

  @override
  Widget build(BuildContext context) {
      return Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(bigText, style: AppStyles.headLineStyle2,),
          InkWell(
            onTap: () => Navigator.pushNamed(context, route),
            child: Text(smallText, style: AppStyles.textStyle.copyWith(
              color: AppStyles.primaryColor
            )),
          )
        ],
    );
  }
}
