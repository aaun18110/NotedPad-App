// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_database/Models/notes_model.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../Utils/routes.dart';
import '../Boxes/boxes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController discriptionEditingController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String search = "";
  @override
  Widget build(BuildContext context) {
    print("build");
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: AnimatedSearchBar(
                label: "Notes",
                controller: searchController,
                labelStyle: const TextStyle(fontSize: 25),
                searchStyle: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                searchDecoration: const InputDecoration(
                  hintText: "Search",
                  alignLabelWithHint: true,
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  setState(() {
                    search = val;
                    Hive.openBox("diary");
                  });
                  print("value on Change");
                })),
        body: Column(
          children: [
            const LockCard(),
            ValueListenableBuilder<Box<NotesModel>>(
              valueListenable: Boxes.getData().listenable(),
              builder: (context, box, _) {
                var data = box.values.toList().cast<NotesModel>();
                return ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final String position = data[index].title.toString();
                      if (searchController.text.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: SingleChildScrollView(
                            child: Column(children: [
                              InkWell(
                                onTap: () async {
                                  SharedPreferences sp =
                                      await SharedPreferences.getInstance();
                                  sp.setString(
                                      "title", data[index].title.toString());
                                  sp.setString("discription",
                                      data[index].discription.toString());
                                  Navigator.pushNamed(
                                      context, RouteName.readNotes);
                                },
                                child: Card(
                                  child: ListTile(
                                    title: Text(
                                      data[index].title.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                    subtitle: Text(
                                      data[index].date,
                                      style: TextStyle(
                                          color: Colors.blue.shade800),
                                    ),
                                    trailing:
                                        PopupMenuButton(onSelected: (selected) {
                                      if (selected == 1) {
                                        return editdialogbox(
                                            data[index],
                                            data[index].title.toString(),
                                            data[index].discription.toString());
                                      } else if (selected == 2) {
                                        return deletecard(data[index]);
                                      } else {
                                        return Navigator.pop(context);
                                      }
                                    }, itemBuilder: (context) {
                                      return [
                                        const PopupMenuItem(
                                          value: 1,
                                          child: Text("Edit"),
                                        ),
                                        const PopupMenuItem(
                                          value: 2,
                                          child: Text("Delete"),
                                        ),
                                      ];
                                    }),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        );
                      } else if (position
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase())) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    SharedPreferences sp =
                                        await SharedPreferences.getInstance();
                                    sp.setString(
                                        "title", data[index].title.toString());
                                    sp.setString("discription",
                                        data[index].discription.toString());
                                    Navigator.pushNamed(
                                        context, RouteName.readNotes);
                                  },
                                  child: Card(
                                    child: ListTile(
                                      title: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blue.shade300,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              data[index].title.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      subtitle: Text(
                                        data[index].date,
                                        style: TextStyle(
                                            color: Colors.blue.shade800),
                                      ),
                                      trailing: PopupMenuButton(
                                          onSelected: (selected) {
                                        if (selected == 1) {
                                          return editdialogbox(
                                              data[index],
                                              data[index].title.toString(),
                                              data[index]
                                                  .discription
                                                  .toString());
                                        } else if (selected == 2) {
                                          return deletecard(data[index]);
                                        } else {
                                          return Navigator.pop(context);
                                        }
                                      }, itemBuilder: (context) {
                                        return [
                                          const PopupMenuItem(
                                            value: 1,
                                            child: Text("Edit"),
                                          ),
                                          const PopupMenuItem(
                                            value: 2,
                                            child: Text("Delete"),
                                          ),
                                        ];
                                      }),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          decoration: const BoxDecoration(),
                          // child: const Text("No Found"),
                        );
                      }
                    });
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("box");
            Navigator.pushNamed(context, RouteName.writeNotes);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void deletecard(NotesModel notesModel) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Are you sure you?"),
            actions: [
              TextButton(
                  onPressed: () {
                    notesModel.delete();
                    Navigator.pop(context);
                    AnimatedSnackBar.material(
                      'Deleted Sucessfully',
                      duration: const Duration(seconds: 1),
                      type: AnimatedSnackBarType.info,
                      desktopSnackBarPosition:
                          DesktopSnackBarPosition.bottomCenter,
                    ).show(context);
                  },
                  child: const Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No"))
            ],
          );
        });
  }

  // void deletecard(NotesModel notesModel) {
  //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //   //     behavior: SnackBarBehavior.floating,
  //   //     backgroundColor: Colors.transparent,
  //   //     duration: const Duration(seconds: 1),
  //   //     // animation: ,
  //   //     elevation: 0,
  //   //     content: Container(
  //   //       decoration: BoxDecoration(
  //   //           color: Colors.grey[400], borderRadius: BorderRadius.circular(12)),
  //   //       child: const Center(
  //   //         child: Padding(
  //   //           padding: EdgeInsets.all(12.0),
  //   //           child: Text(
  //   //             "Deleted Sucessfully",
  //   //             style: TextStyle(color: Colors.black),
  //   //           ),
  //   //         ),
  //   //       ),
  //   //     )));
  // }

  void editdialogbox(NotesModel notesModel, String title, String discription) {
    titleEditingController.text = title;
    discriptionEditingController.text = discription;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text("Edit Notes")),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleEditingController,
                    decoration: InputDecoration(
                        labelText: "Title",
                        fillColor: const Color.fromRGBO(238, 238, 238, 1),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(238, 238, 238, 1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(238, 238, 238, 1)))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    controller: discriptionEditingController,
                    decoration: InputDecoration(
                        labelText: "Description",
                        fillColor: const Color.fromRGBO(238, 238, 238, 1),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(238, 238, 238, 1))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(238, 238, 238, 1)))),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              print("edit");
                              Navigator.pushNamed(
                                  context, RouteName.homeScreen);
                              notesModel.title = titleEditingController.text
                                ..toString();
                              notesModel.discription =
                                  discriptionEditingController.text.toString();
                              notesModel.save();
                            },
                            child: const Text("OK")),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            onPressed: () {
                              print("cancle");
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class LockCard extends StatelessWidget {
  const LockCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Stack(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.blue.shade500,
            highlightColor: Colors.blue.shade200,
            child: Container(
              width: double.infinity,
              height: 34,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue.shade500),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.lock,
                    size: 16,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Tap to card read the Note",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
