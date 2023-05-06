import 'dart:math';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:l_notes_app/style/style.dart';
import 'dart:math';

class note_editor extends StatefulWidget {
  const note_editor({Key? key}) : super(key: key);

  @override
  State<note_editor> createState() => _note_editorState();
}

class _note_editorState extends State<note_editor> {
  int color_id = Random().nextInt(AppStyle.cardsColor.length);
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String date = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[color_id],
        title: Text('New Note'),
        elevation: 0,
      ),
      backgroundColor: AppStyle.cardsColor[color_id],
      body: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Title',
            ),
            style: AppStyle.mainTitle,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            date,
            style: AppStyle.dateTitle,
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: TextField(
              controller: contentController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Content',
              ),
              style: AppStyle.mainContent,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FirebaseFirestore.instance.collection('notes').add(
            {
              "note_title": titleController.text,
              "creation_date": date,
              "note_content": contentController.text,
              "color_id": color_id,
            },
          ).then((value) {print(value.id); Navigator.pop(context);}).catchError((error)=>print('Failed to save notes: $error'));
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
