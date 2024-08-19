class DeleteFromPlanModel
{
   String planDoc;
   int listIndex;
   int exerciseIndex;
   String exerciseDoc;
   String planName;

   DeleteFromPlanModel({
     required this.exerciseDoc,
     required this.listIndex,
     required this.planDoc,
     required this.exerciseIndex,
     required this.planName,
});
}