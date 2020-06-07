
import 'package:flutterapptdd/features/number_trivia/data/models/number_trivia_model.dart';


abstract class NumberTriviaRemoteData {

    /// call the http://numbersapi.com/{number} endpoint
    /// 
    /// Throws a [ServerException] for all error codes.
   Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
   /// call the http://numbersapi.com/random endpoint
    /// 
    /// Throws a [ServerException] for all error codes.
   Future<NumberTriviaModel> getRandomNumberTrivia();
}