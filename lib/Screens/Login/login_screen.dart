import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:durood_together_app/AppReserved/helpers.dart';
import 'package:durood_together_app/Services/Firebase/authentication.dart';
import 'package:durood_together_app/Services/dialogs.dart';
import 'package:durood_together_app/Widgets/app_elevated_button.dart';
import 'package:durood_together_app/Widgets/app_text_field.dart';
import 'package:durood_together_app/Widgets/my_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordNode = FocusNode();

  late bool hiddenPassword;
  late bool login;
  late bool enabled;

  @override
  void initState() {
    super.initState();
    login = true;
    hiddenPassword = true;
    enabled = true;
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Expanded(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            child: Container(
              // padding: const EdgeInsets.symmetric(
              //     vertical: 10.0, horizontal: 20.0),
              width: double.infinity,
              color: Constants.appTransparent,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ...fixedWidgets(),
                      //Sing in/Sign up option
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              login ? 'New User?' : 'Already have an account?',
                              style: const TextStyle(
                                color: Constants.appPrimaryColor,
                              ),
                            ),
                            Material(
                              color: Constants.appTransparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    login = !login;
                                  });
                                },
                                splashColor: Constants.appHighlightColor,
                                highlightColor: Constants.appHighlightColor,
                                child: Text(
                                  login ? ' Sign up' : ' Log in',
                                  style: const TextStyle(
                                    color: Constants.appHighlightColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Sing in/Sign up form
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            // Email Container
                            AppTextField(
                              controller: emailController,
                              focusNode: emailNode,
                              formatter: const [],
                              hintText: "Email",
                              borderColor: login
                                  ? Theme.of(context).indicatorColor
                                  : Theme.of(context).colorScheme.secondary,
                              prefix: Icon(
                                Icons.alternate_email,
                                color: login
                                    ? Theme.of(context).indicatorColor
                                    : Theme.of(context).colorScheme.secondary,
                              ),
                              onSubmitted: (value) {
                                passwordNode.requestFocus();
                              },
                            ),
                            // Password Container
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20.0,
                              ),
                              child: AppTextField(
                                controller: passwordController,
                                focusNode: passwordNode,
                                formatter: const [],
                                hintText: "Password",
                                borderColor: login
                                    ? Theme.of(context).indicatorColor
                                    : Theme.of(context).colorScheme.secondary,
                                prefix: Icon(
                                  Icons.lock,
                                  color: login
                                      ? Theme.of(context).indicatorColor
                                      : Theme.of(context).colorScheme.secondary,
                                ),
                                suffix: InkWell(
                                  customBorder: const CircleBorder(),
                                  splashColor: Constants.appHighlightColor,
                                  onTap: () {
                                    setState(() {
                                      hiddenPassword = !hiddenPassword;
                                    });
                                  },
                                  child: hiddenPassword
                                      ? const Icon(
                                          Icons.remove_red_eye_outlined,
                                          color: Constants.appRedColor,
                                        )
                                      : const Icon(
                                          Icons.remove_red_eye,
                                          color: Constants.appPrimaryColor,
                                        ),
                                ),
                                obscureText: hiddenPassword,
                                onSubmitted: (value) {
                                  passwordNode.unfocus();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      // //Forgot Password
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Constants.appPrimaryColor,
                              ),
                            ),
                            Material(
                              color: Constants.appTransparent,
                              child: InkWell(
                                onTap: () {
                                  resetPasswordPopUp(context);
                                },
                                splashColor: Constants.appHighlightColor,
                                highlightColor: Constants.appHighlightColor,
                                child: const Text(
                                  ' Reset Password',
                                  style: TextStyle(
                                    color: Constants.appHighlightColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // // Save Password and Sign with Row
                      const SizedBox(
                        height: 10,
                      ),
                      AppElevatedButton(
                        onPressed: () async {
                          if (emailController.text.isEmpty ||
                              emailController.text == '' ||
                              passwordController.text.isEmpty ||
                              passwordController.text == '') {
                            final snackBar = SnackBar(
                              duration: const Duration(seconds: 2),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 8.0,
                              ),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.7),
                              content: Text(
                                'Please Enter Details',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            login ? await loginNow() : await signUpNow();
                          }
                        },
                        buttonText: login ? 'Login' : 'Signup',
                        enabled: enabled,
                      ),
                      // //Social Login Options
                      socialMediaLinks(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget socialMediaLinks() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Sign with Container
        // const SizedBox(
        //   height: 10.0,
        // ),
        // const Text(
        //   'OR',
        //   style: TextStyle(
        //     color: Constants.appPrimaryColor,
        //     fontSize: Constants.appHeading7Size,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // const SizedBox(
        //   height: 10.0,
        // ),
        // const Text(
        //   'Sign in with',
        //   style: TextStyle(
        //     color: Constants.appPrimaryColor,
        //     fontSize: Constants.appHeading7Size,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildGoogleSigninButton(),
            // const SizedBox(
            //   width: 5.0,
            // ),
            // // Google Sign in Elevated Button
            // buildFacebookSigninButton(),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          "Powered by AKS iQ",
          style: TextStyle(
            color: Constants.appGreyColor,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  Widget buildGoogleSigninButton() {
    return AppElevatedButton(
      enabled: enabled,
      onPressed: () async {
        final provider = Provider.of<Auth>(context, listen: false);
        setState(() {
          enabled = false;
        });
        try {
          await provider.signInWithGoogle();
        } on FirebaseAuthException catch (e) {
          String errorMessage = getExceptionMessage(e.code);
          getDialog(
            closeText: 'OK',
            content: Text(errorMessage),
            context: context,
            title: const Text("Login Failed"),
          );
        } on PlatformException catch (e) {
          String errorMessage = getExceptionMessage(e.code);
          await getDialog(
            closeText: 'OK',
            content: Text(errorMessage),
            context: context,
            title: const Text("Login Failed"),
          );
        } catch (e) {
          await getDialog(
            closeText: 'OK',
            content: const Text("Unknown Error"),
            context: context,
            title: const Text("Login Failed"),
          );
        } finally {
          setState(() {
            enabled = true;
          });
        }
      },
      image: Image.asset(
        "images/google_logo.png",
        height: 20,
        width: 20,
      ),
    );
  }

  Widget buildFacebookSigninButton() {
    return AppElevatedButton(
      enabled: enabled,
      onPressed: () async {
        final provider = Provider.of<Auth>(context, listen: false);
        setState(() {
          enabled = false;
        });
        try {
          await provider.signInWithFacebook();
        } on FirebaseAuthException catch (e) {
          String errorMessage = getExceptionMessage(e.code);
          getDialog(
            closeText: 'OK',
            content: Text(errorMessage),
            context: context,
            title: const Text("Login Failed"),
          );
        } on PlatformException catch (e) {
          String errorMessage = getExceptionMessage(e.code);
          await getDialog(
            closeText: 'OK',
            content: Text(errorMessage),
            context: context,
            title: const Text("Login Failed"),
          );
        } catch (e) {
          await getDialog(
            closeText: 'OK',
            content: const Text("Unknown Error"),
            context: context,
            title: const Text("Login Failed"),
          );
        } finally {
          setState(() {
            enabled = true;
          });
        }
      },
      image: Image.asset(
        "images/facebook_logo.png",
        height: 20,
        width: 20,
      ),
    );
  }

  Future loginNow() async {
    final provider = Provider.of<Auth>(context, listen: false);
    setState(() {
      enabled = false;
    });
    try {
      await provider.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
    } on FirebaseAuthException catch (e) {
      String errorMessage = getExceptionMessage(e.code);
      getDialog(
        closeText: 'OK',
        content: Text(errorMessage),
        context: context,
        title: const Text("Login Failed"),
      );
    } on PlatformException catch (e) {
      String errorMessage = getExceptionMessage(e.code);
      await getDialog(
        closeText: 'OK',
        content: Text(errorMessage),
        context: context,
        title: const Text("Login Failed"),
      );
    } catch (e) {
      await getDialog(
        closeText: 'OK',
        content: const Text("Unknown Error"),
        context: context,
        title: const Text("Login Failed"),
      );
    } finally {
      setState(() {
        enabled = true;
      });
    }
  }

  Future signUpNow() async {
    final provider = Provider.of<Auth>(context, listen: false);
    setState(() {
      enabled = false;
    });
    try {
      await provider.createUserWithEmailAndPassword(
          emailController.text, passwordController.text);
    } on FirebaseAuthException catch (e) {
      String errorMessage = getExceptionMessage(e.code);
      getDialog(
        closeText: 'OK',
        content: Text(errorMessage),
        context: context,
        title: const Text("Sign up Failed"),
      );
    } on PlatformException catch (e) {
      String errorMessage = getExceptionMessage(e.code);
      await getDialog(
        closeText: 'OK',
        content: Text(errorMessage),
        context: context,
        title: const Text("Sign up Failed"),
      );
    } catch (e) {
      await getDialog(
        closeText: 'OK',
        content: const Text("Unknown Error"),
        context: context,
        title: const Text("Sign up Failed"),
      );
    } finally {
      setState(() {
        enabled = true;
      });
    }
  }

  List<Widget> fixedWidgets() {
    return [
      const SizedBox(
        height: 20.0,
      ),
      Text(
        "Join the Barakah Circle of",
        style: Theme.of(context).textTheme.headline4,
      ),
      // Row
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Durood ",
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Container(
            width: 50.0,
            height: 50.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/login-mohr.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              " Salawat",
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
        ],
      ),
      Text(
        "to maximize blessings",
        style: Theme.of(context).textTheme.headline4,
      ),
      Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 200.0,
              height: 170.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("images/light-background.png"),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                width: 120.0,
                height: 120.0,
                decoration: const BoxDecoration(
                  color: Constants.appTransparent,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("images/login-lock.png"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  Future<void> resetPasswordPopUp(BuildContext contextMain) async {
    TextEditingController emailForReset = TextEditingController();
    bool buttonsEnabled = true;
    return showDialog(
      barrierDismissible: false,
      context: contextMain,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          title: const Text('Reset Password'),
          content: Wrap(
            alignment: WrapAlignment.center,
            children: [
              AppTextField(
                onChanged: (value) {},
                controller: emailForReset,
                focusNode: FocusNode(),
                hintText: "Email",
                formatter: const [],
                borderColor: Theme.of(context).primaryColorDark,
              ),
              AppElevatedButton(
                enabled: buttonsEnabled,
                onPressed: () {
                  Navigator.pop(context);
                },
                buttonText: "Cancel",
                buttonColor: Theme.of(context).errorColor,
              ),
              AppElevatedButton(
                enabled: buttonsEnabled,
                onPressed: () async {
                  if (emailForReset.text.isEmpty || emailForReset.text == "") {
                    final provider = Provider.of<Auth>(context, listen: false);
                    setState(() {
                      buttonsEnabled = false;
                    });
                    try {
                      bool result =
                          await provider.resetPassword(emailForReset.text);
                      if (result) {
                        Navigator.pop(context);
                        getDialog(
                          closeText: 'OK',
                          content: const Text(
                              "Instruction to reset password has been sent to the given email address."),
                          context: contextMain,
                          title: const Text("Email sent"),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      String errorMessage = getExceptionMessage(e.code);
                      getDialog(
                        closeText: 'OK',
                        content: Text(errorMessage),
                        context: context,
                        title: const Text("Resetting failed"),
                      );
                    } on PlatformException catch (e) {
                      String errorMessage = getExceptionMessage(e.code);
                      await getDialog(
                        closeText: 'OK',
                        content: Text(errorMessage),
                        context: context,
                        title: const Text("Resetting failed"),
                      );
                    } catch (e) {
                      await getDialog(
                        closeText: 'OK',
                        content: const Text("Unknown Error"),
                        context: context,
                        title: const Text("Resetting failed"),
                      );
                    } finally {
                      setState(() {
                        buttonsEnabled = true;
                      });
                    }
                  }
                  else{
                    final snackBar = SnackBar(
                      duration: const Duration(seconds: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 8.0,
                      ),
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.7),
                      content: Text(
                        'Please Enter Details',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar);
                  }
                },
                buttonText: "Reset",
              ),
            ],
          ),
        );
      },
    );
  }
}
