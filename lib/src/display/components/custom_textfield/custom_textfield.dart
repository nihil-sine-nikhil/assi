import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.hint,
    required this.title,
    this.inputFormatters,
    this.focusNode,
    this.isObscure = false,
    required this.textInputType,
  });
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? hint;
  final String title;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextInputType textInputType;
  final bool isObscure;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool obscureText;
  @override
  void initState() {
    super.initState();
    obscureText = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13.sp,
            color: Colors.black87,
          ),
        ),
        Gap(3.h),
        TextFormField(
          obscuringCharacter: '*',
          focusNode: widget.focusNode,
          controller: widget.controller,
          keyboardType: widget.textInputType,
          obscureText: obscureText,
          inputFormatters: widget.inputFormatters,
          textInputAction: TextInputAction.next,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey,
              fontSize: 0.017.sh,
            ),
            suffixIcon: widget.isObscure
                ? InkWell(
                    onTap: () => setState(() => obscureText = !obscureText),
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: !obscureText
                            ? Icon(
                                Icons.visibility_off,
                                color: Colors.grey.shade700,
                              )
                            : Icon(
                                Icons.visibility,
                                color: Colors.grey.shade700,
                              )),
                  )
                : null,
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                  width: 1.5, color: Colors.black12), //<-- SEE HERE
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Colors.black54,
                width: 1.5,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          ),
        ),
      ],
    );
  }
}
