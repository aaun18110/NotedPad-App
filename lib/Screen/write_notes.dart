// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../Boxes/boxes.dart';
import '../Models/notes_model.dart';
import '../Utils/routes.dart';

class WriteNotes extends StatefulWidget {
  const WriteNotes({super.key});

  @override
  State<WriteNotes> createState() => _WriteNotesState();
}

class _WriteNotesState extends State<WriteNotes> {
  TextEditingController titleController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();
  int charlength = 0;
  _onChanged(String value) {
    charlength = value.length;
    setState(() {
      Hive.openBox("diary");
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 5),
            child: InkWell(
                onTap: () {
                  print("add data");
                  if (_formKey.currentState!.validate()) {
                    var data = NotesModel(
                      title: titleController.text.toString(),
                      discription: discriptionController.text.toString(),
                      date: DateFormat("dd-MMM-yyyy").format(DateTime.now()),
                      // DateFormat.yMEd().add_jms().format(DateTime.now()),
                    );
                    var box = Boxes.getData();
                    box.add(data);
                    titleController.clear();
                    discriptionController.clear();
                    Navigator.pushNamed(context, RouteName.homeScreen);
                  } else {
                    return print("not");
                  }
                },
                child: const Icon(
                  Icons.check,
                  size: 30,
                )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: titleController,
                    cursorColor: Colors.black,
                    style: const TextStyle(fontSize: 30),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Input title",
                      hintStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[400]),
                    ),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Text is empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      Text(DateFormat("dd-MMM-yyyy").format(DateTime.now())),
                      // Text(DateFormat.yMEd().add_jms().format(DateTime.now())),
                      const Text(
                        "  |  ",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text("$charlength words"),
                    ],
                  ),
                  TextFormField(
                    controller: discriptionController,
                    autocorrect: true,
                    autofocus: true,
                    maxLines: null,
                    onChanged: _onChanged,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(border: InputBorder.none),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Text is empty';
                      }
                      return null;
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
