class BabeliaRecord {
  const BabeliaRecord({required this.title, this.valueAssetPath});

  final String title;
  final String? valueAssetPath;
}

class BabeliaRecordsData {
  const BabeliaRecordsData({
    required this.firstRecord,
    required this.firstRecordUrl,
    required this.discoveredRecords,
  });

  final BabeliaRecord firstRecord;
  final String firstRecordUrl;
  final List<BabeliaRecord> discoveredRecords;
}

const BabeliaRecordsData babeliaRecordsData = BabeliaRecordsData(
  firstRecord: BabeliaRecord(
    title: 'Babelia #492184',
    valueAssetPath: 'assets/data/babelia_first_record.txt',
  ),
  firstRecordUrl: 'https://babelia.libraryofbabel.info/slideshow.html',
  discoveredRecords: [
    BabeliaRecord(
      title: 'Babelia #815942',
      valueAssetPath: 'assets/data/babelia_record_01.txt',
    ),
    BabeliaRecord(
      title: 'Babelia #102371',
      valueAssetPath: 'assets/data/babelia_record_02.txt',
    ),
    BabeliaRecord(
      title: 'Babelia #647205',
      valueAssetPath: 'assets/data/babelia_record_03.txt',
    ),
    BabeliaRecord(
      title: 'Babelia #293816',
      valueAssetPath: 'assets/data/babelia_record_04.txt',
    ),
    BabeliaRecord(
      title: 'Babelia #971430',
      valueAssetPath: 'assets/data/babelia_record_05.txt',
    ),
    BabeliaRecord(
      title: 'Babelia #536729',
      valueAssetPath: 'assets/data/babelia_record_06.txt',
    ),
  ],
);
