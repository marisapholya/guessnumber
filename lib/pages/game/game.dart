import 'dart:math';

class Game{
  final int  _answer;
  int _totalGuess = 0;

  Game(): _answer = Random().nextInt(100) + 1;

  int getTotalGuess(){
    return _totalGuess;
  }

  int doGuess(int num){
    _totalGuess++;
    if(num > _answer){
      return 1;
    }else if(num < _answer){
      return -1;
    }else{
      return 0;
    }
  }

}