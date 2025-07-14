import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String? name;
  final String? photo;
  final int? age;
  final int? totalPosts;
  final List<String>? preferences;

  const UserEntity({
    required this.uid,
    required this.email,
    this.name,
    this.photo,
    this.age,
    this.totalPosts,
    this.preferences,
  });

  @override
  List<Object?> get props =>
      [uid, email, name, photo, age, totalPosts, preferences];

  UserEntity copyWith({
    String? uid,
    String? email,
    String? name,
    String? photo,
    int? age,
    int? totalPosts,
    List<String>? preferences,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      age: age ?? this.age,
      totalPosts: totalPosts ?? this.totalPosts,
      preferences: preferences ?? this.preferences,
    );
  }
}
