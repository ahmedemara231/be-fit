import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_plan/create_plan.dart';

class Plans extends StatefulWidget {
  const Plans({super.key});

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
              if(state is GetAllPlansLoadingState)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if(state is! GetAllPlansLoadingState)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {},
                        child: ListTile(
                          title: MyText(
                            text: PlansCubit.getInstance(context).plans[index]['workoutName'],
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 16,
                      ),
                      itemCount: PlansCubit.getInstance(context).plans.length),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}