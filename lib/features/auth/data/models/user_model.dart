import '../../domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    super.name,
    super.photo,
    super.age,
    super.totalPosts,
    super.preferences,
  });

  factory UserModel.fromFirebaseUser(firebase_auth.User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
    );
  }

  @override
  UserEntity copyWith({
    String? uid,
    String? email,
    String? name,
    String? photo,
    int? age,
    int? totalPosts,
    List<String>? preferences,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      age: age ?? this.age,
      totalPosts: totalPosts ?? this.totalPosts,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        name,
        photo,
        age,
        totalPosts,
        preferences,
      ];
}
