import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/setting/cubit.dart';
import 'package:flutter/material.dart';
import '../../../models/widgets/contacting_us.dart';

class Contacting extends StatelessWidget {
  Contacting({super.key});
  
  List<ContactingUsModel> customerSupport =
  const
  [
    ContactingUsModel(
        icon: Icon(Icons.phone_android),
        title: 'Contacting Number',
        value: '+201069897'
    ),
    ContactingUsModel(
        icon: Icon(Icons.mail),
        title: 'E-mail Address',
        value: 'help@gmail.com'
    )
  ];

  List<ContactingUsModel> socialMedia =
  [
    const ContactingUsModel(
        icon: Icon(Icons.facebook),
        title: 'Facebook',
        value: 'help help'
    ),
    ContactingUsModel(
        icon: Image.network(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQk5rkswzExkLh0Ol6Y7Xcad4MLZRR4lpdENg&usqp=CAU',
        ),
        title: 'instagram',
        value: 'help2251',
    ),
    ContactingUsModel(
        icon: Image.network(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSGPh_mA_P4XT-GopPUmHCmgv5zwWiSLynZw&usqp=CAU',
        ),
        title: 'X',
        value: 'help_2451'
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: 'Contact us'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: MyText(text: 'You can get touch with us through these platforms, out team will reach out to you as soon as it could be possible',color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 16,maxLines: 3),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height/5,
            child: Card(
              elevation: 2,
              child: ListView.separated(
                  itemBuilder: (context, index) => InkWell(
                    onTap: ()
                    {
                      switch(index)
                      {
                        case 0:
                          SettingCubit.getInstance(context).contactingPhoneClick(
                            phone: 'tel:${customerSupport[0].value}',
                          );
                          break;
                        case 1:
                          SettingCubit.getInstance(context).contactingEmailClick(
                            emailAddress: 'mailto:${customerSupport[1].value}'
                          );
                      }
                    },
                      child: customerSupport[index],
                  ),
                  separatorBuilder: (context, index) => const SizedBox(height: 12,),
                  itemCount: customerSupport.length,
              ),
            ),
          ),
          const SizedBox(height: 20,),
          SizedBox(
            height: MediaQuery.of(context).size.height/3,
            child: Card(
              elevation: 2,
              child: ListView.separated(
                  itemBuilder: (context, index) => socialMedia[index],
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 12,
                  ),
                  itemCount: socialMedia.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
