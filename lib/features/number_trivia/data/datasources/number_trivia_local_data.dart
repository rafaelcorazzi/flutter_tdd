import 'package:flutterapptdd/features/number_trivia/data/models/number_trivia_model.dart';

/// abstract is look like a interface on C#
abstract class NumberTriviaLocalData {

  Future<NumberTriviaModel> getLastNumberTrivia();
  
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);

}