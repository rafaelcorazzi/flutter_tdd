import 'package:flutterapptdd/core/plataform/network_info.dart';
import 'package:flutterapptdd/features/number_trivia/data/datasources/number_trivia_local_data.dart';
import 'package:flutterapptdd/features/number_trivia/data/datasources/number_trivia_remote_data.dart';
import 'package:flutterapptdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteData {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalData {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main (){
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
      mockRemoteDataSource = MockRemoteDataSource();
      mockLocalDataSource = MockLocalDataSource();
      mockNetworkInfo = MockNetworkInfo();
      repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo,
      );
  });

}


