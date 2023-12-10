import 'package:be_fit/models/exercises.dart';
import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view/plans/every_day_exercises.dart';
import 'package:flutter/material.dart';

class PlanDetails extends StatefulWidget {
  Map<String,List<Exercises>> plan;
  String planName;
  PlanDetails({super.key,
    required this.plan,
    required this.planName,
  });

  @override
  State<PlanDetails> createState() => _PlanDetailsState();
}
late List<String> planLists;
class _PlanDetailsState extends State<PlanDetails> {
  @override
  void initState() {
    print('plan is : ${widget.plan}');

    widget.plan.forEach((key, value) {
      if(value.isNotEmpty)
        {
          print('still $key');
        }
      else{
        print('remove $key');
        widget.plan.remove(key);
      }
    });
    print(widget.plan);

    planLists = widget.plan.keys.toList();
    print(planLists);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
                  print(widget.plan['list${index+1}']);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DayExercises(
                          dayExercises: widget.plan['list${index+1}']!,
                          dayIndex: index + 1,
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
                      text: '${widget.plan['list${index+1}']?.length} exercises',
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Column(
                children: List.generate(
                  widget.plan['list${index+1}']!.length, (i) =>  Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.network(widget.plan['list${index+1}']![i].image)),
                    ),
                    MyText(
                      text: widget.plan['list${index+1}']![i].name,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),),
              ),
            ],
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 16,),
          itemCount: planLists.length
      ),
    );
  }
}
