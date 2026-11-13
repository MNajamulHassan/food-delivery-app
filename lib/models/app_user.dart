/// The signed-in user.
class AppUser {
  final String name;
  final String email;

  const AppUser({required this.name, required this.email});

  String get firstName => name.trim().split(' ').first;

  /// Up to two initials for the avatar, e.g. "Ali Khan" -> "AK".
  String get initials {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
