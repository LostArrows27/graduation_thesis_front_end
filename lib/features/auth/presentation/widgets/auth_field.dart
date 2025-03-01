import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_thesis_front_end/core/utils/padding.dart';
import 'package:graduation_thesis_front_end/core/utils/validators.dart';

class AuthField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final List<String? Function(String?)> validators;
  final bool isObscureText;
  final bool isEnabled;
  final String? fieldName;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validators = const [],
    this.isObscureText = false,
    this.isEnabled = true,
    this.fieldName,
    this.prefixIcon,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late bool _isObscureText;

  @override
  void initState() {
    super.initState();
    _isObscureText = widget.isObscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _isObscureText = !_isObscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.fieldName != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.fieldName!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        TextFormField(
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatters,
          controller: widget.controller,
          enabled: widget.isEnabled,
          decoration: InputDecoration(
            contentPadding: PaddingUtils.pad(20, 15),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            labelText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isObscureText
                ? Padding(
                    padding: PaddingUtils.pad(10, 0),
                    child: IconButton(
                      icon: Icon(
                        _isObscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: _toggleObscureText,
                    ),
                  )
                : null,
          ),
          validator: Validators.combineValidators(widget.validators),
          obscureText: _isObscureText,
        ),
      ],
    );
  }
}
