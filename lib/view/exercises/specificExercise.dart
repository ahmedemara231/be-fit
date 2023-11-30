import 'package:be_fit/models/records_model.dart';
import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/modules/otp_tff.dart';
import 'package:be_fit/modules/snackBar.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/exercises/states.dart';

class SpecificExercise extends StatefulWidget {

  String name;
  String image;
  String docs;
  String id;
  bool isCustom;
  int? index;

  String muscleName;

  SpecificExercise({super.key,
    required this.image,
    required this.name,
    required this.docs,
    required this.id,
    required this.muscleName,
    required this.isCustom,
    this.index,
  });

  @override
  State<SpecificExercise> createState() => _SpecificExerciseState();
}

class _SpecificExerciseState extends State<SpecificExercise> {
  final weightCont = TextEditingController();

  final repsCont = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if(widget.isCustom == false)
      {
        print(false);
      }
    else{
      print(true);
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisesCubit,ExercisesStates>(
      builder: (context, state)
      {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: MyText(text: widget.name,fontWeight: FontWeight.w500,),
          ),
          body: state is GetRecordsLoadingState?
          const Center(
            child: CircularProgressIndicator(),
          ):
          ListView(
            children: [
              StreamBuilder(
                stream: widget.isCustom == false?
                FirebaseFirestore.instance.collection(widget.muscleName).doc(widget.id).collection('records').where('uId',isEqualTo: 'gBWhBoVwrGNldxxAKbKk').orderBy('dateTime').snapshots() :
                FirebaseFirestore.instance.collection('users').doc('gBWhBoVwrGNldxxAKbKk').collection('customExercises').doc(widget.id).collection('records').snapshots(),
                builder: (context, snapshot)
                {
                  if(snapshot.hasData)
                  {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: MediaQuery.of(context).size.height/4,
                      child: Column(
                        children: [
                          const RecordsModel(),
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    SizedBox(
                                      width: 100,
                                      child: Column(
                                        children: [
                                          MyText(
                                            text: snapshot.data?.docs[index].data()['dateTime'],
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        MyText(
                                          text: snapshot.data?.docs[index].data()['weight'],
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        MyText(
                                          text: snapshot.data?.docs[index].data()['reps'],
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              itemCount: snapshot.data?.docs.length,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  else if(snapshot.hasError)
                  {
                    MySnackBar.showSnackBar(
                        context: context,
                        message: 'Try again latter'
                    );
                    return MyText(text: '');
                  }
                  else {return MyText(text: '');}
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: ()
                    {
                      scaffoldKey.currentState!.showBottomSheet((context) => SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height/1.2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyText(
                            text: widget.docs,
                            maxLines: 20,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ));
                    },
                    icon: const Icon(Icons.question_mark),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month,color: Colors.white,size: 55,),
                              MyText(text: 'TODAY',color: Colors.white,fontSize: 25,),
                            ],
                          ),
                        ),
                        Form(
                          key: formKey,
                          child: Row(
                            children: [
                              const Spacer(),
                              SizedBox(
                                width: MediaQuery.of(context).size.width/5,
                                child: OtpTff(
                                  controller: weightCont,
                                  hintText: 'weight',
                                ),
                              ),
                              const Spacer(flex: 4,),
                              SizedBox(
                                width: MediaQuery.of(context).size.width/5,
                                child: OtpTff(
                                  controller: repsCont,
                                  hintText: 'reps',
                                ),
                              ),
                              const Spacer(flex: 4,),
                              InkWell(
                                onTap: () async
                                {
                                  if(formKey.currentState!.validate())
                                  {
                                    if(widget.isCustom == false)
                                      {
                                        await ExercisesCubit.getInstance(context).setRecord(
                                          muscleName: widget.muscleName,
                                          exerciseId: widget.id,
                                          weight: weightCont.text,
                                          reps: repsCont.text,
                                          uId: 'gBWhBoVwrGNldxxAKbKk',
                                          context: context,
                                        ).then((value)
                                        {
                                          repsCont.clear();
                                          weightCont.clear();
                                        });
                                      }
                                    else{
                                      ExercisesCubit.getInstance(context).setRecordForCustomExercise(
                                          index: widget.index!,
                                          reps: repsCont.text,
                                          weight: weightCont.text,
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: const Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Icon(Icons.add,size: 30,)
                                    )),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
