import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/notes_model.dart';

class ReadNotes extends StatefulWidget {
  const ReadNotes({super.key});

  @override
  State<ReadNotes> createState() => _ReadNotesState();
}

class _ReadNotesState extends State<ReadNotes> {
  String discription = '', title = '';
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    title = sp.getString("title") ?? "";
    discription = sp.getString("discription") ?? "";
    setState(() {
      Hive.openBox<NotesModel>("diary");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                title.toString(),
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const Divider(
                height: 30,
                thickness: 2,
              ),
              Text(
                discription.toString(),
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
