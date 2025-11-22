import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/radio_entity.dart';
import '../../domain/repositories/radio_repository.dart';
import '../datasources/radio_remote_datasource.dart';

class RadioRepositoryImpl implements RadioRepository {
  final RadioRemoteDataSource remoteDataSource;

  RadioRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RadioEntity>> getRadioConfig() async {
    try {
      final radioModel = await remoteDataSource.getRadioConfig();
      return Right(radioModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

