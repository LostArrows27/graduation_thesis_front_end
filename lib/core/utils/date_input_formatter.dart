import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final dateMaskFormatter = MaskTextInputFormatter(
  mask: '##@##@####',
  filter: {"#": RegExp(r'\d'), "@": RegExp(r'\/')},
  type: MaskAutoCompletionType.lazy,
);
