import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController textcontroller = TextEditingController();

  Future<void> dataInput() async {
    if (titlecontroller.text.isEmpty || textcontroller.text.isEmpty) {
      return;
    }
    Map<String, dynamic> noteData = {
      "title": titlecontroller.text,
      "text": textcontroller.text,
    };
    await FirebaseFirestore.instance.collection("notes").add(noteData);
  }

  Stream<dynamic> showData() {
    return FirebaseFirestore.instance.collection("notes").snapshots();
  }

  Future<void> deletData(String id) async {
    await FirebaseFirestore.instance.collection("notes").doc(id).delete();
  }

  Future<void> updateData(String id) async {
    Map<String, dynamic> addData = {
      "title": titlecontroller.text,
      "text": textcontroller.text
    };
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(id)
        .update(addData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.withOpacity(0.7),
        title: const Text("Note app"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: showData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Data Error");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Data Loding");
            }
            return ListView.builder(
              itemCount: snapshot.data?.size ?? 0,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data?.docs[index]["title"],
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              snapshot.data?.docs[index]["text"],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  deletData(snapshot.data!.docs[index].id),
                              icon: const Icon(Icons.delete),
                            ),
                            IconButton(
                              onPressed: () {
                                titlecontroller.text =
                                    snapshot.data!.docs[index]['title'];
                                textcontroller.text =
                                    snapshot.data!.docs[index]['text'];
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) => Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    color: Colors.deepPurple.withOpacity(0.3),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: titlecontroller,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter Title Here',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          TextField(
                                            controller: textcontroller,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter Text Here',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          ElevatedButton(
                                            onPressed: () => updateData(
                                                snapshot.data!.docs[index].id),
                                            child: const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 15, bottom: 15),
                                              child: Text(
                                                'Update Note',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  barrierColor: Colors.transparent,
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple.withOpacity(0.1),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.deepPurple.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: titlecontroller,
                      decoration: const InputDecoration(
                        hintText: 'Enter Title Here',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextField(
                      controller: textcontroller,
                      decoration: const InputDecoration(
                        hintText: 'Enter Text Here',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                      onPressed: dataInput,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: Text(
                          'Add Note',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            barrierColor: Colors.transparent,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
