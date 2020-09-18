import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactModelList extends StatefulWidget {
  final String path;

  const ContactModelList({Key key, this.path}) : super(key: key);
  @override
  _ContactModelListState createState() => _ContactModelListState();
}

class _ContactModelListState extends State<ContactModelList> {
  List<ContactModel> data = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    tt();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Load and View Csv data'),
        actions: [
          Row(
            children: [
              data.length > 0 ?
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(icon: Icon(Icons.add_call, color: Colors.white,), onPressed: () => addAllContacts()),
              )
              : Container(),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading ? Center(child: CircularProgressIndicator())
        : data.length > 0
            ? ListView(
          children: data
              .map(
                (row) => Card(
                  child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(row.name),
                        SizedBox(
                          height: 4,
                        ),
                        Text(row.phone),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(icon: Icon(Icons.call, color: Colors.grey,), onPressed: () => _launchURL('tel:0651658469')),
                      ],
                    )
                    //Coach
                  ],
              ),
            ),
                ),
          )
              .toList(),
        ) : Center(child: Text("Empty data"),),
      ),
    );
  }

  Future<void> addAllContacts() async {
    data.forEach((element) async {
      await Contacts.addContact(new Contact(
        familyName: element.name,
        phones: [new Item(
            value: element.phone
        )],
      ));
    });
    showAlertDialog(context, 'Success', '${data.length} Contacts ont été créés');
  }

  void tt() {

    setState(() {
      _loading = true;
    });
    final File file = new File(widget.path);

    Stream<List> inputStream = file.openRead();

    inputStream
        .transform(utf8.decoder)       // Decode bytes to UTF-8.
        .transform(new LineSplitter()) // Convert stream to individual lines.
        .listen((String line) {        // Process results.
      List row = line.split(','); // split by comma
      data.add(new ContactModel(row[0], row[1]));
    },
        onDone: () { print('File is now closed. ${data.length}');    setState(() {
          _loading = false;
        }); },
        onError: (e) {
          showAlertDialog(context, 'Error', 'Error loading data');
          print(e.toString());
          setState(() {
          _loading = false;
        });

        });
  }

  showAlertDialog(BuildContext context, String text, String content) {

    Widget continueButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("$text"),
      content: Text("$content"),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class ContactModel {
  String name;
  String phone;

  ContactModel(this.name, this.phone);
}
