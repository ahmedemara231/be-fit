import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/local/cache_helper/shared_prefs.dart';
import 'modules/myText.dart';

class ContactingUsModel extends StatelessWidget {
  final Widget icon;
  final String title;
  final String value;

  const ContactingUsModel({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            CacheHelper.getInstance().shared.getBool('appTheme') == false
                ? Colors.grey[200]
                : Colors.grey[700],
        child: Container(
          child: icon,
        ),
      ),
      title: MyText(
        text: title,
        color: Colors.grey,
        fontWeight: FontWeight.bold,
      ),
      subtitle: MyText(
        text: value,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
      ),
    );
  }
}
