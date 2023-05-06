import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:l_notes_app/screens/note_editor.dart';
import 'package:l_notes_app/screens/note_reader.dart';
import 'package:l_notes_app/style/style.dart';
import 'package:l_notes_app/widgets/note_card.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppStyle.mainColor,
        appBar: AppBar(
          title: Text('Notes'),
          centerTitle: true,
          elevation: 12,
          backgroundColor: AppStyle.accentColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Notes',
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),

              //ab hum ek streambuilder banaynge kyukki hme show karna h note cards toh uske liye hme constantly pata hona
              //chhaiye ki cloud m kya data h. toh ye stream builder lagatar data recieve karta rahagea
              //and isime hum ek gridview bannadenge

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('notes')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
                        children: snapshot.data!.docs.map((note)=>noteCard(() => {Navigator.push(context, MaterialPageRoute(builder: (context)=>note_reader(note)))}, note)).toList(),

                      );
                    }
                    return Text(
                      'No Notes Found, Create one',
                      style: GoogleFonts.nunito(color: Colors.white),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>note_editor()));}, label: Text('Add a Note'),icon: Icon(Icons.add),),
      ),
    );
  }
}
