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
import '../../models/widgets/modules/textFormField.dart';
import 'create_exercise.dart';

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

  final searchCont = TextEditingController();

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16),
            child: Column(
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
                      text: 'Custom (${ExercisesCubit.getInstance(context).customExercisesList.length})',
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
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10),
                        child: TFF(
                          obscureText: false,
                          controller: searchCont,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Constants.appColor),
                              borderRadius: BorderRadius.circular(25)
                          ),
                          hintText: 'Search for Exercise',
                          prefixIcon: const Icon(Icons.search),
                          onChanged: (newLetter)
                          {
                            if(ExercisesCubit.getInstance(context).currentIndex == 1)
                              {
                                ExercisesCubit.getInstance(context).exerciseSearch(newLetter);
                              }
                            else{
                              ExercisesCubit.getInstance(context).customExerciseSearch(newLetter);
                            }
                          },
                        ),
                      ),
                      if(ExercisesCubit.getInstance(context).currentIndex == 1)
                        RefreshIndicator(
                          backgroundColor: Constants.appColor,
                          color: Colors.white,
                          onRefresh: () {
                            ExercisesCubit.getInstance(context).getExercisesForSpecificMuscle(
                              context,
                              muscleName: widget.muscleName,
                            );
                            return Future(() => null);
                          },
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SpecificExercise(
                                        exercise: Exercises(
                                          name: ExercisesCubit.getInstance(context).exercisesList[index].name,
                                          docs: ExercisesCubit.getInstance(context).exercisesList[index].docs,
                                          id: ExercisesCubit.getInstance(context).exercisesList[index].id,
                                          image: ExercisesCubit.getInstance(context).exercisesList[index].image,
                                          isCustom: ExercisesCubit.getInstance(context).exercisesList[index].isCustom,
                                          video: ExercisesCubit.getInstance(context).exercisesList[index].video,
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
                                          ExercisesCubit.getInstance(context).exercisesList[index].image[0],
                                          errorBuilder: (context, error, stackTrace) => MyText(
                                            text: 'Failed to load image',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      title: MyText(
                                        text: ExercisesCubit.getInstance(context).exercisesList[index].name,
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
                              itemCount: ExercisesCubit.getInstance(context).exercisesList.length),
                        ),
                      if(ExercisesCubit.getInstance(context).currentIndex == 2)
                        RefreshIndicator(
                          color: Colors.white,
                          backgroundColor: Constants.appColor,
                          onRefresh: () async{
                            await ExercisesCubit.getInstance(context).getCustomExercises(
                              context,
                              uId: CacheHelper.getInstance().uId,
                              muscle: widget.muscleName,
                            );
                            return Future(() => null);
                          },
                          child: Column(
                            children: [
                              if(ExercisesCubit.getInstance(context).customExercisesList.isEmpty)
                                Expanded(
                                    child: Center(
                                      child: MyText(text: 'No Custom Exercises Yet',fontSize: 20,fontWeight: FontWeight.w500),
                                    ),
                                ),
                              if(ExercisesCubit.getInstance(context).customExercisesList.isNotEmpty)
                                ListView.separated(
                                    shrinkWrap:  true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SpecificExercise(
                                                  exercise: Exercises(
                                                    name: ExercisesCubit.getInstance(context).customExercisesList[index].name,
                                                    docs: ExercisesCubit.getInstance(context).customExercisesList[index].docs,
                                                    id: ExercisesCubit.getInstance(context).customExercisesList[index].id,
                                                    image: ExercisesCubit.getInstance(context).customExercisesList[index].image,
                                                    isCustom: ExercisesCubit.getInstance(context).customExercisesList[index].isCustom,
                                                    video: ExercisesCubit.getInstance(context).customExercisesList[index].video,
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
                                                ExercisesCubit.getInstance(context).customExercisesList[index].image[0],
                                                errorBuilder: (context, error, stackTrace) => MyText(
                                                  text: 'Failed to load image',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            title: MyText(
                                              text: ExercisesCubit.getInstance(context).customExercisesList[index].name,
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
                                    separatorBuilder: (context, index) => const SizedBox(height: 16,),
                                    itemCount: ExercisesCubit.getInstance(context).customExercisesList.length
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                child: InkWell(
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
                                    width: context.setWidth(1.2),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: context.decoration(),
                                    ),
                                    child: const Center(
                                        child:  Icon(Icons.add)
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
