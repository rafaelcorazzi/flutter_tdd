import 'package:flutterapptdd/core/error/exceptions.dart';
import 'package:flutterapptdd/core/error/failures.dart';
import 'package:flutterapptdd/core/plataform/network_info.dart';
import 'package:flutterapptdd/features/number_trivia/data/datasources/number_trivia_local_data.dart';
import 'package:flutterapptdd/features/number_trivia/data/datasources/number_trivia_remote_data.dart';
import 'package:flutterapptdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutterapptdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {

   final NumberTriviaRemoteData remoteDataSource;
   final NumberTriviaLocalData localDataSource;
   final NetworkInfo networkInfo;

   NumberTriviaRepositoryImpl(
      {
        @required this.remoteDataSource, 
        @required this.localDataSource, 
        @required this.networkInfo
        }
        );

   @override
   Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {
     return _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));
     
   }
   @override
   Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async{
     return _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
   }
   
   Future<Either<Failure, NumberTrivia>> _getTrivia(
     Future<NumberTrivia> Function() getConcreteOrRandom
   ) async {
      if(await networkInfo.isConnected){
        try{
            final remoteData = await getConcreteOrRandom();
            localDataSource.cacheNumberTrivia(remoteData);
            return Right(remoteData);
        } on ServerException{

          return Left(ServerFailure());
        }
     } else {

       try{
          final localTrivia = await localDataSource.getLastNumberTrivia();
          return Right(localTrivia);
       } on CacheException {
         return Left(CachedFailure());
       }
       
     }
   }
}