import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapptdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutterapptdd/features/number_trivia/domain/entities/number_trivia.dart';
import '../../../../fixtures/fixture_reader.dart';

import 'dart:convert';
void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'FooBar');

  test(
    'should be a subclass of numberTriviaEntity',
    () async {
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson', () {
      test('show return a valid model when the json number is an integer',
       () async {
          
          final Map<String, dynamic> jsonMap = 
              json.decode(fixture('trivia.json'));
          final result = NumberTriviaModel.fromJson(jsonMap);

          expect(result, equals(tNumberTriviaModel));
       });
       test('show return a valid model when the json number as a double',
       () async {
          
          final Map<String, dynamic> jsonMap = 
              json.decode(fixture('trivia_double.json'));
          final result = NumberTriviaModel.fromJson(jsonMap);

          expect(result, equals(tNumberTriviaModel));
       });
  }); 

  group('toJson', (){
    test('should return a json map containing the proper data', () async{
        final result =  tNumberTriviaModel.toJson();
        final expectedMap = {
          "text": "FooBar", "number": 1
        };
        expect(result, expectedMap);
    });
  });
}