import 'package:be_fit/extensions/container_decoration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/setting/cubit.dart';
import 'package:flutter/material.dart';
import '../../../models/widgets/contacting_us.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Contacting extends StatelessWidget {
  Contacting({super.key});

  List<ContactingUsModel> customerSupport = const [
    ContactingUsModel(
        icon: Icon(Icons.phone_android),
        title: 'Contacting Number',
        value: '+201069897'),
    ContactingUsModel(
        icon: Icon(Icons.mail),
        title: 'E-mail Address',
        value: 'help@gmail.com')
  ];

  List<ContactingUsModel> socialMedia = [
    const ContactingUsModel(
        icon: Icon(Icons.facebook), title: 'Facebook', value: 'help help'),
    ContactingUsModel(
      icon: Padding(
        padding: EdgeInsets.all(7.0.r),
        child: CachedNetworkImage(
          imageUrl:
              'https://www.pngall.com/wp-content/uploads/5/Instagram-Logo.png',
          color: Colors.white,
          errorWidget: (context, url, error) =>
              MyText(text: 'Failed Load Image'),
        ),
      ),
      title: 'instagram',
      value: 'help2251',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: 'Contact us'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0.r),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: MyText(
                  text:
                      'You can get touch with us through these platforms, out team will reach out to you as soon as it could be possible',
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  maxLines: 3,
                ),
              ),
              Container(
                decoration: BoxDecoration(border: context.decoration()),
                child: Padding(
                  padding: EdgeInsets.all(10.0.r),
                  child: Column(
                    children: List.generate(
                      customerSupport.length,
                      (index) => InkWell(
                        onTap: () {
                          switch (index) {
                            case 0:
                              SettingCubit.getInstance(context)
                                  .contactingPhoneClick(
                                phone: 'tel:${customerSupport[index].value}',
                              );
                              break;
                            case 1:
                              SettingCubit.getInstance(context)
                                  .contactingEmailClick(
                                      emailAddress:
                                          'mailto:${customerSupport[index].value}');
                          }
                        },
                        child: customerSupport[index],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                decoration: BoxDecoration(border: context.decoration()),
                child: Padding(
                  padding: EdgeInsets.all(10.0.r),
                  child: Column(
                    children: List.generate(
                      socialMedia.length,
                      (index) => socialMedia[index],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
