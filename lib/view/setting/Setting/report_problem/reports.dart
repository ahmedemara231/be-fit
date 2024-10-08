import 'package:be_fit/extensions/container_decoration.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../model/local/cache_helper/shared_prefs.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view_model/setting/cubit.dart';
import 'package:be_fit/view_model/setting/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  void initState() {
    SettingCubit.getInstance(context)
        .getAllReports(uId: CacheHelper.getInstance().getData('userData')[0]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Your Reports'),
          ),
          body: state is GetAllReportsLoadingState
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SettingCubit.getInstance(context).reports.isEmpty
                      ? Center(
                          child: MyText(
                            text: 'No Reports Yet',
                            fontSize: 16.sp,
                          ),
                        )
                      : ListView.separated(
                          itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 2),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: context.decoration(),
                                  ),
                                  child: ListTile(
                                    title: MyText(
                                      text: SettingCubit.getInstance(context)
                                          .reports[index]
                                          .problem,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.sp,
                                    ),
                                    subtitle: MyText(
                                      text: SettingCubit.getInstance(context)
                                          .reports[index]
                                          .dateTime,
                                      color: Colors.grey,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    trailing: MyText(
                                        text: 'Waiting...',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          separatorBuilder: (context, index) => SizedBox(
                                height: 16.h,
                              ),
                          itemCount:
                              SettingCubit.getInstance(context).reports.length),
                ),
        );
      },
    );
  }
}
