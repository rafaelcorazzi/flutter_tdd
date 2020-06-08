import 'dart:convert';

import 'package:flutterapptdd/core/error/exceptions.dart';
import 'package:flutterapptdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

/// abstract is look like a interface on C#
abstract class NumberTriviaLocalData {

  Future<NumberTriviaModel> getLastNumberTrivia();
  
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);

}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalData {

  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});
  
  @override
  Future<NumberTriviaModel> getLastNumberTrivia(){
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if(jsonString != null){
        return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    }else{
      throw CacheException();
    }
  }
  
  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache){
    return sharedPreferences.setString(CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));
  }

}