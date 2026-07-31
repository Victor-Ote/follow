class BabelBookCoordinates {
  const BabelBookCoordinates({
    required this.libraryUrl,
    required this.wall,
    required this.shelf,
    required this.volume,
    required this.page,
    required this.hexagonAssetPath,
  });

  final String libraryUrl;
  final String wall;
  final String shelf;
  final String volume;
  final String page;
  final String hexagonAssetPath;
}

const babelBookCoordinates = BabelBookCoordinates(
  libraryUrl: 'https://libraryofbabel.info/browse.cgi',
  wall: '3',
  shelf: '3',
  volume: '4',
  page: '119',
  hexagonAssetPath: 'assets/data/babel_hexagon.txt',
);