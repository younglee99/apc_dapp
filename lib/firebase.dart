import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'variable.dart';

class ImageData {
  String title;
  DateTime? date;

  ImageData(this.title, this.date);
}

Future<void> getData() async {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  firebase_storage.ListResult result = await storage.ref('images/').list();

  List<ImageData> imageList = [];

  for (firebase_storage.Reference ref in result.prefixes) {
    String title = ref.name.split('/').last;

    firebase_storage.Reference imageRef = storage.ref('images/$title/');
    firebase_storage.ListResult result = await imageRef.list();

    DateTime? latestDate;

    for (firebase_storage.Reference imageRef in result.items) {
      firebase_storage.FullMetadata metadata = await imageRef.getMetadata();
      DateTime? imageDate = metadata.updated;

      if (imageDate != null) {
        if (latestDate == null || imageDate.isAfter(latestDate)) {
          latestDate = imageDate;
        }
      }
    }

    imageList.add(ImageData(title, latestDate));
  }

  imageList.sort((a, b) => b.date!.compareTo(a.date!)); // 날짜를 기준으로 내림차순 정렬

  productTitles = imageList.map((imageData) => imageData.title).toList();
  imageDates =
      imageList.map((imageData) => formatDate(imageData.date)).toList();
}

String formatDate(DateTime? date) {
  if (date == null) return '';

  String year = date.year.toString();
  String month = date.month.toString().padLeft(2, '0');
  String day = date.day.toString().padLeft(2, '0');

  return '$year-$month-$day';
}
