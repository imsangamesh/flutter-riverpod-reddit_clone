class Comment {
  Comment({
    required this.id,
    required this.text,
    required this.postId,
    required this.username,
    required this.profilePic,
    required this.createdAt,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      text: map['text'] as String,
      postId: map['postId'] as String,
      username: map['username'] as String,
      profilePic: map['profilePic'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }
  final String id;
  final String text;
  final String postId;
  final String username;
  final String profilePic;
  final DateTime createdAt;

  Comment copyWith({
    String? id,
    String? text,
    String? postId,
    String? username,
    String? profilePic,
    DateTime? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'postId': postId,
      'username': username,
      'profilePic': profilePic,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, postId: $postId, '
        'username: $username, profilePic: $profilePic, createdAt: $createdAt)';
  }
}
