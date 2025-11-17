
import '../../data/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.uid, super.email, super.name});

  factory UserModel.fromFirebaseUser(dynamic user) {
    return UserModel(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

}
