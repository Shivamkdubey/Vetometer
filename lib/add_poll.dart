import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/add_poll_model.dart';
import 'models/vetometer_background.dart';
import 'package:provider/provider.dart';
import 'rounded_button.dart';
import 'models/poll_model.dart';
import 'package:validators/validators.dart';

class VetometerAddPoll extends StatefulWidget {
  static const id = "vetometer_add_poll";

  @override
  _VetometerAddPollState createState() => _VetometerAddPollState();
}

PollModel _pollModel = PollModel();

class _VetometerAddPollState extends State<VetometerAddPoll> {
  final firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    try {
      print('Initializing AddPoll:');

      addInitialPoll();
    } on Exception catch (e) {
      print('Print: Error Occured: $e');
    }
  }

  void addInitialPoll() {
    var providerFalse = Provider.of<AddPollModel>(context, listen: false);

    _pollModel.clear();
    providerFalse.instantiate();
    providerFalse.addNewPollOption(0, _pollModel);
    providerFalse.addNewPollOption(1, _pollModel);

    print(
        '${providerFalse.responseLimit}  ${providerFalse.privacy} in addInitialPoll() in add_poll.dart');
  }

  @override
  Widget build(BuildContext context) {
    print('Add Poll Entered');
    return VetometerBackground(
      lightColor: Colors.yellowAccent,
      darkColor: Colors.yellow[700],
      glowColor: Colors.yellowAccent,
      blinkingAnimation: true,
      headerTitle: "Add Poll",
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 200.0),

            /* Title Field*/
            Padding(
              padding: EdgeInsets.only(left: 32.0, right: 32.0),
              child: Text(
                'Title of the Poll',
                style: kTextStyle,
              ),
            ),
            PollTextFormField(
              hint: "Enter a Title here...",
              onSaved: (value) {
                _pollModel.title = value.trim();
              },
              autoFocus: true,
              radius: 10,
              onChanged: (value) {},
              validator: (String value) {
                if (value.isEmpty)
                  return "Required";
                else if (isNumeric(value))
                  return 'Invalid Title';
                else if (value.toLowerCase().trim() == 'mass bunk')
                  return 'Mention Stream';
                return null;
              },
              color: Color(0xFF0077FF),
              fontWeight: FontWeight.w900,
              verticalPadding: 8,
              contentPadding: false,
            ),

            /* Description Field*/
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Poll Description',
                style: kTextStyle,
              ),
            ),
            PollTextFormField(
              hint:
                  'Enter a description about your poll. E.g.:\nWhat is its purpose?\nWhom it should/may concern?',
              onSaved: (value) {
                _pollModel.pollDescription = value.trim();
              },
              radius: 10.0,
              contentPadding: false,
              verticalPadding: 8,
              textAlign: false,
              automaticNext: false,
              minLines: 4,
              maxLines: 6,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return "Required";
                else if (isNumeric(value)) return 'Invalid Description';
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, top: 32),
              child: Text(
                'Poll Options',
                style: kTextStyle.copyWith(fontStyle: FontStyle.normal),
              ),
            ),

            /* Polling Fields */
            ListView.builder(
              itemCount: Provider.of<AddPollModel>(context).listSize,
              itemBuilder: (context, index) {
                var currentPollOption =
                    Provider.of<AddPollModel>(context, listen: false)
                        .currentPollOption(index);
                if (currentPollOption != null)
                  return currentPollOption;
                else
                  return SizedBox(height: 0, width: 0);
              },
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),

            /* Add New Poll Option Button */
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: GestureDetector(
                      onTap: () {
                        var pollOptionsCount =
                            Provider.of<AddPollModel>(context, listen: false)
                                .pollOptionsCountValue;
                        var listSize =
                            Provider.of<AddPollModel>(context, listen: false)
                                .listSize;
                        if (pollOptionsCount < 20)
                          Provider.of<AddPollModel>(context, listen: false)
                              .addNewPollOption(listSize, _pollModel);
                        else
                          showSnackBar("Cannot create more Options!");
                        print('Print: New Poll Added');
                      },
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.blue, boxShadow: kContainerElevation),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: FloatingActionButton(
                        onPressed: () {
                          var pollOptionsCount =
                              Provider.of<AddPollModel>(context, listen: false)
                                  .pollOptionsCountValue;
                          var listSize =
                              Provider.of<AddPollModel>(context, listen: false)
                                  .listSize;
                          if (pollOptionsCount < 20)
                            Provider.of<AddPollModel>(context, listen: false)
                                .addNewPollOption(listSize, _pollModel);
                          else
                            showSnackBar("Cannot create more Options!");
                          print('Print: New Poll Added');
                        },
                        elevation: 0,
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            /* Accessibility Button */
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 20, top: 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Text(
                          'Accessibility',
                          style: kTextStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 4),
                        child: Text(
                          Provider.of<AddPollModel>(context).privacy
                              ? 'This is only accessible with a PASSWORD'
                              : 'This is PUBLICLY accessible',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    onChanged: (value) {
                      Provider.of<AddPollModel>(context, listen: false)
                          .changePrivacy();
                      if (!value) _pollModel.password = 'null';
                      _pollModel.accessibility = value;
                      print(_pollModel.accessibility);
                    },
                    value: Provider.of<AddPollModel>(context).privacy,
                    activeColor: Colors.blue,
                    activeTrackColor: Colors.lightGreenAccent.shade700,
                    inactiveThumbColor: Colors.blue,
                    inactiveTrackColor: Colors.greenAccent.shade100,
                  )
                ],
              ),
            ),

            /* Auto-Password Field */
            Visibility(
              visible: Provider.of<AddPollModel>(context).privacy,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: PollTextFormField(
                  hint: 'Enter Password',
                  onSaved: (value) {
                    _pollModel.password = value.toString();
                  },
                  radius: 10,
                  maxLength: 5,
                  readOnly: true,
                  initialValue: generatePassword(),
                  letterSpacing: 4.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
            SizedBox(height: 20),

            /*  Response Limit Setter   */
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maximum Responses Selectable',
                    style: kTextStyle,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            boxShadow: kContainerElevation,
                          ),
                          child: Center(
                            child: Text(
                              Provider.of<AddPollModel>(context)
                                  .responseLimit
                                  .toString(),
                              textAlign: TextAlign.center,
                              style: kTextStyle.copyWith(
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          boxShadow: kContainerElevation,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            print('Print: Pressed');
                            var responseLimit = Provider.of<AddPollModel>(
                                    context,
                                    listen: false)
                                .responseLimit;
                            var pollOptionsCount = Provider.of<AddPollModel>(
                                    context,
                                    listen: false)
                                .pollOptionsCountValue;
                            if (responseLimit < pollOptionsCount - 1)
                              Provider.of<AddPollModel>(context, listen: false)
                                  .responseLimitIncrement(_pollModel);
                            else
                              showSnackBar(
                                  'You have only $pollOptionsCount options!');
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          boxShadow: kContainerElevation,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            print('Print: Pressed');
                            var responseLimit = Provider.of<AddPollModel>(
                                    context,
                                    listen: false)
                                .responseLimit;
                            if (responseLimit > 1)
                              Provider.of<AddPollModel>(context, listen: false)
                                  .responseLimitDecrement(_pollModel);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /* Create Poll Button */
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  //Create Poll Button
                  RoundedButton(
                    title: 'Create Poll',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print(_pollModel.title);
                        print(_pollModel.pollDescription);
                        print(_pollModel.pollOptions.toString());
                        print(_pollModel.accessibility);
                        print(_pollModel.password);
                        print(_pollModel.responseLimit);
                        _pollModel.userId =
                            FirebaseAuth.instance.currentUser!.uid;
                        await firestore
                            .collection('polls')
                            .doc()
                            .set(_pollModel.toMap());
                        Navigator.pop(context);
                        dispose();
                      } else
                        showSnackBar('Invalid Fields Found!');
                    },
                    color: Colors.blue,
                  ),
                  SizedBox(height: 16),
                ],
              ),
            )
          ],
        ),
      ),
      positionedWidget: SizedBox(height: 0, width: 0),
    );
  }

  String generatePassword() {
    var _random = Random();
    var _password = _random.nextInt(90000) + 10000;
    return _password.toString();
  }

  final kTextStyle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    color: Colors.white,
  );

  showSnackBar(String _snackText) {
    final snackBar = SnackBar(
      content: Text(
        _snackText,
        style: TextStyle(
          fontSize: 22,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red.shade700,
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

const int kCharacterCountLimit = 120;

class PollTextFormField extends StatelessWidget {
  final String hint;
  final keyboardType;
  final letterSpacing;
  final onSaved;
  final index;
  final textCapitalization;
  final int maxLength;
  final int maxLines;
  final int minLines;
  final onChanged;
  final deniedRegExp;
  final allowedRegExp;
  final validator;
  final autoValidateMode;
  final bool autoFocus;
  final Color color;
  final FontWeight fontWeight;
  final double verticalPadding;
  final double horizontalPadding;
  final bool contentPadding;
  final double radius;
  final prefixIcon;
  final suffixIcon;
  final bool textAlign;
  final bool readOnly;
  final bool automaticNext;
  final width;
  final initialValue;

  PollTextFormField({
    required this.hint,
    required this.onSaved,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.minLines = 1,
    this.width = double.infinity,
    this.prefixIcon,
    this.readOnly = false,
    this.initialValue,
    this.automaticNext = true,
    this.contentPadding = true,
    this.index,
    this.verticalPadding = 0.0,
    this.horizontalPadding = 16.0,
    this.letterSpacing,
    this.maxLength = kCharacterCountLimit,
    this.maxLines = 3,
    this.textCapitalization = TextCapitalization.sentences,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.validator,
    this.deniedRegExp = "[, ./!']",
    this.allowedRegExp = false,
    this.autoFocus = true,
    this.radius = 0.0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.textAlign = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      child: Container(
        width: width,
        decoration: BoxDecoration(boxShadow: kContainerElevation),
        child: TextFormField(
          autocorrect: false,
          textCapitalization: textCapitalization,
          enabled: true,
          maxLength: maxLength,
          minLines: minLines,
          maxLines: maxLines,
          initialValue: initialValue,
          readOnly: readOnly,
          textAlign: textAlign ? TextAlign.center : TextAlign.start,
          cursorHeight: 20,
          style: TextStyle(
              fontSize: 18,
              color: color,
              fontWeight: fontWeight,
              letterSpacing: letterSpacing),
          decoration: InputDecoration(
            // focusColor: Colors.red,
            hintMaxLines: 5,
            counterText: '',
            contentPadding: contentPadding ? const EdgeInsets.all(0) : null,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            hintText: hint,
            hintStyle:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.normal),
            enabled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 0),
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
          ),
          autofocus: autoFocus,
          keyboardType: TextInputType.multiline,
          textInputAction:
              automaticNext ? TextInputAction.next : TextInputAction.newline,
          inputFormatters: [
            // allowedRegExp
            //     : FilteringTextInputFormatter.deny(RegExp(deniedRegExp)),
          ],
          onFieldSubmitted: onChanged,
          onSaved: onSaved,
          autovalidateMode: autoValidateMode,
          validator: validator,
        ),
      ),
    );
  }
}
