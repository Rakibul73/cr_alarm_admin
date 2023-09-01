import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

class PostHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


void main() {
  HttpOverrides.global = new PostHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CR Alarm Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CR Alarm Admin Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  TextEditingController inputController = TextEditingController();

  Future<void> sendPostRequestWithData(BuildContext context , String input) async {
    final url = Uri.parse('https://tuimorsala.pythonanywhere.com/add_data?input=$input');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        width: 300,
        headerAnimationLoop: false,
        animType: AnimType.topSlide,
        title: 'Success',
        desc: 'Alarm will be set in 10 minutes',
        dismissOnTouchOutside: true,
        autoHide: const Duration(seconds: 3), // Auto hide after 3 seconds
      ).show();
    } 
    else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        width: 300,
        headerAnimationLoop: false,
        animType: AnimType.topSlide,
        title: 'Error',
        desc: 'Failed to send alarm request. Status code: ${response.statusCode}',
        dismissOnTouchOutside: true,
        autoHide: const Duration(seconds: 3), // Auto hide after 3 seconds
      ).show();
    }
  }

  Future<void> sendPostRequest(BuildContext context) async {
    final url = Uri.parse('https://tuimorsala.pythonanywhere.com/add_data_get');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        width: 300,
        headerAnimationLoop: false,
        animType: AnimType.topSlide,
        title: 'Success',
        desc: 'Alarm will be set in 10 minutes',
        dismissOnTouchOutside: true,
        autoHide: const Duration(seconds: 3), // Auto hide after 3 seconds
      ).show();
    } 
    else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        width: 300,
        headerAnimationLoop: false,
        animType: AnimType.topSlide,
        title: 'Error',
        desc: 'Failed to send alarm request. Status code: ${response.statusCode}',
        dismissOnTouchOutside: true,
        autoHide: const Duration(seconds: 3), // Auto hide after 3 seconds
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text('CR Alarm Admin'),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: inputController,
              decoration: const InputDecoration(
                hintText: 'Enter text to send',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String inputText = inputController.text;
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2,
                  ),
                  width: 300,
                  buttonsBorderRadius: const BorderRadius.all(
                    Radius.circular(25),
                  ),
                  dismissOnTouchOutside: false,
                  dismissOnBackKeyPress: false,
                  headerAnimationLoop: true,
                  animType: AnimType.bottomSlide,
                  title: 'Is the message Correct?',
                  desc: 'You are sending some message. it will display in students app',
                  showCloseIcon: false,
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {sendPostRequestWithData(context , inputText);},
                  buttonsTextStyle: const TextStyle(color: Colors.black),
                  reverseBtnOrder: true,
                ).show();
              },
              child: const Text('Send POST with Data'),
            ),
            ElevatedButton(
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.question,
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2,
                  ),
                  width: 300,
                  buttonsBorderRadius: const BorderRadius.all(
                    Radius.circular(25),
                  ),
                  dismissOnTouchOutside: false,
                  dismissOnBackKeyPress: false,
                  headerAnimationLoop: true,
                  animType: AnimType.bottomSlide,
                  title: 'Only Alarm?',
                  desc: 'You are not sending any message.',
                  showCloseIcon: false,
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {sendPostRequest(context);},
                  buttonsTextStyle: const TextStyle(color: Colors.black),
                  reverseBtnOrder: true,
                ).show();
              },
              child: const Text('Send POST Directly'),
            ),
          ],
        ),
      ),
    );
  }
}
