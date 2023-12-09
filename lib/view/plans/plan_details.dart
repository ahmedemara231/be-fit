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

    // for(int i = 1; i <= widget.plan.length; i++)
    // {
    //   if(widget.plan['list$i']!.isNotEmpty)
    //   {
    //     print('still $i');
    //     widget.plan['list$i'];
    //   }
    //   else{
    //     print('remove $i');
    //     widget.plan.remove('list$i');
    //   }
    // }
    print(widget.plan);

    planLists = widget.plan.keys.toList();
    planLists.sort((a, b) {
      var aNum = int.parse(a.substring(4)); // Extract the number from the string
      var bNum = int.parse(b.substring(4)); // Extract the number from the string
      return aNum.compareTo(bNum); // Compare the extracted numbers
    });
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
          itemBuilder: (context, index) => InkWell(
            onTap: ()
            {
              print(widget.plan['list${index+1}']);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DayExercises(
                      dayExercises: widget.plan['list${index+1}']!,
                    ),
                  ),
              );
            },
            child: Card(
              color: Colors.red,
              child: ListTile(
                title: MyText(
                  // text: '${widget.plan['list${index+1}']}',
                  text: planLists[index],
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 16,),
          itemCount: planLists.length
      ),
    );
  }
}
