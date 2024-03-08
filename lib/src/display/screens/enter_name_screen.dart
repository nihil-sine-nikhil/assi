import 'package:assignment/src/display/components/custom_textfield/custom_textfield.dart';
import 'package:assignment/src/display/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/blocs/user_bloc/user_bloc.dart';
import '../../domain/constants/app_constants.dart';
import '../../domain/constants/ui_constants.dart';
import '../components/custom_snackbar/custom_snackbar.dart';
import 'enter_phone_number_screen.dart';
import 'main_screen.dart';

class EnterNameScreen extends StatefulWidget {
  const EnterNameScreen({Key? key}) : super(key: key);

  @override
  State<EnterNameScreen> createState() => _EnterNameScreenState();
}

class _EnterNameScreenState extends State<EnterNameScreen> {
  final TextEditingController _nameTC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserCreateUserSuccessfulState) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false);
        }
        if (state is UserCreateUserFailedState) {
          customErrorSnackBarMsg(time: 3, text: state.msg, context: context);
        }
      },
      builder: (context, state) {
        final _bloc = context.read<UserBloc>();

        return IgnorePointer(
          ignoring: (state is UserAboutYouLoadingState) ? true : false,
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 40,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        poppinsText(
                          txt: 'About',
                          fontSize: 25,
                          weight: FontWeight.w600,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: poppinsText(
                            txt: 'you',
                            fontSize: 23,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    poppinsText(
                      txt: "What's your name",
                      fontSize: 17,
                      weight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: _nameTC,
                      title: 'Your Name',
                      textInputType: TextInputType.name,
                    ),
                    const Spacer(),
                    MaterialButton(
                      height: 65,
                      minWidth: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      child: (state is UserAboutYouLoadingState)
                          ? const JumpingDots()
                          : poppinsText(
                              txt: "Get started",
                              fontSize: 17,
                              weight: FontWeight.w600,
                            ),
                      onPressed: () async {
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();

                        if (_nameTC.text.isEmpty) {
                          customErrorSnackBarMsg(
                              time: 3,
                              text: "Oops! Can't have an empty name.",
                              context: context);
                        } else {
                          _bloc.add(
                            UserAboutYouSubmittedEvent(
                              UserModel(
                                phone: sp.getInt(AppConstant.spPhone),
                                name: _nameTC.text,
                                createdAt: FieldValue.serverTimestamp(),
                              ),
                            ),
                          );
                        }

                        // }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameTC.dispose();
    super.dispose();
  }
}
