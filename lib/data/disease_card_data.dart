class DiseaseCardData {
  const DiseaseCardData(
      {required this.percentage,
      required this.disease,
      required this.imageLink,
      required this.diseaseDescription,
      required this.symptoms,
      required this.precautions,
      required this.routines,
      required this.help});
  final double percentage;
  final String disease;
  final String? imageLink;
  final String? diseaseDescription;
  final List<dynamic> symptoms;
  final List<dynamic> precautions;
  final List<dynamic> routines;
  final String? help;
}
