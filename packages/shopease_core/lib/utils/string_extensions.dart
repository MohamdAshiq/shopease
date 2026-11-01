extension StringFormatting on String {
  // Capitalizes the first letter of each word
  String get capitalizeWords {
    if (trim().isEmpty) return this;
    return trim()
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) return word;
          return '${word[0].toUpperCase()}${word.substring(1)}';
        })
        .join(' ');
  }

  // Capitalizes only the first character of the string
  String get capitalizeFirst {
    if (trim().isEmpty) return this;
    final trimmed = trim();
    return '${trimmed[0].toUpperCase()}${trimmed.substring(1)}';
  }

  // Extracts user initials from a name
  String get initials {
    final clean = trim();
    if (clean.isEmpty) return 'U';
    final parts = clean
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
