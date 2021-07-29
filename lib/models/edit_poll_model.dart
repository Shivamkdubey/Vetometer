import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'poll_model.dart';

PollModel pollModel = PollModel();

class EditPollModel extends ChangeNotifier {
  List optionsList = [];
  int _pollOptionsCount = 0;
  int responseLimit = 1;
  bool _private = false;
  //Todo: Add expiry date field and UI
  // Date expiryDate;

  bool get private => _private;
  set private(value) {
    _private = value;
  }

  void changeprivate() {
    print("Before private: $_private");
    _private = !_private;
    print('private: $_private');
    notifyListeners();
  }

  int get pollOptionsCountValue => _pollOptionsCount;

  int get listSize => optionsList.length;

  initializeEditPoll() {
    optionsList.clear();
    private = pollModel.accessibility;
    responseLimit = pollModel.responseLimit;
    _pollOptionsCount = pollModel.pollOptions.length;
    for (int i = 0; i < _pollOptionsCount; i++) optionsList.add(editItem(i));
    print("Inside Editable function: $_pollOptionsCount");
    pollModel.pollOptions.clear();
  }

  currentPollOption(index) => optionsList[index];

  editItem(index) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 16),
      child: Row(
        children: [
          Expanded(
            child: PollTextFormField(
              verticalPadding: 8,
              readOnly: true,
              initialValue: pollModel.pollOptions[index],
              onChanged: (value) {},
              onSaved: (value) {
                pollModel.addPoll(value);
              },
              validator: (String value) {
                if (value == null || value.isEmpty) return 'Required';
                return null;
              },
              horizontalPadding: 8,
              hint: '',
            ),
          ),

          /*  Delete Icon * commented out for now   */
          // Container(
          //   decoration: BoxDecoration(
          //       color: Colors.redAccent, boxShadow: kContainerElevation),
          //   child: IconButton(
          //       padding: EdgeInsets.all(0),
          //       color: Colors.white,
          //       iconSize: 35,
          //       icon: Icon(Icons.delete_forever_outlined),
          //       onPressed: () {
          //         deletePollOption(index, pollModel);
          //       }),
          // ),
        ],
      ),
    );
  }
}

var kContainerElevation = [
  BoxShadow(color: Colors.black38, offset: Offset(10, 10), blurRadius: 10)
];

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

const int kCharacterCountLimit = 120;

/*  To add new poll items, change response limit  *  Might need in future  */
// addNewPollOption(index) {
//   optionsList.add(item(index));
//   _pollOptionsCount++;
//   notifyListeners();
// }

// deletePollOption(index, pollModel) {
//   if (_pollOptionsCount <= 2) {
//     Fluttertoast.cancel();
//     Fluttertoast.showToast(
//       msg: 'You must have atleast 2 options',
//       backgroundColor: Colors.black87,
//       timeInSecForIosWeb: 2,
//       fontSize: 18,
//       textColor: Colors.red,
//     );
//     HapticFeedback.vibrate();
//     print("Print: Cannot Delete");
//   } else if (optionsList[index] != null) {
//     optionsList[index] = null;
//     print('Removing $index');
//     pollModel.pollOptions.remove(index);
//     print(pollModel.pollOptions);
//     _pollOptionsCount--;
//
//     if (responseLimit >= _pollOptionsCount)
//       responseLimit = _pollOptionsCount - 1;
//     pollModel.responseLimit = responseLimit;
//     notifyListeners();
//   }
// }

// item(index) {
//   return Padding(
//     padding: const EdgeInsets.only(left: 8.0, right: 16),
//     child: Row(
//       children: [
//         Expanded(
//           child: PollTextFormField(
//             // initialValue: document or pollmodel??,
//             verticalPadding: 8,
//             hint: null,
//             onChanged: (value) {},
//             onSaved: (value) {
//               pollModel.addPoll(value);
//             },
//             prefixIcon: Icon(
//               Icons.arrow_right,
//               color: Colors.greenAccent,
//               size: 30,
//             ),
//             validator: (String value) {
//               if (value == null || value.isEmpty) return 'Required';
//               return null;
//             },
//             horizontalPadding: 8,
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//               color: Colors.redAccent, boxShadow: kContainerElevation),
//           child: IconButton(
//               padding: EdgeInsets.all(0),
//               color: Colors.white,
//               iconSize: 35,
//               icon: Icon(Icons.delete_forever_outlined),
//               onPressed: () {
//                 deletePollOption(index, pollModel);
//               }),
//         ),
//       ],
//     ),
//   );
// }
