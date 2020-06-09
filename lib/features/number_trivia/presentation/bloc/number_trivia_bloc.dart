import 'dart:async';
import 'package:flutterapptdd/core/error/failures.dart';
import 'package:flutterapptdd/core/usecases/usecase.dart';
import 'package:flutterapptdd/features/number_trivia/data/datasources/number_trivia_local_data.dart';
import 'package:flutterapptdd/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:flutterapptdd/core/util/input_converter.dart';
import 'package:flutterapptdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutterapptdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'number_trivia_event.dart';
import 'number_trivia_state.dart';


const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete, 
    @required GetRandomNumberTrivia random,
    @required this.inputConverter
  }) : assert(concrete != null),
       assert(random != null),
       assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;
  
  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if(event is GetTriviaForConcreteNumber){
      final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);
       
      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      },
      (integer) async* {
        yield Loading();
        final failureOrTrivia =
          await getConcreteNumberTrivia(Params(number: integer));

        yield failureOrTrivia.fold((failure) => Error(message: _mapFailureToMessage(failure)),
        (trivia) => Loaded(trivia: trivia));

      },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = 
          await getRandomNumberTrivia(NoParams());
      
       yield failureOrTrivia.fold((failure) => Error(message: _mapFailureToMessage(failure)),
        (trivia) => Loaded(trivia: trivia));
          
    }
  }
  String _mapFailureToMessage(Failure failure){
    switch(failure.runtimeType){
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CachedFailure:
        return CACHED_NUMBER_TRIVIA;
      default:
        return 'Unxpected Error'; 
    }
  }
}
