class Post {
  Post({
    required this.id,
    required this.title,
    required this.communityName,
    required this.communityProfilePic,
    required this.upVotes,
    required this.downVotes,
    required this.commentCount,
    required this.username,
    required this.uid,
    required this.type,
    required this.createdAt,
    required this.awards,
    this.link,
    this.description,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      title: map['title'] as String,
      communityName: map['communityName'] as String,
      communityProfilePic: map['communityProfilePic'] as String,
      link: map['link'] != null ? map['link'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      upVotes: (map['upVotes'] as List).map((e) => e.toString()).toList(),
      downVotes: (map['downVotes'] as List).map((e) => e.toString()).toList(),
      commentCount: map['commentCount'] as int,
      username: map['username'] as String,
      uid: map['uid'] as String,
      type: map['type'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      awards: (map['awards'] as List).map((e) => e.toString()).toList(),
    );
  }

  final String id;
  final String title;
  final String communityName;
  final String communityProfilePic;
  final String? link;
  final String? description;
  final List<String> upVotes;
  final List<String> downVotes;
  final int commentCount;
  final String username;
  final String uid;
  final String type;
  final DateTime createdAt;
  final List<String> awards;

  Post copyWith({
    String? id,
    String? title,
    String? communityName,
    String? communityProfilePic,
    String? link,
    String? description,
    List<String>? upVotes,
    List<String>? downVotes,
    int? commentCount,
    String? username,
    String? uid,
    String? type,
    DateTime? createdAt,
    List<String>? awards,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      communityName: communityName ?? this.communityName,
      communityProfilePic: communityProfilePic ?? this.communityProfilePic,
      link: link ?? this.link,
      description: description ?? this.description,
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
      commentCount: commentCount ?? this.commentCount,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'communityName': communityName,
      'communityProfilePic': communityProfilePic,
      'link': link,
      'description': description,
      'upVotes': upVotes,
      'downVotes': downVotes,
      'commentCount': commentCount,
      'username': username,
      'uid': uid,
      'type': type,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'awards': awards,
    };
  }

  @override
  String toString() {
    return 'Post(id: $id, title: $title, communityName: $communityName, communityProfilePic: $communityProfilePic, link: $link, description: $description, upVotes: $upVotes, downVotes: $downVotes, commentCount: $commentCount, username: $username, uid: $uid, type: $type, createdAt: $createdAt, awards: $awards)';
  }
}
