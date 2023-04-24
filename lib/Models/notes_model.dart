import 'package:hive/hive.dart';

part 'notes_model.g.dart';

var date = DateTime.now().toString();

var dateParse = DateTime.parse(date);

var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";


@HiveType(typeId: 0)
class NotesModel extends HiveObject {
  @HiveField(0)
  late String title;
  @HiveField(1)
  late String discription;
  @HiveField(2)
  late String date = formattedDate;
  NotesModel(
      {required this.title, required this.discription, required this.date});
}
