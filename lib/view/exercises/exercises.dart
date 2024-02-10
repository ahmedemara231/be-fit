import 'package:be_fit/constants.dart';
import 'package:be_fit/extensions/container_decoration.dart';
import 'package:be_fit/extensions/mediaQuery.dart';
import 'package:be_fit/models/data_types/exercises.dart';
import 'package:be_fit/models/widgets/default_custom_buttons.dart';
import '../../../models/widgets/modules/myText.dart';
import 'package:be_fit/view/exercises/specificExercise/specificExercise.dart';
import 'package:be_fit/view_model/cache_helper/shared_prefs.dart';
import 'package:be_fit/view_model/exercises/cubit.dart';
import 'package:be_fit/view_model/exercises/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'createExercise.dart';

class ExercisesForMuscle extends StatefulWidget {
  String muscleName;
  int numberOfExercises;

  ExercisesForMuscle({
    super.key,
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
      context,
      muscleName: widget.muscleName,
    );
    ExercisesCubit.getInstance(context).getCustomExercises(
      context,
      uId: CacheHelper.getInstance().uId,
      muscle: widget.muscleName,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExercisesCubit, ExercisesStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: MyText(
              text:
                  '${widget.muscleName}   ${widget.numberOfExercises} Exercises',
              fontWeight: FontWeight.w500,
            ),
          ),
          body:state is GetCustomExercisesLoadingState || state is GetExercisesLoadingState?
          const Center(
            child: CircularProgressIndicator(),
        ):
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultAndCustomButtons(
                      text: 'Default',
                      onTap: ()
                      {
                        ExercisesCubit.getInstance(context).changeBody(1);
                      },
                      color: ExercisesCubit.getInstance(context).currentIndex == 1?
                      Constants.appColor:
                      null,
                  ),
                  DefaultAndCustomButtons(
                      text: 'Custom (${ExercisesCubit.getInstance(context).customExercises.length})',
                      onTap: ()
                      {
                        ExercisesCubit.getInstance(context).changeBody(2);
                      },
                      color: ExercisesCubit.getInstance(context).currentIndex == 2?
                      Constants.appColor:
                      null,
              
                  ),
                ],
              ),
              if(ExercisesCubit.getInstance(context).currentIndex == 1)
                Expanded(
                  child: RefreshIndicator(
                    backgroundColor: Colors.red[400],
                    color: Colors.white,
                    onRefresh: () {
                      ExercisesCubit.getInstance(context).getExercisesForSpecificMuscle(
                        context,
                        muscleName: widget.muscleName,
                      );
                      return Future(() => null);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 22.0,
                          horizontal: 8,
                      ),
                      child: ListView.separated(
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SpecificExercise(
                                    exercise: Exercises(
                                      name: ExercisesCubit.getInstance(context).exercises[index].name,
                                      docs: ExercisesCubit.getInstance(context).exercises[index].docs,
                                      id: ExercisesCubit.getInstance(context).exercises[index].id,
                                      image: ExercisesCubit.getInstance(context).exercises[index].image,
                                      isCustom: ExercisesCubit.getInstance(context).exercises[index].isCustom,
                                      video: ExercisesCubit.getInstance(context).exercises[index].video,
                                      muscleName: widget.muscleName,
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Image.network(
                                      ExercisesCubit.getInstance(context).exercises[index].image,
                                      errorBuilder: (context, error, stackTrace) => MyText(
                                        text: 'Failed to load image',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: MyText(
                                    text: ExercisesCubit.getInstance(context).exercises[index].name,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  trailing:
                                  const Icon(Icons.arrow_forward),
                                ),
                              ),
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                          const SizedBox(
                            height: 16,
                          ),
                          itemCount: ExercisesCubit.getInstance(context).exercises.length),
                    ),
                  ),
                ),
              if(ExercisesCubit.getInstance(context).currentIndex == 2)
                Expanded(
                  child: RefreshIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.red[400],
                    onRefresh: () async{
                      await ExercisesCubit.getInstance(context).getCustomExercises(
                        context,
                        uId: CacheHelper.getInstance().uId,
                        muscle: widget.muscleName,
                      );
                      return Future(() => null);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 22,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SpecificExercise(
                                              exercise: Exercises(
                                                name: ExercisesCubit.getInstance(context).customExercises[index].name,
                                                docs: ExercisesCubit.getInstance(context).customExercises[index].docs,
                                                id: ExercisesCubit.getInstance(context).customExercises[index].id,
                                                image: ExercisesCubit.getInstance(context).customExercises[index].image,
                                                isCustom: ExercisesCubit.getInstance(context).customExercises[index].isCustom,
                                                video: ExercisesCubit.getInstance(context).customExercises[index].video,
                                                muscleName: widget.muscleName,
                                              ),
                                              index: index,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading: Container(
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: Image.network(
                                            ExercisesCubit.getInstance(context).customExercises[index].image,
                                            errorBuilder: (context, error, stackTrace) => MyText(
                                              text: 'Failed to load image',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        title: MyText(
                                          text: ExercisesCubit.getInstance(context).customExercises[index].name,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        trailing: PopupMenuButton(
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem(
                                                onTap: () async {
                                                  await ExercisesCubit.getInstance(context).deleteCustomExercise(
                                                    context,
                                                    uId: CacheHelper.getInstance().uId,
                                                    muscleName: widget.muscleName,
                                                    index: index,
                                                  );
                                                },
                                                child: MyText(
                                                    text: 'Delete',
                                                    fontSize: 16
                                                ),
                                              ),
                                            ];
                                          },
                                          icon: const Icon(Icons.menu),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 16,
                                ),
                                itemCount:
                                ExercisesCubit.getInstance(context).customExercises.length),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                maintainState: false,builder: (context) => CreateExercise(
                                    muscleName: widget.muscleName,
                              ),
                              ),
                              );
                              },
                              child: Container(
                                width: context.setWidth(1.5),
                                height: 40,
                                decoration: BoxDecoration(
                                  border: context.decoration(),
                                ),
                                child: const Center(
                                  child:  Icon(Icons.add) 
                                ),
                              ),
                          )
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
