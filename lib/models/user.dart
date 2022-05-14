enum AttendanceState { wait, approved, refused }

class WorkshopAttendee {
  final String id;
  final AttendanceState state;

  WorkshopAttendee({
    required this.id,
    required this.state,
  });
}

class CustomUser {
  final String id;
  final String email;
  final String name;
  final String region;
  final String muncipality;
  final String photoUrl;
  final bool isVolunteer;
  final bool isOnboarded;
  final List<WorkshopAttendee> workshops;

  CustomUser({
    required this.id,
    required this.email,
    required this.name,
    required this.region,
    required this.muncipality,
    required this.photoUrl,
    required this.isVolunteer,
    required this.isOnboarded,
    required this.workshops,
  });
}
