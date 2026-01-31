Map<String, int> calculateAge(DateTime dob) {
  final now = DateTime.now();

  int years = now.year - dob.year;
  int months = now.month - dob.month;

  if (months < 0) {
    years--;
    months += 12;
  }

  return {
    'year': years,
    'month': months,
  };
}
