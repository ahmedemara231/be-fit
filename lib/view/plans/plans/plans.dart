import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/routes.dart';
import 'package:be_fit/models/data_types/dialog_inputs.dart';
import 'package:be_fit/models/widgets/app_dialog.dart';
import 'package:be_fit/models/widgets/invalid_connection_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view/plans/plans/plan_details.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/constants.dart';
import '../create_plan/create_plan.dart';

class Plans extends StatefulWidget {
  const Plans({super.key});

  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> {


  @override
  void initState() {
    PlansCubit.getInstance(context).getPlans(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Plans',fontWeight: FontWeight.bold,fontSize: 25,),
          ),
          body: RefreshIndicator(
            backgroundColor: Constants.appColor,
            color: Colors.white,
            onRefresh: ()async
            {
              await PlansCubit.getInstance(context).getAllPlans(context);
            },
            child: BlocBuilder<PlansCubit,PlansStates>(
              builder: (context, state) {
                if(state is GetAllPlansLoadingState)
                  {
                    return Center(
                      child: SpinKitCircle(
                        color: Constants.appColor,
                        size: 50.0,
                      ),
                    );
                  }
                else if(state is GetAllPlansErrorState)
                  {
                    return ErrorBuilder(
                        msg: 'Try Again Later',
                        onPressed: ()async
                        => await PlansCubit.getInstance(context).getAllPlans(context)
                    );
                  }
                else{
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: PlansCubit.getInstance(context).allPlans.isEmpty?
                          Center(
                            child: MyText(text: 'No Plans Yet',fontSize: 20,fontWeight: FontWeight.w500,),
                          ):
                          ListView.separated(
                            itemBuilder: (context, index) => InkWell(
                              onTap: ()
                              {
                                Map<String, dynamic> road =
                                {
                                  'planName' : PlansCubit.getInstance(context).allPlans.keys.toList()[index],
                                  'planDoc' : PlansCubit.getInstance(context).allPlansIds[index],
                                };

                                PlansCubit.getInstance(context).roadToPlanExercise = road;
                                context.normalNewRoute(const PlanDetails());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: context.decoration()
                                ),
                                child: ListTile(
                                  title: MyText(
                                    text: PlansCubit.getInstance(context).allPlans.keys.toList()[index],
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  trailing:
                                  PopupMenuButton(
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                          child: MyText(text: 'Delete'),
                                          onTap: () async
                                          {
                                            await AppDialog.showAppDialog(
                                                context,
                                                inputs: DialogInputs(
                                                    title: 'Are you sure to delete ${PlansCubit.getInstance(context).allPlans.keys.toList()[index]} ?',
                                                    confirmButtonText: 'Delete',
                                                    onTapConfirm: ()async => await PlansCubit.getInstance(context).deletePlan(
                                                      context,
                                                      index : index,
                                                      planName: PlansCubit.getInstance(context).allPlans.keys.toList()[index],
                                                    ),
                                                )
                                            );
                                          },
                                        )
                                      ];
                                    },
                                    icon: const Icon(Icons.menu),
                                  ),
                                ),
                              ),
                            ),
                            separatorBuilder: (context, index) => const SizedBox(height: 16,),
                            itemCount: PlansCubit.getInstance(context).allPlans.length,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: InkWell(
                            onTap: () => context.normalNewRoute(const CreatePlan()),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  border: context.decoration()
                              ),
                              child: const Center(child: Icon(Icons.add),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            )
          ),
        );
  }
}