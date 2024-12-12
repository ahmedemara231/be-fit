import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/data_source/local/cache_helper/shared_prefs.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import 'number_selector.dart';

class ChoosePlanDaysNumber extends StatelessWidget {
  const ChoosePlanDaysNumber({Key? key,
    required this.currentIndex,
  }) : super(key: key);

  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 28),
      child: Row(
        children: [
          MyText(
            text: 'Training Days',
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
          Padding(
            padding:  EdgeInsets.all(10.0.r),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: CacheHelper.getInstance().shared.getBool('appTheme') == false ?
                  Colors.grey[300] : Colors.grey[700]
              ),
              child: Padding(
                padding:  EdgeInsets.all(8.0.r),
                child: MyText(
                  text: currentIndex.toString(),
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
          const Spacer(),
          const NumberSelection(),
        ],
      ),
    );
  }
}
