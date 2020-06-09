import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapptdd/core/util/input_converter.dart';

void main(){
  InputConverter inputConverter;
  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', (){

    test('should convert string number to integer', () async {
        final str = '123';
        final result = inputConverter.stringToUnsignedInteger(str);

        expect(result, Right(123));
    });

     test('should return failure string number is not a integer', () async {
        final str = '1.0';
        final result = inputConverter.stringToUnsignedInteger(str);

        expect(result, Left(InvalidInputFailure()));
    });

    test('should return failure string number is a negative integer', () async {
        final str = '-123';
        final result = inputConverter.stringToUnsignedInteger(str);

        expect(result, Left(InvalidInputFailure()));
    });

  });
}




