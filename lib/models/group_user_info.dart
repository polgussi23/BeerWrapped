class GroupUserInfo {
  final String role;
  final String privacy;
  final bool canChangeToPrivate;

  GroupUserInfo(
      {required this.role,
      required this.privacy,
      required this.canChangeToPrivate});

  factory GroupUserInfo.fromJson(Map<String, dynamic> json) {
    return GroupUserInfo(
        role: json['role'] as String,
        privacy: json['privacy'] as String,
        canChangeToPrivate: json['canChangeToPrivate'] as bool);
  }
}
