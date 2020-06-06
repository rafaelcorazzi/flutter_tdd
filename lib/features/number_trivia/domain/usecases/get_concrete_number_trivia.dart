import 'package:equatable/equatable.dart';
import 'package:flutterapptdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';
import 'package:meta/meta.dart';
import '../../../../core/usecases/usecase.dart';



class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  Future<Either<Failure, NumberTrivia>> call(Params params) async {
      return await repository.getConcreteNumberTrivia(params.number);
  }

}

class Params extends Equatable{
  final int number;
  Params({@required this.number});

  @override
  List<Object> get props => [number];
}