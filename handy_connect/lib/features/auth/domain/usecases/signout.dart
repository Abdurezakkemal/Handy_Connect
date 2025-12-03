import 'package:firebase_auth/firebase_auth.dart';
import 'package:handy_connect/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:handy_connect/core/usecase/usecase.dart';

class SignOut implements UseCase<void, NoParams> {
  final FirebaseAuth auth;

  SignOut(this.auth);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      await auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
