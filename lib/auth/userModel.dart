import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'userModel.g.dart';

@HiveType(typeId: 1)
class PrismUsers {
  @HiveField(0)
  String username;
  @HiveField(1)
  String email;
  @HiveField(2)
  String id;
  @HiveField(3)
  String createdAt;
  @HiveField(4)
  bool premium;
  @HiveField(5)
  DateTime lastLogin;
  @HiveField(6)
  Map links;
  @HiveField(7)
  List followers;
  @HiveField(8)
  List following;
  @HiveField(9)
  String profilePhoto;
  @HiveField(10)
  String bio;
  @HiveField(11)
  bool loggedIn;

  PrismUsers({
    required this.username,
    required this.email,
    required this.id,
    required this.createdAt,
    required this.premium,
    required this.lastLogin,
    required this.links,
    required this.followers,
    required this.following,
    required this.profilePhoto,
    required this.bio,
    required this.loggedIn,
  }) {
    debugPrint("Default constructor !!!!");
  }

  PrismUsers.withSave({
    required this.username,
    required this.email,
    required this.id,
    required this.createdAt,
    required this.premium,
    required this.lastLogin,
    required this.links,
    required this.followers,
    required this.following,
    required this.profilePhoto,
    required this.bio,
    required this.loggedIn,
  }) {
    debugPrint("With Save constructor !!!!");
    FirebaseFirestore.instance.collection('users').doc(id).update({
      'bio': bio,
      'username': username,
      'email': email,
      'id': id,
      'createdAt': createdAt,
      'premium': premium,
      'lastLogin': lastLogin,
      'links': links,
      'followers': followers,
      'following': following,
      'profilePhoto': profilePhoto,
    });
  }
  PrismUsers.initial({
    this.bio = "",
    this.email = "",
    this.username = "",
    this.id = "",
    required this.createdAt,
    this.premium = false,
    required this.lastLogin,
    required this.links,
    required this.followers,
    required this.following,
    this.profilePhoto = "",
    this.loggedIn = false,
  }) {
    debugPrint("initial constructor !!!!");
  }

  PrismUsers.withoutSave({
    required this.username,
    required this.email,
    required this.id,
    required this.createdAt,
    required this.premium,
    required this.lastLogin,
    required this.links,
    required this.followers,
    required this.following,
    required this.profilePhoto,
    required this.bio,
    required this.loggedIn,
  }) {
    debugPrint("Without save constructor !!!!");
    FirebaseFirestore.instance.collection('users').doc(id).update({
      'bio': bio,
      'username': username,
      'following': following,
      'lastLogin': DateTime.now(),
      'links': links,
      'profilePhoto': profilePhoto,
    });
  }

  factory PrismUsers.fromDocumentSnapshot(DocumentSnapshot doc, User user) =>
      PrismUsers.withoutSave(
        bio: ((doc.data()! as dynamic)["bio"] ?? "").toString(),
        createdAt: (doc.data()! as dynamic)["createdAt"].toString(),
        email: (doc.data()! as dynamic)["email"].toString(),
        username: ((doc.data()! as dynamic)["username"] ?? user.displayName)
            .toString(),
        followers: (doc.data()! as dynamic)["followers"] as List,
        following: (doc.data()! as dynamic)["following"] as List,
        id: (doc.data()! as dynamic)["id"].toString(),
        lastLogin: (((doc.data()! as dynamic)["lastLogin"] as Timestamp?) ??
                Timestamp.now())
            .toDate(),
        links: (doc.data()! as dynamic)["links"] as Map,
        premium: (doc.data()! as dynamic)["premium"] as bool,
        loggedIn: true,
        profilePhoto:
            ((doc.data()! as dynamic)["profilePhoto"] ?? user.photoURL)
                .toString(),
      );

  Map<String, dynamic> toJson() => {
        "bio": bio,
        "createdAt": createdAt,
        "email": email,
        "username": username,
        "links": links,
        "premium": premium,
        "profilePhoto": profilePhoto,
      };
}

// class PrismUsers {
//   @HiveField(0)
//   String? username;
//   @HiveField(1)
//   String? email;
//   @HiveField(2)
//   String? id;
//   @HiveField(3)
//   String? createdAt;
//   @HiveField(4)
//   bool? premium;
//   @HiveField(5)
//   DateTime? lastLogin;
//   @HiveField(6)
//   Map? links;
//   @HiveField(7)
//   List? followers;
//   @HiveField(8)
//   List? following;
//   @HiveField(9)
//   String? profilePhoto;
//   @HiveField(10)
//   String? bio;
//   @HiveField(11)
//   bool? loggedIn;

//   PrismUsers({
//     required this.username,
//     required this.email,
//     required this.id,
//     required this.createdAt,
//     required this.premium,
//     required this.lastLogin,
//     required this.links,
//     required this.followers,
//     required this.following,
//     required this.profilePhoto,
//     required this.bio,
//     required this.loggedIn,
//   });

//   PrismUsers.withSave({
//     required this.username,
//     required this.email,
//     required this.id,
//     required this.createdAt,
//     required this.premium,
//     required this.lastLogin,
//     required this.links,
//     required this.followers,
//     required this.following,
//     required this.profilePhoto,
//     required this.bio,
//     required this.loggedIn,
//   }) {
//     debugPrint("With Save constructor !!!!");
//     FirebaseFirestore.instance.collection('users').doc(id).update({
//       'bio': bio,
//       'username': username,
//       'email': email,
//       'id': id,
//       'createdAt': createdAt,
//       'premium': premium,
//       'lastLogin': lastLogin,
//       'links': links,
//       'followers': followers,
//       'following': following,
//       'profilePhoto': profilePhoto,
//     });
//   }
//   PrismUsers.initial({
//     this.bio = "",
//     this.email = "",
//     this.username = "",
//     this.id = "",
//     required this.createdAt,
//     this.premium = false,
//     required this.lastLogin,
//     required this.links,
//     required this.followers,
//     required this.following,
//     this.profilePhoto = "",
//     this.loggedIn = false,
//   }) {
//     debugPrint("initial constructor !!!!");
//   }

//   PrismUsers.withoutSave({
//     required this.username,
//     required this.email,
//     required this.id,
//     required this.createdAt,
//     required this.premium,
//     required this.lastLogin,
//     required this.links,
//     required this.followers,
//     required this.following,
//     required this.profilePhoto,
//     required this.bio,
//     required this.loggedIn,
//   }) {
//     debugPrint("Without save constructor !!!!");
//     FirebaseFirestore.instance.collection('users').doc(id).update({
//       'bio': bio,
//       'username': username,
//       'following': following,
//       'lastLogin': DateTime.now(),
//       'links': links,
//       'profilePhoto': profilePhoto,
//     });
//   }

//   factory PrismUsers.fromDocumentSnapshot({
//     Map<String, dynamic>? json,
//   }) {
//     return PrismUsers(
//       bio: json!['bio'],
//       createdAt: json['createdAt'].toString(),
//       email: json['email'],
//       username: json['username'],
//       followers: json['followers'],
//       following: json['following'],
//       id: json['id'].lastLogin(),
//       lastLogin: (json['lastLogin'].toDate()),
//       links: json['links'] as Map,
//       premium: json['premium'] as bool,
//       loggedIn: true,
//       profilePhoto: json['profilePhoto'].toString(),
//     );
//   }

//   Map<String, dynamic> toMap({PrismUsers? model}) {
//     Map<String, dynamic> map = {};
//     map['bio'] = model!.bio;
//     map['createdAt'] = model.createdAt;
//     map['email'] = model.email;
//     map['username'] = model.username;
//     map['followers'] = model.followers;
//     map['following'] = model.following;
//     map['id'] = model.id;
//     map['lastLogin'] = model.lastLogin;
//     map['links'] = model.links;
//     map['premium'] = model.premium;
//     map['loggedIn'] = model.loggedIn;
//     map['profilePhoto'] = model.profilePhoto;
//     return map;
//   }
// }
