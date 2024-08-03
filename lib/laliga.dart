import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class Laliga extends StatefulWidget {
  const Laliga({super.key});

  @override
  State<Laliga> createState() => _LaligaState();
}

enum ViewType { fixtures, table, result }

class _LaligaState extends State<Laliga> {
  _LaligaState() {
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(today);
    _currentView = ViewType.fixtures;
    fetch_fixtures(formattedDate);
  }
  ViewType _currentView = ViewType.fixtures;
  List<String> homeTeams = []; // List to hold home team names
  List<String> awayTeams = []; // List to hold home team names
  List<String> timeList = []; // List to hold home team names
  List<String> homelogoList = []; // List to hold home team names
  List<String> awaylogoList = []; // List to hold home team names
  List<String> pos = []; // List to hold home team names
  List<String> teamname = []; // List to hold home team names
  List<String> played = [];
  List<String> win = [];
  List<String> loss = [];
  List<String> draw = [];
  List<String> points = [];
  List<String> hometeamr = [];
  List<String> awayteamr = [];
  List<String> awayteam_score = [];
  List<String> hometeam_score = [];
  List<String> hometeam_logo = [];
  List<String> awayteam_logo = [];
  List<String> matchid = [];
  List<String> matchidr = [];
  List<String> dates = [];

  void fetch_fixtures(String formatteddate) async {
    try {
      final DateTime initialDate =
          DateFormat('yyyy-MM-dd').parse(formatteddate);
      DateTime dateAfterTenDays = initialDate.add(Duration(days: 10));
      String afterdays = DateFormat('yyyy-MM-dd').format(dateAfterTenDays);
      var response = await get(Uri.parse(
          'https://apiv3.apifootball.com/?action=get_events&from=$formatteddate&to=$afterdays&timezone=Asia/Kolkata&league_id=302&APIkey=3870e010c2bed663559a9ccdafa432032e4c9b4e5961b55f7911190591e53149'));
      // Use the response here, for example:
      List data = jsonDecode(response.body);
      List<String> homeTeams1 = []; // List to hold home team names
      List<String> awayTeams1 = []; // List to hold home team names
      List<String> timeList1 = [];
      List<String> homelogoList1 = [];
      List<String> awaylogoList1 = [];
      List<String> matchid1 = [];
      List<String> date1 = [];

      for (var element in data) {
        if (element['match_status'] != 'Finished') {
          String home = element['match_hometeam_name'];
          String away = element['match_awayteam_name'];
          String time = element['match_time'];
          String date = element['match_date'];
          DateTime parsedDate = DateTime.parse(date);
          date = DateFormat('dd/MM/yyyy').format(parsedDate);
          homeTeams1.add(home);
          awayTeams1.add(away);
          timeList1.add(time);
          homelogoList1.add(element['team_home_badge']);
          awaylogoList1.add(element['team_away_badge']);
          matchid1.add(element['match_id']);
          date1.add(date);
        }
        // List to hold home team names
      }
      print(homelogoList1.length);
      for (String s in homelogoList1) {
        if (s == "") {
          int ind = homelogoList1.indexOf(s);
          homelogoList1[ind] =
              'https://p7.hiclipart.com/preview/144/913/211/no-symbol-sign-clip-art-svg.jpg';
        }
      }
      for (String s in awaylogoList1) {
        if (s == "") {
          int ind = awaylogoList1.indexOf(s);
          awaylogoList1[ind] =
              'https://p7.hiclipart.com/preview/144/913/211/no-symbol-sign-clip-art-svg.jpg';
        }
      }
      setState(() {
        _currentView = ViewType.fixtures;
        homeTeams = homeTeams1; // Update the state with the fetched data
        awayTeams = awayTeams1;
        timeList = timeList1;
        homelogoList = homelogoList1;
        awaylogoList = awaylogoList1;
        matchid = matchid1;
        dates = date1;
      });
    } catch (e) {
      print("Error fetching data: $e");
      // Handle the error or show a message to the user
    }
  }

  void fetch_table() async {
    try {
      final response = await get(
        Uri.parse('http://api.football-data.org/v4/competitions/PD/standings'),
        headers: {
          'X-Auth-Token': '8e9bd67847e24ec5a3ff862a92ac7ca6',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        List<dynamic> standings = data['standings'][0]['table'];
        List<String> pos1 = []; // List to hold positions
        List<String> teamname1 = []; // List to hold team names
        List<String> played1 = [];
        List<String> win1 = [];
        List<String> loss1 = [];
        List<String> draw1 = [];
        List<String> points1 = [];

        standings.forEach((standing) {
          pos1.add(standing['position'].toString());
          teamname1.add(standing['team']['name']);
          played1.add(standing['playedGames'].toString());
          win1.add(standing['won'].toString());
          loss1.add(standing['lost'].toString());
          draw1.add(standing['draw'].toString());
          points1.add(standing['points'].toString());
        });

        setState(() {
          _currentView = ViewType.table;
          pos = pos1;
          teamname = teamname1;
          played = played1;
          win = win1;
          loss = loss1;
          draw = draw1;
          points = points1;
        });
      } else {
        throw Exception('Failed to load standings');
      }
    } catch (e) {
      print("Error fetching data: $e");
      // Handle the error or show a message to the user
    }
  }

  void fetch_result(String formatteddate) async {
    final DateTime initialDate = DateFormat('yyyy-MM-dd').parse(formatteddate);
    DateTime dateAfterTenDays = initialDate.subtract(Duration(days: 10));
    String afterdays = DateFormat('yyyy-MM-dd').format(dateAfterTenDays);
    try {
      var response = await get(Uri.parse(
          'https://apiv3.apifootball.com/?action=get_events&from=$afterdays&to=$formatteddate&timezone=Asia/Kolkata&league_id=302&APIkey=3870e010c2bed663559a9ccdafa432032e4c9b4e5961b55f7911190591e53149'));
      List data = jsonDecode(response.body);
      List<String> hometeamr1 = [];
      List<String> awayteamr1 = [];
      List<String> awayteam_score1 = [];
      List<String> hometeam_score1 = [];
      List<String> hometeam_logo1 = [];
      List<String> awayteam_logo1 = [];
      List<String> matchidr1 = [];

      for (var element in data) {
        if (element['match_status'] == 'Finished') {
          hometeamr1.add(element['match_hometeam_name']);
          awayteamr1.add(element['match_awayteam_name']);
          hometeam_score1.add(element['match_hometeam_ft_score']);
          awayteam_score1.add(element['match_awayteam_ft_score']);
          hometeam_logo1.add(element['team_home_badge']);
          awayteam_logo1.add(element['team_away_badge']);
          matchidr1.add(element['match_id']);
        }
      }
      print(data);
      setState(() {
        _currentView = ViewType.result;
        hometeamr = hometeamr1;
        awayteamr = awayteamr1;
        hometeam_score = hometeam_score1;
        awayteam_score = awayteam_score1;
        hometeam_logo = hometeam_logo1;
        awayteam_logo = awayteam_logo1;
        matchidr = matchidr1;
      });
    } catch (e) {
      print("Error fetching data: $e");
      // Handle the error or show a message to the user
    }
  }

  Widget _fixt() {
    if (_currentView == ViewType.fixtures) {
      return ListView.builder(
          itemCount: homeTeams.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        Colors.white, // Set the background color of the button
                    padding:
                        EdgeInsets.zero, // Remove any padding inside the button
                  ),
                  onPressed: () {
                    setState(() {
                      Navigator.pushNamed(context, '/det1',
                          arguments: matchid[index]);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.network(homelogoList[index], width: 50, height: 50),
                      Text(homeTeams[index]),
                      Column(
                        children: [
                          Text(timeList[index]),
                          Text(dates[index]),
                        ],
                      ),
                      Text(awayTeams[index]),
                      Image.network(awaylogoList[index], width: 50, height: 50)
                    ],
                  )),
            );
          });
    } else if (_currentView == ViewType.table) {
      return ListView.builder(
        itemCount: pos.length + 1, // Add 1 for the heading row
        itemBuilder: (context, index) {
          if (index == 0) {
            // Heading row
            return const Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Pos',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Team',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Played',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Win',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Loss',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Points',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                )
              ],
            );
          } else {
            // Data rows
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          pos[index -
                              1], // Subtract 1 to adjust for heading row
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          teamname[index -
                              1], // Subtract 1 to adjust for heading row
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          played[index -
                              1], // Subtract 1 to adjust for heading row
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          win[index -
                              1], // Subtract 1 to adjust for heading row
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          loss[index -
                              1], // Subtract 1 to adjust for heading row
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          points[index -
                              1], // Subtract 1 to adjust for heading row
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.black,
                ), // Add Divider after each Row
              ],
            );
          }
        },
      );
    } else {
      return ListView.builder(
          itemCount: hometeamr.length,
          itemBuilder: (context, index) {
            final reversedIndex = hometeamr.length - 1 - index;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        Colors.white, // Set the background color of the button
                    padding:
                        EdgeInsets.zero, // Remove any padding inside the button
                  ),
                  onPressed: () {
                    print(matchidr);
                    setState(() {
                      Navigator.pushNamed(context, '/det1',
                          arguments: matchidr[reversedIndex]);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.network(hometeam_logo[reversedIndex],
                          width: 40, height: 40),
                      Text(hometeamr[reversedIndex]),
                      Text(hometeam_score[reversedIndex]),
                      Text("-"),
                      Text(awayteam_score[reversedIndex]),
                      Text(awayteamr[reversedIndex]),
                      Image.network(awayteam_logo[reversedIndex],
                          width: 40, height: 40)
                    ],
                  )),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "QUICK SCORE",
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: const Color.fromARGB(255, 107, 69, 221),
      ),
      body: Center(
          child: Column(children: [
        const SizedBox(height: 50),
        Image.asset('assets/laligatrans2.png', width: 100, height: 100),
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
                style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  fetch_fixtures(formattedDate);
                },
                child: const Text(
                  "Fixtures",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            OutlinedButton(
                style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: fetch_table,
                child: const Text(
                  "Table",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            OutlinedButton(
                style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  fetch_result(formattedDate);
                },
                child: const Text(
                  "Result",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))
          ],
        ),
        Expanded(
          child: _fixt(),
        )
      ])),
      backgroundColor: Color.fromARGB(255, 192, 226, 236),
    );
  }
}
