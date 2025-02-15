import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_thesis_front_end/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:graduation_thesis_front_end/core/utils/date_input_formatter.dart';
import 'package:graduation_thesis_front_end/core/utils/show_snackbar.dart';
import 'package:graduation_thesis_front_end/core/utils/validators.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/pages/basic-information/survey_form_page.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/auth_field.dart';
import 'package:graduation_thesis_front_end/features/auth/presentation/widgets/complete_stage_bar.dart';
import 'package:intl/intl.dart';

class DobNameFormPage extends StatefulWidget {
  const DobNameFormPage({super.key});

  static const path = '/information/dob-name-form';

  @override
  State<DobNameFormPage> createState() => _DobNameFormPageState();
}

class _DobNameFormPageState extends State<DobNameFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String? _name;
  String? _dob;

  @override
  void initState() {
    super.initState();
    final appUserState = context.read<AppUserCubit>().state;

    if (appUserState is AppUserWithMissingDob) {
      _nameController.text = appUserState.user.name;
      setState(() {
        _name = appUserState.user.name;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _dobController.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        final formatedDate = DateFormat('dd/MM/yyyy').format(picked);
        _dob = formatedDate;
        _dobController.text = formatedDate;
      });
    }
  }

  void onNameChanged(String value) {
    setState(() {
      _name = value;
    });
  }

  void onDobChanged(String value) {
    setState(() {
      _dob = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          current is AuthUpdateDobNameFailure || current is AuthUpdateDobName,
      listener: (context, state) {
        if (state is AuthUpdateDobNameSuccess) {
          context.go(SurveyFormPage.path);
        }

        if (state is AuthUpdateDobNameFailure) {
          showSnackBar(context, 'Upload failed. Please try again.');
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Scaffold(
            body: Center(
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Center(
                      child: Text(
                    "Tell Us More About You",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                  SizedBox(height: 80),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          AuthField(
                              isEnabled: state is! AuthUpdateDobNameLoading,
                              fieldName: "Date Of Birth",
                              onChanged: onDobChanged,
                              prefixIcon: GestureDetector(
                                  onTap: _selectDate,
                                  child: Icon(Icons.calendar_month_outlined)),
                              hintText: "Select date",
                              inputFormatters: [dateMaskFormatter],
                              validators: [Validators.checkAgeOver14],
                              controller: _dobController),
                          SizedBox(height: 30),
                          AuthField(
                              isEnabled: state is! AuthUpdateDobNameLoading,
                              fieldName: "Name",
                              onChanged: onNameChanged,
                              prefixIcon: Icon(Icons.person_outline_outlined),
                              hintText: "Your name",
                              validators: [Validators.check80Characters],
                              controller: _nameController),
                        ],
                      )),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
                padding: EdgeInsets.all(0),
                color: Theme.of(context).scaffoldBackgroundColor,
                height: 100,
                child: Column(
                  children: [
                    CompleteStageBar(currentStep: 2),
                    SizedBox(height: 26),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton.outlined(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.all(14),
                              ),
                              onPressed: (_name == null || _dob == null) ||
                                      (_name!.isEmpty || _dob!.isEmpty) ||
                                      (Navigator.canPop(context)) ||
                                      state is AuthUpdateDobNameLoading
                                  ? null
                                  : () {
                                      Navigator.of(context).pop();
                                    },
                              icon: Icon(
                                Icons.arrow_back,
                              )),
                          SizedBox(width: 16),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: (_name == null || _dob == null) ||
                                      (_name!.isEmpty || _dob!.isEmpty) ||
                                      state is AuthUpdateDobNameLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthBloc>().add(
                                            AuthUpdateUserDobNameEvent(
                                                name: _nameController.text,
                                                dob: _dobController.text,
                                                user: (context
                                                            .read<AppUserCubit>()
                                                            .state
                                                        as AppUserWithMissingDob)
                                                    .user));
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15),
                              ),
                              label: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }
}
