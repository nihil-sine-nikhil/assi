import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/blocs/auth_bloc/auth_bloc.dart';
import '../../domain/constants/ui_constants.dart';
import '../components/custom_snackbar/custom_snackbar.dart';

class EnterPhoneNumberScreen extends StatefulWidget {
  const EnterPhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<EnterPhoneNumberScreen> createState() => _EnterPhoneNumberScreenState();
}

class _EnterPhoneNumberScreenState extends State<EnterPhoneNumberScreen> {
  final TextEditingController _mobileNumberTC = TextEditingController();
  final myFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationOTPSentFailedState) {
          customErrorSnackBarMsg(time: 3, text: state.msg, context: context);
        }
      },
      builder: (context, state) {
        final _bloc = context.read<AuthenticationBloc>();
        return IgnorePointer(
          ignoring: (state is AuthenticationPhoneSubmittedLoadingState)
              ? true
              : false,
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        poppinsText(
                          txt: 'Enter',
                          fontSize: 22,
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
                            txt: 'Mobile Number',
                            fontSize: 20,
                            weight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(children: [
                      poppinsText(
                          txt: '+91', fontSize: 17, weight: FontWeight.w600),
                      const SizedBox(width: 35),
                      Expanded(
                          child: TextField(
                        focusNode: myFocusNode,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                        controller: _mobileNumberTC,
                        onSubmitted: (value) {
                          if (state is AuthenticationPhoneNumberValidState) {
                            _bloc.add(AuthenticationLoginSubmittedEvent(
                                value, context));
                          } else {
                            customErrorSnackBarMsg(
                                time: 3,
                                text: "Please, enter a valid number.",
                                context: context);
                          }
                        },
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                          hintText: "Mobile Number",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onChanged: (value) {
                          _bloc.add(AuthenticationPhoneNumberChangedEvent(
                              _mobileNumberTC.text));
                        },
                      )),
                    ]),
                    const Spacer(),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      height: 65,
                      minWidth: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      child: (state is AuthenticationPhoneSubmittedLoadingState)
                          ? const JumpingDots()
                          : poppinsText(
                              txt: "Next",
                              fontSize: 17,
                              weight: FontWeight.w600,
                            ),
                      onPressed: () {
                        myFocusNode.unfocus();

                        if (state is AuthenticationPhoneNumberValidState) {
                          _bloc.add(AuthenticationLoginSubmittedEvent(
                              _mobileNumberTC.text, context));
                        } else {
                          customErrorSnackBarMsg(
                              time: 3,
                              text: "Please, enter a valid number.",
                              context: context);
                        }
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
    _mobileNumberTC.dispose();
    myFocusNode.dispose();

    super.dispose();
  }
}

class JumpingDots extends StatefulWidget {
  const JumpingDots(
      {Key? key, this.numberOfDots = 3, this.color = Colors.white})
      : super(key: key);
  final int numberOfDots;
  final Color color;

  @override
  State<JumpingDots> createState() => _JumpingDotsState();
}

class _JumpingDotsState extends State<JumpingDots>
    with TickerProviderStateMixin {
  late List _animationControllers;
  final List _animations = [];
  int animationDuration = 200;
  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initAnimation() {
    ///initialization of _animationControllers
    ///each _animationController will have same animation duration
    _animationControllers = List.generate(
      widget.numberOfDots,
      (index) {
        return AnimationController(
            vsync: this, duration: Duration(milliseconds: animationDuration));
      },
    ).toList();

    ///initialization of _animations
    ///here end value is -20
    ///end value is amount of jump.
    ///and we want our dot to jump in upward direction
    for (int i = 0; i < widget.numberOfDots; i++) {
      _animations.add(
          Tween<double>(begin: 0, end: -20).animate(_animationControllers[i]));
    }
    for (int i = 0; i < widget.numberOfDots; i++) {
      _animationControllers[i].addStatusListener((status) {
        //On Complete
        if (status == AnimationStatus.completed) {
          //return of original postion
          _animationControllers[i].reverse();
          //if it is not last dot then start the animation of next dot.
          if (i != widget.numberOfDots - 1) {
            _animationControllers[i + 1].forward();
          }
        }
        //if last dot is back to its original postion then start animation of the first dot.
        // now this animation will be repeated infinitely
        if (i == widget.numberOfDots - 1 &&
            status == AnimationStatus.dismissed) {
          _animationControllers[0].forward();
        }
      });
    }
    //trigger animtion of first dot to start the whole animation.
    _animationControllers.first.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.numberOfDots, (index) {
          //AnimatedBuilder widget will rebuild it self when
          //_animationControllers[index] value changes.
          return AnimatedBuilder(
            animation: _animationControllers[index],
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(2.5),
                //Transform widget's translate constructor will help us to move the dot
                //in upward direction by changing the offset of the dot.
                //X-axis position of dot will not change.
                //Only Y-axis position will change.
                child: Transform.translate(
                  offset: Offset(0, _animations[index].value),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: widget.color),
                    height: 10,
                    width: 10,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
