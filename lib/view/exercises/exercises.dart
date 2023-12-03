import 'package:be_fit/modules/myText.dart';
import 'package:be_fit/view/exercises/specificExercise/specificExercise.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:be_fit/view_model/exercises/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'createExercise.dart';

class ExercisesForMuscle extends StatefulWidget {
  String muscleName;
  int numberOfExercises;

  ExercisesForMuscle({super.key,
    required this.muscleName,
    required this.numberOfExercises,
  });

  @override
  State<ExercisesForMuscle> createState() => _ExercisesForMuscleState();
}

class _ExercisesForMuscleState extends State<ExercisesForMuscle> {

  @override
  void initState() {
    ExercisesCubit.getInstance(context).getExercisesForSpecificMuscle(
        muscleName: widget.muscleName,
    );
    ExercisesCubit.getInstance(context).getCustomExercises(
        uId: '',
        muscle: widget.muscleName,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisesCubit,ExercisesStates>(
      builder: (context, state)
      {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: MyText(
                text: '${widget.muscleName}    ${widget.numberOfExercises} Exercises',
                fontWeight: FontWeight.w500,
              ),
              bottom: TabBar(
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                padding: const EdgeInsets.all(10),
                tabs:
                [
                  MyText(text: 'Default'),
                  MyText(text: 'Custom'),
                ],
              ),
            ),
            body: state is GetExercisesLoadingState?
            const Center(
                child: CircularProgressIndicator(),
              ):
                TabBarView(
                  children: [
                    // Default Exercises
                    ListView.separated(
                        itemBuilder: (context, index) => InkWell(
                          onTap: ()
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SpecificExercise(
                                  muscleName: widget.muscleName,
                                  id: ExercisesCubit.getInstance(context).exercises[index].id,
                                  docs: ExercisesCubit.getInstance(context).exercises[index].docs,
                                  name: ExercisesCubit.getInstance(context).exercises[index].name,
                                  image: ExercisesCubit.getInstance(context).exercises[index].image,
                                  videoUrl: ExercisesCubit.getInstance(context).exercises[index].video,
                                  isCustom: ExercisesCubit.getInstance(context).exercises[index].isCustom,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Image.network(ExercisesCubit.getInstance(context).exercises[index].image),
                                title: MyText(
                                  text: ExercisesCubit.getInstance(context).exercises[index].name,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          ),
                        ),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 16,
                        ),
                        itemCount: ExercisesCubit.getInstance(context).exercises.length
                    ),
                    // Custom Exercises
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.red,
                              child: IconButton(
                                onPressed: ()
                                {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateExercise(
                                        muscleName: widget.muscleName,
                                      ),
                                      // maintainState: false,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, index) => InkWell(
                                onTap: ()
                                {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SpecificExercise(
                                        videoUrl: ExercisesCubit.getInstance(context).customExercises[index].video,
                                        image: ExercisesCubit.getInstance(context).customExercises[index].image,
                                        name: ExercisesCubit.getInstance(context).customExercises[index].name,
                                        docs: ExercisesCubit.getInstance(context).customExercises[index].docs,
                                        id: ExercisesCubit.getInstance(context).customExercises[index].id,
                                        muscleName: widget.muscleName,
                                        isCustom: ExercisesCubit.getInstance(context).customExercises[index].isCustom,
                                        index: index,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: ListTile(
                                    leading: Image.network(ExercisesCubit.getInstance(context).customExercises[index].image),
                                    title: MyText(
                                      text: ExercisesCubit.getInstance(context).customExercises[index].name,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    trailing: const Icon(Icons.arrow_forward_ios),
                                  ),
                                ),
                              ),
                              separatorBuilder:(context, index) => const SizedBox(
                                height: 16,
                              ),
                              itemCount: ExercisesCubit.getInstance(context).customExercises.length),
                        ),
                      ],
                    ),
                  ],
                ),
          ),
        );
      },
    );
  }
}
