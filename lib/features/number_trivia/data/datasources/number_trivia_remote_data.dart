
import 'dart:convert';

import 'package:flutterapptdd/core/error/exceptions.dart';
import 'package:flutterapptdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';


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

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteData {

  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});


  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) => _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
    _getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
  final response = await client.get(
    url,
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    return NumberTriviaModel.fromJson(json.decode(response.body));
  } else {
    throw ServerException();
  }
}
}
