import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view/plans/plan_details.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_plan/create_plan.dart';

class Plans extends StatefulWidget {
  Plans({super.key});
  List<String> plansKeys = [];
  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  @override
  void initState() {
    PlansCubit.getInstance(context).getAllPlans();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    PlansCubit.getInstance(context).allKeys();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlansCubit,PlansStates>(
      listener: (context, state) {},
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
                  child: CircleAvatar(
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
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ),
              ),
              if(state is GetAllPlans2LoadingState)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if(state is! GetAllPlansLoadingState)
                // MyText(text: '${PlansCubit.getInstance(context).allPlans}',maxLines: 20,fontSize: 25,)
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) => InkWell(
                        onTap: ()
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlanDetails(
                                  planName: PlansCubit.getInstance(context).allKeys()[index],
                                  plan: PlansCubit.getInstance(context).allPlans['plan$index'],
                                ),
                              ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            title: MyText(text: PlansCubit.getInstance(context).allKeys()[index]),
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