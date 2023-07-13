import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage2 extends StatelessWidget {
  HomePage2({super.key});

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController textcontroller = TextEditingController();

  Stream<dynamic> showData() {
    return FirebaseFirestore.instance.collection("notes").snapshots();
  }

  Future<void> deldata(String id) async {
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
        title: const Text('Note App'),
        centerTitle: true,
      ),
      body: Column(
        
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: titlecontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(
                    controller: textcontroller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (titlecontroller.text.isEmpty ||
                          textcontroller.text.isEmpty) {
                        return;
                      }
                      Map<String, dynamic> addData = {
                        "title": titlecontroller.text,
                        "text": textcontroller.text
                      };
                      await FirebaseFirestore.instance.collection("notes").add(addData);
                    },
                    child: const Text("Add note"),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: StreamBuilder(
            stream: showData(),
            builder: (context, snapshot) => ListView.builder(
              itemCount: snapshot.data?.size ?? 0,
              itemBuilder: (context, index) {
                return Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.amber.withOpacity(0.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Text(
                              snapshot.data.docs[index]['title'],
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              snapshot.data.docs[index]['text'],
                              style: TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                deldata(snapshot.data!.docs[index].id),
                            icon: const Icon(Icons.delete),
                          ),
                          IconButton(
                            onPressed: () {
                              titlecontroller.text=snapshot.data!.docs[index]['title'];
                              textcontroller.text=snapshot.data!.docs[index]['text'];
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
                                          onPressed: ()=>updateData(snapshot.data!.docs[index].id),
                                          child: const Padding(
                                            padding: EdgeInsets.only(
                                                top: 15, bottom: 15),
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
                            icon: const Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ))
        ],
      ),
    );
  }
}
