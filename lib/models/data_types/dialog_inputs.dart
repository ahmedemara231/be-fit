class DialogInputs
{
  String title;
  String confirmButtonText;
  String? cancelButtonText;
  void Function() onTapConfirm;
  void Function()? onTapCancel;

  DialogInputs({
    required this.title,
    required this.confirmButtonText,
    this.cancelButtonText,
    required this.onTapConfirm,
    this.onTapCancel
  });
}