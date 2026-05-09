class PopularRoute {
  final String originGov;
  final String destinationGov;
  
  const PopularRoute({
    required this.originGov,
    required this.destinationGov,
  });

  String get label => '$originGov ➔ $destinationGov';
}
