import 'package:challange_nextar/utils/colors.dart';
import 'package:challange_nextar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormFieldComponent extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final bool? obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final void Function(String? text)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onTap;
  final String hintText;
  final EdgeInsetsGeometry padding;
  final TextStyle? hintStyle;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final int? maxLength;

  const FormFieldComponent({
    super.key,
    this.textInputAction,
    this.maxLength,
    this.fillColor = Colors.white,
    required this.padding,
    this.hintStyle,
    required this.hintText,
    this.inputFormatters,
    this.onTap,
    this.controller,
    this.onFieldSubmitted,
    required this.labelText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        maxLength: maxLength,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onFieldSubmitted: onFieldSubmitted,
        keyboardType: keyboardType,
        validator: validator,
        onTap: onTap,
        cursorColor: AppColors.primary2,
        onChanged: onChanged,
        controller: controller,
        obscureText: obscureText ?? false,
        decoration: customDecoration(
          labelText,
          hintText,
        ),
      ),
    );
  }

  InputDecoration customDecoration(String label, String hint, [suffix]) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      counterText: "",
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.vermelhoPadrao),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.vermelhoPadrao),
      ),
      labelStyle: textFieldsLettersTextStyle(Colors.black),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
    );
  }
}
