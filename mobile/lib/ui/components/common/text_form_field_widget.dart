import 'package:flutter/material.dart';

import '../../../utils/text_styles.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget(
      {this.validator,
      this.onChanged,
      this.onSaved,
      this.textEditingController,
      this.hintText,
      this.errorText,
      this.keyboardType,
      this.obscureText,
      this.maxLength,
      this.initialValue,
      this.suffix});

  final String errorText;
  final String hintText;
  final String initialValue;
  final TextInputType keyboardType;
  final int maxLength;
  final bool obscureText;
  final Function onChanged;
  final Function onSaved;
  final Widget suffix;
  final TextEditingController textEditingController;
  final Function validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      validator: validator ??
          (text) {
            return null;
          },
      controller: textEditingController,
      style: TextStyles.black14TextStyle,
      textInputAction: TextInputAction.done,
      keyboardType: keyboardType ?? TextInputType.text,
      onChanged: onChanged ?? (data) {},
      onSaved: onSaved ?? (data) {},
      obscureText: obscureText ?? false,
      initialValue: initialValue,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        suffixIcon: suffix ?? const Text(''),
        hintText: hintText ?? '',
        errorText: errorText,
        errorMaxLines: 2,
        errorStyle: TextStyle(
          fontFamily: FontFamily.regular,
          color: const Color(0xffff4d2b),
          fontSize: 12,
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffff4d2b),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffff4d2b),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffe0e0e0),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
      ),
    );
  }
}
