import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view/plans/plans/plan_details.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            title: MyText(text: 'Plans'),
          ),
          body: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          maintainState: false,
                          builder: (context) => CreatePlan(),
                        ),
                      );
                    },
                    icon: SizedBox(
                      width: MediaQuery.of(context).size.width/2.2,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: MyText(
                                  text: 'Create new plan',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 10,),
                              const Icon(Icons.add),
                            ],
                          ),
                        ),
                      ),
                    )
                  ),
                ),
              ),
              if(state is GetAllPlans2LoadingState)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if(state is! GetAllPlans2LoadingState)
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
                                    index : index,
                                    uId: CacheHelper.uId,
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
                        child: Card(
                          color: Colors.red[400],
                          child: ListTile(
                            title: MyText(text: PlansCubit.getInstance(context).allPlans.keys.toList()[index],fontSize: 20,fontWeight: FontWeight.w500,),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) => const SizedBox(height: 16,),
                      itemCount: PlansCubit.getInstance(context).allPlans.length,
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}