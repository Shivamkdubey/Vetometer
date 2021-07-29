import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'models/vetometer_background.dart';
import 'rounded_button.dart';
import 'live_polls.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'constants.dart';

class VetometerPollStats extends StatelessWidget {
  static const id = "vetometer_poll_stats";

  @override
  Widget build(BuildContext context) {
    final Map receivedArguments =
        ModalRoute.of(context)!.settings.arguments as Map;
    final document = receivedArguments['first'];
    final List<int> countOfEveryPoll = receivedArguments['second'];
    print('Poll Stats Entered: $document');
    print('Result of the Poll: $countOfEveryPoll');

    return VetometerBackground(
      lightColor: Colors.purpleAccent,
      darkColor: Colors.purpleAccent[900],
      glowColor: Colors.purpleAccent[100],
      blinkingAnimation: true,
      headerTitle: "Poll Stats",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: Column(
          children: [
            SizedBox(height: 150.0),

            /* Poll Title */
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(5),
                boxShadow: kContainerElevation,
              ),
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Flexible(
                    child: Text(
                      document['title'],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Nunito",
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              width: double.infinity,
            ),
            SizedBox(height: 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Votes',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Nunito",
                    fontSize: 18,
                  ),
                ),
                Text(
                  countOfEveryPoll.last.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 75,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: document['pollOptions'].length,
              itemBuilder: (context, index) {
                return ResultCard(document['pollOptions'][index],
                    countOfEveryPoll[index], countOfEveryPoll.last);
              },
            ),
            SizedBox(height: 60),
            RoundedButton(
              title: 'SHARE',
              color: Colors.lightBlueAccent[400],
              onPressed: () {},
            ),
            SizedBox(height: 20),
            RoundedButton(
              title: 'HOME',
              color: Colors.red,
              onPressed: () {
                //Todo: Change home destination to NewsFeed later on.
                Navigator.pushNamed(context, VetometerLivePolls.id);
              },
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
      positionedWidget: SizedBox(height: 0, width: 0),
    );
  }
}

Color kColorOfContainer = Colors.white;

class ResultCard extends StatelessWidget {
  final option;
  final int countOfVotes;
  final int totalVotes;

  @override
  ResultCard(this.option, this.countOfVotes, this.totalVotes);

  Widget build(BuildContext context) {
    String result;
    try {
      result = (countOfVotes / totalVotes * 100).round().toString();
    } catch (e) {
      result = "0";
      print('Exception caught: $e');
    }
    return Stack(children: [
      Container(
        color: Color(0xFF38597E),
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ClipPath(
          clipper: PollOptionsDesign(),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            width: double.infinity,
            decoration: BoxDecoration(
              color: kColorOfContainer,
            ),
            child: Container(
              margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 24, right: 8),
                    child: Flexible(
                      child: Text(
                        option,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  /* TODO: Animation on Slider */
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "${countOfVotes.toString()} votes",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.50),
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 50,
        right: 8,
        child: Text(
          '$result %',
          style: TextStyle(
              color: Colors.yellowAccent,
              fontWeight: FontWeight.w900,
              fontSize: 22),
        ),
      ),
      // SizedBox(height: 10),
      /* Percent Indicator Slider*/
      Positioned(
        bottom: 40,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 70,
            lineHeight: 5.0,
            percent: (countOfVotes / totalVotes),
            progressColor: Colors.blue,
          ),
        ),
      )
    ]);
  }
}

class PollOptionsDesign extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(size.width * 0.75, 0);
    path.quadraticBezierTo(
        size.width * 0.85, size.height * 0.5, size.width * 0.75, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
