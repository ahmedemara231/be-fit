class DialogInputs
{
  String title;
  String confirmButtonText;
  String? cancelButtonText;
  void Function() onTapConfirm;

  DialogInputs({
    required this.title,
    required this.confirmButtonText,
    this.cancelButtonText,
    required this.onTapConfirm
  });
}