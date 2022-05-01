class CustomUser {
  final String id;
  final String email;
  final String displayName;
  final String region;
  final String muncipality;
  final String? photoUrl;
  final bool isVolunteer;

  CustomUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.region,
    required this.muncipality,
    required this.photoUrl,
    required this.isVolunteer,
  });
}
