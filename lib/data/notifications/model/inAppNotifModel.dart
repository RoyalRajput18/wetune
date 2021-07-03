import 'package:hive/hive.dart';
part 'inAppNotifModel.g.dart';

@HiveType(typeId: 9)
class InAppNotif {
  @HiveField(0)
  final String? title;
  @HiveField(1)
  final String? pageName;
  @HiveField(2)
  final String? body;
  @HiveField(3)
  final String? imageUrl;
  @HiveField(4)
  final List? arguments;
  @HiveField(5)
  final String? url;
  @HiveField(6)
  final DateTime? createdAt;
  @HiveField(7)
  final bool? read;

  InAppNotif({
    required this.pageName,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.arguments,
    required this.url,
    required this.createdAt,
    required this.read,
  });

//   factory InAppNotif.fromSnapshot(Map<String, dynamic> data) => InAppNotif(
//         pageName: data['data']['pageName'].toString(),
//         title: data['notification']['title'].toString(),
//         body: data['notification']['body'].toString(),
//         imageUrl: (data['data']['imageUrl'] ??
//                 "https://w.wallhaven.cc/full/q6/wallhaven-q6mg5d.jpg")
//             .toString(),
//         arguments: data['data']['arguments'] as List,
//         url: data['data']['url'].toString(),
//         createdAt: data['createdAt'].toDate() as DateTime,
//         read: false,
//       );
// }
  factory InAppNotif.fromSnapshot(
    Map<String, dynamic>? json,
  ) {
    return InAppNotif(
      pageName: json!['data']['pageName'].toString(),
      title: json['notification']['title'].toString(),
      body: json['notification']['body'].toString(),
      imageUrl: json['notification']['imageUrl'].toString(),
      arguments: json['data']['arguments'] as List,
      url: json['data']['url'].toString(),
      createdAt: json['createdAt'].toDate() as DateTime,
      read: false,
    );
  }

  // static InAppNotif fromSnapshot(Object? data) {}

  // Map<String, dynamic> toMap({InAppNotif? model}) {
  //   Map<String, dynamic> map = {};
  //   map['bio'] = model!.bio;
  //   map['createdAt'] = model.createdAt;
  //   map['email'] = model.email;
  //   map['username'] = model.username;
  //   map['followers'] = model.followers;
  //   map['following'] = model.following;
  //   map['id'] = model.id;
  //   map['lastLogin'] = model.lastLogin;
  //   map['links'] = model.links;
  //   map['premium'] = model.premium;
  //   map['loggedIn'] = model.loggedIn;
  //   map['profilePhoto'] = model.profilePhoto;
  //   return map;
  // }
}
