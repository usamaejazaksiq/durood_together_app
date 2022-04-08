import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:durood_together_app/Services/dialogs.dart';
import 'package:durood_together_app/Widgets/app_elevated_button.dart';
import 'package:durood_together_app/Widgets/app_text_field.dart';
import 'package:durood_together_app/Widgets/my_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class SendFeedBack extends StatefulWidget {
  const SendFeedBack({Key? key}) : super(key: key);

  @override
  _SendFeedBackState createState() => _SendFeedBackState();
}

class _SendFeedBackState extends State<SendFeedBack> {
  late String emailTo;
  String? emailBody;
  late String emailSubject;
  TextEditingController feedbackController = TextEditingController();
  FocusNode feedbackNode = FocusNode();

  @override
  void initState() {
    super.initState();
    emailSubject = 'Durood Together Feedback/Suggestion';
    emailTo = 'islahenafsapp@gmail.com';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          String userEmail = FirebaseAuth.instance.currentUser!.email! + "\n";
          emailBody =  userEmail + feedbackController.text;
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        });
      },
      child: MyScaffold(
        head1: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: buildTopRow(context),
        ),
        body: Expanded(
          child: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildNameField(),
            buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget buildNameField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppTextField(
        maxLines: 4,
        controller: feedbackController,
        focusNode: feedbackNode,
        hintText: "Enter a feedback or a suggestion",
        formatter: const [],
        onSubmitted: (value) {
          setState(() {
            String userEmail = FirebaseAuth.instance.currentUser!.email! + "\n";
            emailBody = userEmail + feedbackController.text;
          });
        },
      ),
    );
  }

  Widget buildSendButton(){
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AppElevatedButton(
          buttonText: "Send",
          icon: Icons.send,
          onPressed: () async {
            if(feedbackController.text == '' || feedbackController.text.isEmpty){
              final snackBar = SnackBar(
                duration: const Duration(seconds: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                backgroundColor:
                Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                content: Text(
                  'Please Enter Feedback/Suggestion',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }else {
              getWaitingDialog(context: context);
              try {
                String userEmail = FirebaseAuth.instance.currentUser!.email! + "\n";
                emailBody = userEmail + feedbackController.text;
                final Email email = Email(
                  body: emailBody!,
                  subject: emailSubject,
                  recipients: [emailTo],
                  isHTML: false,
                );
                await FlutterEmailSender.send(email);
                feedbackController.text = '';
              } finally {
                Navigator.pop(context);
              }
            }
          },
        ),
      ),
    );
  }

  Widget buildTopRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Send Feedback",
              style: TextStyle(
                  color: Constants.appHighlightColor,
                  fontSize: Constants.appHeading5Size),
            ),
          ),
          InkWell(
            onTap: () {
              getDialog(
                title: Text(
                  'Go back?',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                content: Text(
                  'Any unsaved changes will be discarded',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                context: context,
                closeText: 'No',
                okText: 'Yes',
                okOnPressed: () {
                  Navigator.pop(context); //close Dialog
                  Navigator.pop(context); //close Profile Page
                },
              );
            },
            splashColor: Constants.appHighlightColor,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
