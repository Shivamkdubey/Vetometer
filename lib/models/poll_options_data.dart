import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

HashMap<String, List> listOfAttemptedPolls = HashMap();

class PollOptionsData extends ChangeNotifier {
  List<String> pollOptions = [];

  int _countOfSelectedOptions = 0;
  int _selectedLimit = 1;

  List<bool> selectedOptions = [];
  bool isSelectedOptionChange = false;

  bool isAlreadyVisited = false;
  var _firestore = FirebaseFirestore.instance;

  var _pollId;
  String get pollId => _pollId;

  set pollId(pollId) {
    _pollId = pollId;
  }

  /**  Used in Live Polls to mark as visited */
  void notifyPollAttempted() {
    notifyListeners();
  }

  bool isVisited(documentId) {
    if (listOfAttemptedPolls.containsKey(documentId))
      return true;
    else
      return false;
  }

  void viewPollIntializeData() {
    pollOptions = [];
    _countOfSelectedOptions = 0;
    _selectedLimit = 1;
    selectedOptions = [];
    isSelectedOptionChange = false;
  }

  List<bool> get selectedOptionArray => selectedOptions;
  int get countOfSelectedOptions => _countOfSelectedOptions;

  set firstVisit(polls) {
    isAlreadyVisited = false;
    viewPollIntializeData();
    for (var poll in polls) {
      selectedOptions.add(false);
      pollOptions.add(poll);
    }
  }

  void alreadyVisited(List polls, List userResponse) {
    isAlreadyVisited = true;
    viewPollIntializeData();
    print('Printing in already visited: $userResponse');
    for (int i = 0; i < polls.length; i++) {
      pollOptions.add(polls[i]);
      selectedOptions.add(userResponse[i]);
      if (selectedOptions[i]) _countOfSelectedOptions++;
    }
    print('Count of Selected options $_countOfSelectedOptions');
  }

  set selectedOptionsLimit(int limit) {
    _selectedLimit = limit;
  }

  void updatePollOption(int index) {
    print('Updation Started $index');

    if (!selectedOptions[index]) {
      if (_countOfSelectedOptions < _selectedLimit) {
        _countOfSelectedOptions++;
        selectedOptions[index] = true;
        print(selectedOptions);
        isSelectedOptionChange = true;
      } else {
        isSelectedOptionChange = false;
        HapticFeedback.vibrate();
      }
    } else {
      _countOfSelectedOptions--;
      selectedOptions[index] = false;
      isSelectedOptionChange = true;
    }
    notifyListeners();
  }

  updatePollCounter() async {
    try {
      var _random = Random();
      for (int i = 0; i < selectedOptions.length; i++) {
        if (selectedOptions[i]) {
          var index = _random.nextInt(5).toString();
          await _firestore
              .collection(_pollId)
              .doc(index)
              .update({"option $i": FieldValue.increment(1)});
        }
      }
    } catch (e) {
      for (int i = 0; i < 5; i++) {
        await _firestore
            .collection(_pollId)
            .doc(i.toString())
            .set({'option 0': 0});
        print('$_pollId created');
      }
      updatePollCounter();
    }
  }
}
