
import 'package:be_fit/modules/otp_tff.dart';
import 'package:be_fit/modules/snackBar.dart';
import 'package:be_fit/view/log/Log.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/setRecord_model.dart';
import '../../modules/myText.dart';
import '../../view_model/exercises/states.dart';
import '../../widgets_models/records_model.dart';

class SpecificExercise extends StatelessWidget {

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

  final weightCont = TextEditingController();

  final repsCont = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisesCubit,ExercisesStates>(
      builder: (context, state)
      {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: MyText(text: name,fontWeight: FontWeight.w500,),
            actions: [
              TextButton(
                  onPressed: () 
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Log(
                            exerciseId: id,
                            muscleName: muscleName,
                            isCustom: isCustom,
                          ),
                        ),
                    );
                  },
                  child: MyText(text: 'Statistics',fontSize: 18,fontWeight: FontWeight.w500,))
            ],
          ),
          body: state is GetRecordsLoadingState?
          const Center(
            child: CircularProgressIndicator(),
          ):
          ListView(
            children: [
              StreamBuilder(
                stream: isCustom == false?
                FirebaseFirestore.instance.collection(muscleName).doc(id).collection('records').where('uId',isEqualTo: 'gBWhBoVwrGNldxxAKbKk').orderBy('dateTime').snapshots() :
                FirebaseFirestore.instance.collection('users').doc('gBWhBoVwrGNldxxAKbKk').collection('customExercises').doc(id).collection('records').orderBy('dateTime').snapshots(),
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
                                          text: '${snapshot.data?.docs[index].data()['weight']}',
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        MyText(
                                          text: '${snapshot.data?.docs[index].data()['reps']}',
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
                    image,
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
                            text: docs,
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
                                    if(isCustom == false)
                                      {
                                        await ExercisesCubit.getInstance(context).setRecord(
                                          recModel: SetRecModel(
                                              muscleName: muscleName,
                                              exerciseId: id,
                                              weight: weightCont.text,
                                              reps: repsCont.text,
                                              uId: 'gBWhBoVwrGNldxxAKbKk',
                                          ),
                                          context: context,
                                        ).then((value)
                                        {
                                          repsCont.clear();
                                          weightCont.clear();
                                        });
                                      }
                                    else{
                                      ExercisesCubit.getInstance(context).setRecordForCustomExercise(
                                        setCustomExerciseRecModel: SetCustomExerciseRecModel(
                                            index: index!,
                                            reps: repsCont.text,
                                            weight: weightCont.text,
                                            uId: 'gBWhBoVwrGNldxxAKbKk',
                                        ),
                                      ).then((value)
                                      {
                                        repsCont.clear();
                                        weightCont.clear();
                                      });
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
