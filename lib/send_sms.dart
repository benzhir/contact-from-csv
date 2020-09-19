import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:sms/sms.dart';

class SendSms extends StatefulWidget {
  final List<String> recipents;

  const SendSms({Key key, @required this.recipents}) : super(key: key);
  @override
  _SendSmsState createState() => _SendSmsState();
}

class _SendSmsState extends State<SendSms> {
  final _formKey = GlobalKey<FormState>();
  bool _validator = false;
  String messageValue = '';


  void _sendSMS() async {
    var future = await showLoadingDialog();
    SmsSender sender = new SmsSender();
    widget.recipents.forEach((element)  {
      sender.sendSms(new SmsMessage(element, messageValue));
    });
    future.dismiss();
    showAlertDialog(context, 'Success', 'le message a été envoyé aux (${widget.recipents.length}) contacts');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.recipents.length} Contacts'),
      ),
      body: Form(
        key: _formKey,
        autovalidate: _validator,
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  minLines: 10,
                  maxLines: 15,
                  maxLength: 160,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Write your message here',
                    filled: true,
                    fillColor: Color(0xFFDBEDFF),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value) => messageValue = value,
                ),
              ),
            ),
            SizedBox(height: 16,),
            RaisedButton(onPressed: (){
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                _sendSMS();
              }else {
//    If all data are not valid then start auto validation.
                setState(() {
                  _validator = true;
                });
              }
            },
            child: Text("Send message"),)
          ],
        ),
      ),
    );
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
