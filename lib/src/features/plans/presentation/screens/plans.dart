import 'package:be_fit/src/core/extensions/container_decoration.dart';
import 'package:be_fit/src/core/extensions/routes.dart';
import 'package:be_fit/src/core/helpers/app_widgets/loading_indicator.dart';
import 'package:be_fit/src/features/plans/presentation/bloc/state.dart';
import 'package:be_fit/src/features/plans/presentation/screens/plan_details.dart';
import 'package:be_fit/src/features/plans/presentation/widgets/plan_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helpers/app_widgets/invalid_connection_screen.dart';
import '../../../../core/helpers/base_widgets/myText.dart';
import '../../../../core/helpers/global_data_types/dialog_inputs.dart';
import '../../../create_plan/presentation/screens/create_plan.dart';
import '../bloc/cubit.dart';

class Plans extends StatelessWidget {
  const Plans({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          text: 'Plans',
          fontWeight: FontWeight.bold,
          fontSize: 25.sp,
        ),
      ),
      body: RefreshIndicator(
          backgroundColor: Constants.appColor,
          color: Colors.white,
          onRefresh: () async => await context.read<PlansCubit>().getAllPlans(),
          child: BlocBuilder<PlansCubit, PlansState>(
            builder: (context, state) {
              switch(state.currentState){
                case PlansInternalStates.getPlansLoading:
                  return const LoadingIndicator();

                case PlansInternalStates.getPlansError:
                  return ErrorBuilder(
                    msg: state.errorMsg!,
                    onPressed: () async => await context.read<PlansCubit>().getAllPlans(),
                  );

                default:
                  return Padding(
                    padding:  EdgeInsets.all(12.0.r),
                    child: Column(
                      children: [
                        Expanded(
                          child: state.allPlans!.isEmpty ?
                          Center(
                            child: MyText(
                              text: 'No Plans Yet',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ) : ListView.separated(
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Map<String, dynamic> road = {
                                  'planName': state.allPlans?.keys.toList()[index],
                                  'planDoc': state.allPlansIds?[index],
                                };

                                context.read<PlansCubit>().roadToPlanExercise = road;
                                context.normalNewRoute(const PlanDetails());
                              },
                              child: PlanWidget(
                                  planName: state.allPlans!.keys.toList()[index],
                                  inputs: DialogInputs(
                                    title: 'Are you sure to delete ${state.allPlans?.keys.toList()[index]} ?',
                                    confirmButtonText: 'Delete',
                                    onTapConfirm: () async => await context.read<PlansCubit>().deletePlan(
                                      index: index,
                                      planName: state.allPlans!.keys.toList()[index],
                                    ),
                                  )
                              ),
                            ),
                            separatorBuilder: (context, index) => SizedBox(
                              height: 16.h,
                            ),
                            itemCount: state.allPlans!.length,
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.all(12.0.r),
                          child: InkWell(
                            onTap: () => context.normalNewRoute(const CreatePlan()),
                            child: Container(
                              height: 50.h,
                              decoration:
                              BoxDecoration(border: context.decoration()),
                              child: const Center(
                                child: Icon(Icons.add),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
              }
            },
          )),
    );
  }
}