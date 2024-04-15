import 'package:reddit/core/constants/constants.dart';

class UserModel {
  UserModel({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.banner,
    required this.karma,
    required this.awards,
    required this.isAuthenticated,
  });

  factory UserModel.newUser({
    required String uid,
    required String? name,
    required String? profilePic,
  }) =>
      UserModel(
        uid: uid,
        name: name ?? '',
        profilePic: profilePic ?? Defaults.avatar,
        banner: Defaults.banner,
        karma: 0,
        awards: [],
        isAuthenticated: true,
      );

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        name: map['name'] as String,
        profilePic: map['profilePic'] as String,
        banner: map['banner'] as String,
        uid: map['uid'] as String,
        isAuthenticated: (map['isAuthenticated'] as bool?) ?? false,
        karma: map['karma'] as int,
        awards: (map['awards'] as List).map((e) => e.toString()).toList(),
      );

  final String name;
  final String profilePic;
  final String banner;
  final String uid;
  final bool isAuthenticated;
  final int karma;
  final List<String> awards;

  UserModel copyWith({
    String? name,
    String? profilePic,
    String? banner,
    String? uid,
    String? isAuthenticated,
    int? karma,
    List<String>? awards,
  }) =>
      UserModel(
        name: name ?? this.name,
        profilePic: profilePic ?? this.profilePic,
        banner: banner ?? this.banner,
        uid: uid ?? this.uid,
        isAuthenticated: isAuthenticated as bool? ?? this.isAuthenticated,
        karma: karma ?? this.karma,
        awards: awards ?? this.awards,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'banner': banner,
      'uid': uid,
      'isAuthenticated': isAuthenticated,
      'karma': karma,
      'awards': awards,
    };
  }

  @override
  String toString() => 'UserModel(name: $name, profilePic: $profilePic, '
      'banner: $banner, uid: $uid, isAuthenticated: $isAuthenticated, '
      'karma: $karma, awards: $awards)';
}
