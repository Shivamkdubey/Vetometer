import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:in_campus_diary/activity_feed/news_feed.dart';
import 'models/vetometer_background.dart';
import 'models/poll_options_data.dart';
// import 'package:in_campus_diary/services/dynamic_link_service.dart';
import 'add_poll.dart';
import 'view_poll.dart';
import 'package:provider/provider.dart';
import 'constants.dart';

class VetometerLivePolls extends StatefulWidget {
  static const id = "vetometer_live_polls";

  @override
  _VetometerLivePollsState createState() => _VetometerLivePollsState();
}

class _VetometerLivePollsState extends State<VetometerLivePolls> {
  var _password;
  var isSubmitted;

  @override
  void initState() {
    super.initState();
    // if (isOpenedThruLinkForVetometer) {
    //   isOpenedThruLinkForVetometer = false;
    //   getLinkedPollFromDb();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final String redirectedFromScreen =
        ModalRoute.of(context)!.settings.arguments as String;

    print(
        'Live Polls Build Entered: redirectedFromScreen: $redirectedFromScreen');

    return VetometerBackground(
      headerTitle: "Live Polls",
      blinkingAnimation: true,
      lightColor: Colors.red,
      child: Column(
        children: [
          SizedBox(height: 140.0),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('polls')
                  .orderBy('title')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData || snapshot.hasError) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.size == 0)
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 100),
                    child: Center(
                      child: Text(
                        "There are no new Polls yet!\nWhy don't you add one?",
                        style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            //Todo: Change this color:
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                return ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: snapshot.data!.docs.map((document) {
                    return Padding(
                      padding:
                          EdgeInsets.only(left: 32.0, right: 32.0, top: 28.0),
                      child: AnimatedContainer(
                        duration: Duration(seconds: 2),
                        child: InkWell(
                          onTap: () async {
                            print("Card pressed");
                            if (!document['accessibility'] ||
                                document['userId'] == currentUserId) {
                              await initializeSelectedPollOption(document);
                            } else {
                              passwordDialogBoxInput(context, document);
                            }
                          },
                          splashColor: Colors.red,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 24),
                            decoration: BoxDecoration(
                              color: Color(0xFF6FB1FC),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: kContainerElevation,
                            ),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              /*  Title of the Card */
                              children: [
                                Expanded(
                                  child: Text(
                                    document['title'],
                                    style: TextStyle(
                                      fontFamily: "nunito",
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),

                                /* Marking as Visited : marksVisitedToAlreadyVotedPoll() */
                                Consumer<PollOptionsData>(
                                    builder: (context, pollData, child) {
                                  return pollData.isVisited(document.id)
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue[900],
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.greenAccent,
                                            size: 20,
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6),
                                          child: Container(
                                            height: 6.0,
                                            width: 6.0,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                                boxShadow: kContainerElevation),
                                          ),
                                        );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                    //   ListTile(
                    //   title: Text(document['title']),
                    // );
                  }).toList(),
                );
              }),
          SizedBox(
            height: 30,
          ),
        ],
      ),

      /*  Add New Poll Button  */
      positionedWidget: customFloatingActionButton(),
    );
  }

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

  initializeSelectedPollOption(document) async {
    final providerFalse = Provider.of<PollOptionsData>(context, listen: false);
    var userResponse;

    if (listOfAttemptedPolls.containsKey(document.id))
      userResponse = listOfAttemptedPolls[document.id];
    else
      userResponse = null;
    print('Printing in initialization: $userResponse');

    if (userResponse == null) {
      providerFalse.firstVisit = document.get('pollOptions');
    } else {
      print(document.get('pollOptions'));
      print(userResponse);
      providerFalse.alreadyVisited(document.get('pollOptions'), userResponse);
    }

    providerFalse.selectedOptionsLimit = document.get('responseLimit');
    providerFalse.pollId = document.id;

    Navigator.pushNamed(context, VetometerViewPoll.id,
        arguments: {'first': document});
  }

  /// Opens a dialog box for private polls
  passwordDialogBoxInput(BuildContext context, document) {
    print("Enter Password Dialog");
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.only(left: 16, right: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(8, 32, 8, 8),
                  margin: EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
                  width: 320,
                  height: 300.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 45.0),
                      Text(
                        'This poll is password protected',
                        style: TextStyle(
                          fontFamily: "nunito",
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Please enter the password to view this poll',
                        style: TextStyle(
                          fontFamily: "nunito",
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 35.0),
                      Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: TextFormField(
                            onChanged: (value) {
                              _password = value;
                            },
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            textInputAction: TextInputAction.done,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.length > 5) {
                                return "Too long";
                              } else if (value == null || value.isEmpty) {
                                return "Enter password";
                              } else
                                return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Password',
                              hintStyle:
                                  TextStyle(fontSize: 14, letterSpacing: 2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  width: 1,
                                  style: BorderStyle.solid,
                                  color: Colors.blue,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
                                  top: 12.0,
                                  bottom: 12.0,
                                  left: 18.0,
                                  right: 18.0),
                            ),
                          )),
                      SizedBox(height: 15),
                      Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /*  Cancel Button  */
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Colors.red.withOpacity(0.8),
                                  ),
                                  child: MaterialButton(
                                    height: 0,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Center(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                                width: 20,
                              ),

                              /*  OK Button  */
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Colors.blue.withOpacity(0.8),
                                  ),
                                  child: MaterialButton(
                                    height: 0,
                                    onPressed: () async {
                                      if (_password == document['password']) {
                                        Navigator.pop(context);
                                        await initializeSelectedPollOption(
                                            document);
                                      } else {
                                        Fluttertoast.cancel();
                                        Fluttertoast.showToast(
                                            msg: 'Wrong Password',
                                            backgroundColor: Colors.black87,
                                            textColor: Colors.redAccent,
                                            gravity: ToastGravity.CENTER,
                                            fontSize: 18);
                                      }
                                    },
                                    child: Center(
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'images/password_lock_blue.png',
                    height: 90.0,
                    width: 90.0,
                  ),
                ),
              ],
            ),
          );
        });
  }

  ///Fetches the poll document from firestore corresponding to the id present in the link
  // getLinkedPollFromDb() async {
  //   var document =
  //       await firestore.collection('polls').doc(pollIdRetrievedFromLink).get();
  //   print('\n\nRetrieved Poll from Db | $pollIdRetrievedFromLink \n $document');
  //   initializeSelectedPollOption(document);
  // }

  /*  Navigates to AddPoll Screen  */
  Widget customFloatingActionButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(right: 16.0, bottom: 32.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: kContainerElevation,
            ),
            child: Image.asset(
              'images/button.png',
              height: 60.0,
              width: 60.0,
            ),
          ),
        ),
        onTap: () {
          //Todo: use popUntil instead of pushNamed
          Navigator.pushNamed(context, VetometerAddPoll.id);
        },
      ),
    );
  }
}
