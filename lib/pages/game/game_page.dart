import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'game.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Game _game;
  final _controller = TextEditingController();
  String? _guessNumber;
  String? _feedback;
  List<String> resultGuess = [];

  _NewGame() {
    setState(() {
      _game = Game();
      _guessNumber = null;
      _feedback = null;
       resultGuess = [];
    });
  }

  _Winner() {
    if (_feedback == 'CORRECT!') {
      return true;
    } else {
      return false;
    }
  }

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: GoogleFonts.caveat(
                  fontSize: 20.0,
                  color: Colors.red.shade300,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _game = Game();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: const DecorationImage(
            image: const AssetImage("assets/images/bg5.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            // column หลักเต็มจอ
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // column รูปภาพและข้อความด้านบน
                _buildHeader(),
                // Text ด้านล่างรูป
                _buildMainContent(),
                // TextField ให้ User กรอกข้อมูล
                _buildInputPamel(),
              ], // children ของทั้งหมด
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Text(
          'GUESS THE NUMBER',
          style: GoogleFonts.caveat(
            fontSize: 50.0,
            color: Colors.brown.shade500,
          ),
        ),
        Image.asset(
          'assets/images/logo_number.png',
          width: 240.0, // 96 = 1 inch
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return _guessNumber == null
        ? Center(
            child: Column(
              children: [
                Text(
                  'This is Guess The Number Game from 1 - 100',
                  style: GoogleFonts.caveat(
                    fontSize: 40.0,
                    color: Colors.brown.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Try It Out!',
                  style: GoogleFonts.caveat(
                    fontSize: 50.0,
                    color: Colors.red.shade400,
                  ),
                ),
              ],
            ),
          )
        : _Winner()
            ? Center(
                child: Column(
                  children: [
                    Text(
                      _guessNumber!,
                      style: GoogleFonts.caveat(
                        fontSize: 90.0,
                        color: Colors.brown.shade700,
                      ),
                    ),
                    Text(
                      _feedback!,
                      style: GoogleFonts.caveat(
                        fontSize: 60.0,
                        color: Colors.redAccent.shade400,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ElevatedButton(
                        onPressed: _NewGame,
                        child: Text('NEW GAME'),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(150, 40),
                          primary: Colors.green.shade600.withOpacity(0.8),
                          textStyle: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  children: [
                    Text(
                      _guessNumber!,
                      style: GoogleFonts.caveat(
                        fontSize: 90.0,
                        color: Colors.brown.shade700,
                      ),
                    ),
                    Text(
                      _feedback!,
                      style: GoogleFonts.caveat(
                        fontSize: 60.0,
                        color: Colors.redAccent.shade400,
                      ),
                    ),
                  ],
                ),
              );
  }

  Widget _buildInputPamel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(5.0, 5.0),
            color: Colors.pink.shade300,
            spreadRadius: 5.0,
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Flexible(
                child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.brown,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              cursorColor: Colors.brown.shade700,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                isDense: true,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.brown.shade700.withOpacity(0.5),
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown),
                ),
                hintText: 'Enter the number here',
                hintStyle: GoogleFonts.caveat(
                  fontSize: 25.0,
                  color: Colors.brown.shade700.withOpacity(0.5),
                ),
              ),
            )),
            TextButton(
              onPressed: () {
                setState(() {
                  _guessNumber = _controller.text;
                  _controller.clear();
                  int? guess = int.tryParse(_guessNumber!);
                  resultGuess.add(_guessNumber! + ' ');

                  if (guess != null) {
                    var result = _game.doGuess(guess);
                    if (result == 0) {
                      _feedback = 'CORRECT!';
                      FocusScope.of(context).unfocus();
                      _showMaterialDialog(
                        'GOOD JOB!',
                        'The Answer is : $_guessNumber \n'
                            'Total Guess is : ${_game.getTotalGuess()}\n'
                            '\n\n History You Guess \n'
                            '$resultGuess',
                      );
                    } else if (result == 1) {
                      _feedback = 'TOO HIGH!';
                    } else {
                      _feedback = 'TOO LOW';
                    }
                  }
                });
              },
              child: Text(
                'GUESS',
                style: GoogleFonts.caveat(
                  fontSize: 30.0,
                  color: Colors.brown.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
