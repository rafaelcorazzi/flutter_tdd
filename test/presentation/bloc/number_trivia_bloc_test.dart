import 'package:dartz/dartz.dart';
import 'package:flutterapptdd/core/error/failures.dart';
import 'package:flutterapptdd/core/usecases/usecase.dart';
import 'package:flutterapptdd/core/util/input_converter.dart';
import 'package:flutterapptdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutterapptdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutterapptdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutterapptdd/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutterapptdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetConcreteNumberTrivia extends Mock 
    implements GetConcreteNumberTrivia {}


class MockGetRandomNumberTrivia extends Mock 
    implements GetRandomNumberTrivia {}


class MockInputConverter extends Mock implements InputConverter {}

void main(){
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp((){
      mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
      mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
      mockInputConverter = MockInputConverter();

      bloc = NumberTriviaBloc(concrete: mockGetConcreteNumberTrivia, random: mockGetRandomNumberTrivia, inputConverter: mockInputConverter);
  
  });
  test('initialState should be Empty', () {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });
  
  group('GetTriviaConcreteNumber', (){
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text : 'FooBar');

    test('should call the inputconverter to validate and convert the string to an unsigned integer', () async {
        
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        verify(mockInputConverter.stringToUnsignedInteger((tNumberString)));

    });

    test('should emit error when the input is invalid', () async { 
      when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

      
      final expected = [
        Empty(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE)
      ];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

     test('should get data from the concrete usecase', () async { 

         when(mockInputConverter.stringToUnsignedInteger(any))
                  .thenReturn(Right(tNumberParsed));

         when(mockGetConcreteNumberTrivia(any))
                  .thenAnswer((_) async => Right(tNumberTrivia));
        
         bloc.add(GetTriviaForConcreteNumber(tNumberString));
         
         await untilCalled(mockGetConcreteNumberTrivia(any));

         verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));

         

      });

      test('should emit [loading, loaded] wher data is gotten sucessufly', () async {

        when(mockInputConverter.stringToUnsignedInteger(any))
                  .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any))
                  .thenAnswer((_) async => Right(tNumberTrivia));

        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];

        expectLater(bloc, emitsInOrder(expected));
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      });

      test('should emit [Loading , Error] when getting data fails', () async {

          when(mockInputConverter.stringToUnsignedInteger(any))
                  .thenReturn(Right(tNumberParsed));
          when(mockGetConcreteNumberTrivia(any))
                  .thenAnswer((_) async => Left(ServerFailure()));

          final expected = [
            Empty(),
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE)
          ];

          expectLater(bloc, emitsInOrder(expected));
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
      });
  });
  
   group('GetTriviaRandomNumber', (){
   
    final tNumberTrivia = NumberTrivia(number: 1, text : 'FooBar');

   test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test('should emit [loading, loaded] wher data random is gotten sucessufly', () async {

        when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Right(tNumberTrivia));
       
       
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];

        expectLater(bloc, emitsInOrder(expected));
        bloc.add(GetTriviaForRandomNumber());
      });

      test('should emit [Loading , Error] when getting data fails', () async {

          when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => Left(ServerFailure()));
       

          final expected = [
            Empty(),
            Loading(),
            Error(message: SERVER_FAILURE_MESSAGE)
          ];

          expectLater(bloc, emitsInOrder(expected));
          bloc.add(GetTriviaForRandomNumber());
      });

  });


}
