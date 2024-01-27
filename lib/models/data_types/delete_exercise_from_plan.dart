class DeleteFromPlanModel
{
   String planDoc;
   int listIndex;
   int exerciseIndex;
   String exerciseDoc;
   String planName;
   String uId;

   DeleteFromPlanModel({
     required this.uId,
     required this.exerciseDoc,
     required this.listIndex,
     required this.planDoc,
     required this.exerciseIndex,
     required this.planName,
});
}