import 'package:be_fit/extensions/container_decoration.dart';
import '../../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view/plans/plans/plan_details.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants.dart';
import '../create_plan/create_plan.dart';

class Plans extends StatelessWidget {
  const Plans({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlansCubit,PlansStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: 'Plans',fontWeight: FontWeight.bold,fontSize: 25,),
          ),
          body: RefreshIndicator(
            backgroundColor: Constants.appColor,
            color: Colors.white,
            onRefresh: ()async
            {
              await PlansCubit.getInstance(context).getAllPlans(
                  context,
                  CacheHelper.getInstance().uId
              );
              return Future(() => null);
            },
            child: state is GetAllPlans2LoadingState?
            const Center(
              child: CircularProgressIndicator(),
            ) :
            Padding(
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
                            onLongPress: ()
                            {
                              showMenu(
                                context: context,
                                position: RelativeRect.fromDirectional(
                                  textDirection: TextDirection.ltr,
                                  start: 50,
                                  top: 20,
                                  end: 50,
                                  bottom: 20,
                                ),
                                items: [
                                  PopupMenuItem(
                                    child: MyText(text: 'Delete'),
                                    onTap: () async
                                    {
                                      await PlansCubit.getInstance(context).deletePlan(
                                        context,
                                        index : index,
                                        uId: CacheHelper.getInstance().uId,
                                        planName: PlansCubit.getInstance(context).allPlans.keys.toList()[index],
                                      );
                                    },
                                  )
                                ],
                              );
                            },
                            onTap: ()
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlanDetails(
                                      planName: PlansCubit.getInstance(context).allPlans.keys.toList()[index],
                                      planDoc: PlansCubit.getInstance(context).allPlansIds[index],
                                    ),
                                  ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: context.decoration()
                              ),
                              child: ListTile(
                                title: MyText(text: PlansCubit.getInstance(context).allPlans.keys.toList()[index],fontSize: 20,fontWeight: FontWeight.w500,),
                                trailing: const Icon(Icons.arrow_forward),
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) => const SizedBox(height: 16,),
                          itemCount: PlansCubit.getInstance(context).allPlans.length,
                      ),
                    ),
                  InkWell(
                    onTap: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          maintainState: false,
                          builder: (context) => CreatePlan(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
            ),
          ),
        );
      },
    );
  }
}