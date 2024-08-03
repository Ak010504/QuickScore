import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Details1 extends StatefulWidget {
  const Details1({Key? key}) : super(key: key);

  @override
  State<Details1> createState() => _Details1State();
}

class _Details1State extends State<Details1> {
  String homelogo = "";
  String awaylogo = "";
  String hometeam = "";
  String awayteam = "";
  String time = "";
  String stadium = "";
  String refree = "";
  String homescore = "";
  String awayscore = "";
  List<String> homeScorers = [];
  List<String> awayScorers = [];
  List<String> homelineup = [];
  List<String> awaylineup = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      String matchid = args as String? ?? "";
      fetchDetails(matchid);
    });
  }

  Future<void> fetchDetails(String matchid) async {
    try {
      final response = await http.get(Uri.parse(
          'https://apiv3.apifootball.com/?action=get_events&timezone=Asia/Kolkata&match_id=$matchid&league_id=302&APIkey=3870e010c2bed663559a9ccdafa432032e4c9b4e5961b55f7911190591e53149'));

      print('Response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (data != null && data.isNotEmpty) {
        setState(() {
          homelogo = data[0]['team_home_badge'] ?? 'default_logo_url';
          awaylogo = data[0]['team_away_badge'] ?? 'default_logo_url';
          hometeam = data[0]['match_hometeam_name'] ?? 'Unknown';
          awayteam = data[0]['match_awayteam_name'] ?? 'Unknown';
          stadium = data[0]['match_stadium'] ?? 'Unknown';
          refree = data[0]['match_referee'] ?? 'Unknown';
          time = data[0]['match_status'] ?? 'Unknown';
          homescore = data[0]['match_hometeam_score']?.toString() ?? '0';
          awayscore = data[0]['match_awayteam_score']?.toString() ?? '0';
          for (var line in data[0]['lineup']['home']['starting_lineups']) {
            homelineup.add(line['lineup_player']);
          }
          for (var line in data[0]['lineup']['away']['starting_lineups']) {
            awaylineup.add(line['lineup_player']);
          }
          if (data[0]['goalscorer'] != null) {
            final rawGoalScorers = data[0]['goalscorer'];
            for (var scorer in rawGoalScorers) {
              String time = scorer['time'];
              String homeScorer = scorer['home_scorer'];
              String awayScorer = scorer['away_scorer'];
              if (homeScorer.isNotEmpty) {
                homeScorers.add(homeScorer + " " + time);
              }
              if (awayScorer.isNotEmpty) {
                awayScorers.add(awayScorer + " " + time);
              }
            }
          }
          isLoading = false;
        });
      } else {
        print("No data received from the API");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "QUICK SCORE",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 107, 69, 221),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Left Column for Home Team
                      Column(
                        children: [
                          Image.network(
                            homelogo,
                            width: 80,
                            height: 80,
                          ),
                          SizedBox(height: 8),
                          Text(
                            hometeam,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          SizedBox(height: 20),
                          ...homeScorers.map((scorer) => Text(scorer)).toList(),
                        ],
                      ),
                      // Center Column for Scores
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                homescore,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                ),
                              ),
                              Text(
                                " - ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                ),
                              ),
                              Text(
                                awayscore,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          if (time != "Finished")
                            Text(
                              time,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                        ],
                      ),
                      Column(
                        children: [
                          Image.network(
                            awaylogo,
                            width: 80,
                            height: 80,
                          ),
                          SizedBox(height: 8),
                          Text(
                            awayteam,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          SizedBox(height: 20),
                          ...awayScorers.map((scorer) => Text(scorer)).toList(),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(
                    stadium,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Referee: $refree",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Home Lineup:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: homelineup
                                    .map((player) => Text(player))
                                    .toList(),
                              ),
                            ],
                          ),
                          SizedBox(width: 100),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Away Lineup:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: awaylineup
                                    .map((player) => Text(player))
                                    .toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
