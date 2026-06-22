class PopularRoute {
  final String originGov;
  final String destinationGov;
  final String originGovAr;
  final String originGovEn;
  final String destinationGovAr;
  final String destinationGovEn;

  const PopularRoute({
    required this.originGov,
    required this.destinationGov,
    required this.originGovAr,
    required this.originGovEn,
    required this.destinationGovAr,
    required this.destinationGovEn,
  });

  String get label => '$originGov \u2794 $destinationGov';
}
