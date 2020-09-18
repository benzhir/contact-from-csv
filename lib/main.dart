import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'contact_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
       
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AttachCsvFile(),
    );
  }
}

class AttachCsvFile extends StatefulWidget {
  @override
  _AttachCsvFileState createState() => _AttachCsvFileState();
}

class _AttachCsvFileState extends State<AttachCsvFile> {

  Future<void> _askPermissions() async {
    final permissionStatus = await _getContactPermission();
    if (permissionStatus != PermissionStatus.granted) {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    final status = await Permission.contacts.status;
    if (!status.isGranted && !status.isPermanentlyDenied) {
      final result = await Permission.contacts.request();
      return result ?? PermissionStatus.undetermined;
    } else {
      return status;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: 'PERMISSION_DENIED',
          message: 'Access to location data denied',
          details: null);
    } else if (permissionStatus == PermissionStatus.restricted) {
      throw PlatformException(
          code: 'PERMISSION_DISABLED',
          message: 'Location data is not available on device',
          details: null);
    }
  }

  @override
  void initState() {
    _askPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: RaisedButton(
              onPressed: () => _attachCsv(),
          child: Text("Joindre un fichier csv"),),
        ),
      ),
    );
  }

  Future<void> _attachCsv() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      //allowedExtensions: ['csv', 'pdf'],
      allowMultiple: false
    );
    if(result != null){
      var path =  result.files.first.path;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactModelList(path: path,)),
      );
    }else{
      print("Error");
    }
  }

}

