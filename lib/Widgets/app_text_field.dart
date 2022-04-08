import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final FocusNode focusNode;
  final List<TextInputFormatter> formatter;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool? enabled;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final bool? obscureText;
  final Widget? suffix;
  final Widget? prefix;
  final Color? borderColor;
  final int? minLines;
  final int? maxLines;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.formatter,
    this.onSubmitted,
    this.onChanged,
    this.hintText,
    this.enabled,
    this.keyboardType,
    this.textAlign,
    this.obscureText,
    this.suffix,
    this.prefix,
    this.borderColor,
    this.minLines,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: maxLines??1,
      maxLines: maxLines??1,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      focusNode: focusNode,
      controller: controller,
      inputFormatters: formatter,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      cursorColor: Constants.appHighlightColor,
      enabled: enabled ?? true,
      textAlign: textAlign ?? TextAlign.left,
      style: const TextStyle(
        color: Constants.appPrimaryColor,
        fontSize: Constants.appHeading7Size,
      ),
      decoration: InputDecoration(
        suffixIcon: suffix,
        prefixIcon: prefix,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Constants.appGreyColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: borderColor ?? Theme.of(context).indicatorColor,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Constants.appHighlightColor,
            width: 0.5,
          ),
        ),
      ),
    );
  }
}
