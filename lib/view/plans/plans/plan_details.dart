import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view/plans/plans/every_day_exercises.dart';
import 'package:be_fit/view_model/plans/cubit.dart';
import 'package:be_fit/view_model/plans/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlanDetails extends StatefulWidget {

  String planName;
  String planDoc;

  PlanDetails({super.key,
    required this.planName,
    required this.planDoc,
  });

  @override
  State<PlanDetails> createState() => _PlanDetailsState();
}
class _PlanDetailsState extends State<PlanDetails> {

  late List<String> planLists;

  @override
  void initState() {
    planLists = PlansCubit.getInstance(context).allPlans[widget.planName].keys.toList();
    print(planLists);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlansCubit,PlansStates>(
      builder: (context, state)
      {
        return Scaffold(
          appBar: AppBar(
            title: MyText(text: widget.planName),
          ),
          body: ListView.separated(
              itemBuilder: (context, index) => Column(
                children: [
                  InkWell(
                    onTap: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DayExercises(
                            planName: widget.planName,
                            planDoc: widget.planDoc,
                            listIndex: index + 1,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.red,
                      child: ListTile(
                        title: MyText(
                          text: planLists[index],
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        trailing: MyText(
                          text: '${PlansCubit.getInstance(context).allPlans[widget.planName]['list${index+1}']?.length} exercises',
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: List.generate(
                      PlansCubit.getInstance(context).allPlans[widget.planName]['list${index+1}']!.length, (i) =>  ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                              width: 80,
                              height: 80,
                              child: Image.network(PlansCubit.getInstance(context).allPlans[widget.planName]['list${index+1}']![i].image)),
                        ),
                        subtitle: MyText(
                          text: PlansCubit.getInstance(context).allPlans[widget.planName]['list${index+1}']![i].name,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      trailing: MyText(
                          text: '${PlansCubit.getInstance(context).allPlans[widget.planName]['list${index+1}']![i].reps} X ${PlansCubit.getInstance(context).allPlans[widget.planName]['list${index+1}']![i].sets}',
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),
                    ),),
                  ),
                ],
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 16,),
              itemCount: planLists.length
          ),
        );
      },
    );
  }
}