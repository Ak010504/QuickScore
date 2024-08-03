import 'package:flutter/material.dart';
import 'package:quickscore/details.dart';
import 'package:quickscore/laliga.dart';
import 'package:quickscore/pl.dart';
import 'package:quickscore/details1.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const SplashPage(), // Use SplashPage as the initial page
    routes: {
      '/quotes': (context) => const Laliga(),
      '/quotes1': (context) => const Pl(),
      '/det': (context) => const Details(),
      '/home': (context) => const HomePage(), // Added route for the HomePage
      '/det1': (context) => const Details1(),
    },
  ));
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 143, 208, 229),
      body: Center(
        child: const Text(
          "QUICK SCORE",
          style: TextStyle(
              fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        child: Column(
          children: [
            const SizedBox(height: 150),
            const Text(
              "LEAGUES",
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 80),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pushNamed(context, '/quotes1');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/pltrans.jpg',
                            width: 50, height: 50),
                        const SizedBox(width: 10),
                        const Text(
                          'Premier League',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pushNamed(context, '/quotes');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/laligatrans.png',
                            width: 50, height: 50),
                        const SizedBox(width: 10),
                        const Text(
                          'La Liga',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 143, 208, 229),
    );
  }
}
