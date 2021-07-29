import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'poll_model.dart';
import 'package:vetometer/add_poll.dart';

class AddPollModel extends ChangeNotifier {
  List optionsList = [];
  int _pollOptionsCount = 0;
  int responseLimit = 1;
  bool _privacy = false;

  //Todo: Add expiry date field and UI
  // Date expiryDate;

  bool get privacy => _privacy;
  set privacy(value) {
    _privacy = value;
  }

  instantiate() {
    optionsList.clear();
    _pollOptionsCount = 0;
    responseLimit = 1;
    _privacy = false;
    print(
        '$optionsList   $responseLimit   $privacy in instantiate() in add poll model');
  }

  void changePrivacy() {
    _privacy = !_privacy;
    notifyListeners();
  }

  int get pollOptionsCountValue => _pollOptionsCount;

  int get listSize => optionsList.length;

  void responseLimitIncrement(_pollModel) {
    responseLimit++;
    _pollModel.responseLimit = responseLimit;
    print(_pollModel.responseLimit);
    notifyListeners();
  }

  void responseLimitDecrement(_pollModel) {
    responseLimit--;
    _pollModel.responseLimit = responseLimit;
    print(_pollModel.responseLimit);
    notifyListeners();
  }

  currentPollOption(index) => optionsList[index];

  addNewPollOption(index, PollModel _pollModel) {
    optionsList.add(item(index, _pollModel));
    _pollOptionsCount++;
    if (_pollOptionsCount > 2) notifyListeners();
  }

  deletePollOption(index, _pollModel) {
    if (_pollOptionsCount <= 2) {
      showToast('You must have Atleast 2 Options', Colors.yellow);
      HapticFeedback.vibrate();

      print("Print: Cannot Delete in deletePollOption() in add poll model");
    } else if (optionsList[index] != null) {
      optionsList[index] = null;
      _pollOptionsCount--;

      if (responseLimit >= _pollOptionsCount)
        responseLimit = _pollOptionsCount - 1;

      _pollModel.responseLimit = responseLimit;
      notifyListeners();
    }
  }

  showToast(message, [color = Colors.white]) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black87,
      timeInSecForIosWeb: 2,
      fontSize: 18,
      gravity: ToastGravity.CENTER,
      textColor: color,
    );
  }

  item(index, PollModel _pollModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 16),
      child: Row(
        children: [
          Expanded(
            //Todo: Change the name of PollTextFormField
            child: PollTextFormField(
              //Todo: Change initial value or make a separate item for first n items
              // initialValue: document or pollmodel??,
              verticalPadding: 8,
              onChanged: (value) {},
              onSaved: (value) {
                _pollModel.addPoll(value);
              },
              prefixIcon: Icon(
                Icons.arrow_right,
                color: Colors.greenAccent,
                size: 30,
              ),
              validator: (String value) {
                if (value == null || value.isEmpty) return 'Required';
                return null;
              },
              horizontalPadding: 8, hint: '',
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.redAccent, boxShadow: kContainerElevation),
            child: IconButton(
                padding: EdgeInsets.all(0),
                color: Colors.white,
                iconSize: 35,
                icon: Icon(Icons.delete_forever_outlined),
                onPressed: () {
                  deletePollOption(index, _pollModel);
                }),
          ),
        ],
      ),
    );
  }
}

var kContainerElevation = [
  BoxShadow(color: Colors.black38, offset: Offset(10, 10), blurRadius: 10)
];
