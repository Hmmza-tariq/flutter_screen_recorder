import 'dart:async';
import 'dart:io';

import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EdScreenRecorder? screenRecorder;
  Map<String, dynamic>? _response;
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    screenRecorder = EdScreenRecorder();
  }

  Future<void> startRecord({required String fileName}) async {
    Directory? tempDir = await getDownloadsDirectory();
    String? tempPath = tempDir!.path;
    print(tempPath);
    try {
      var startResponse = await screenRecorder?.startRecordScreen(
        fileName: "Eren",
        dirPathToSave: tempPath,
        audioEnable: true,
      );
      setState(() {
        _response = startResponse;
      });
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while starting the recording!")
          : null;
    }
  }

  Future<void> stopRecord() async {
    try {
      var stopResponse = await screenRecorder?.stopRecord();
      setState(() {
        _response = stopResponse;
      });
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while stopping recording.")
          : null;
    }
  }

  Future<void> pauseRecord() async {
    try {
      await screenRecorder?.pauseRecord();
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while pause recording.")
          : null;
    }
  }

  Future<void> resumeRecord() async {
    try {
      await screenRecorder?.resumeRecord();
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while resume recording.")
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Screen Recording Debug"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("File: ${(_response?['file'] as File?)?.path}"),
            Text("Status: ${(_response?['success']).toString()}"),
            Text("Event: ${_response?['eventname']}"),
            Text("Progress: ${(_response?['progressing']).toString()}"),
            Text("Message: ${_response?['message']}"),
            Text("Video Hash: ${_response?['videohash']}"),
            Text("Start Date: ${(_response?['startdate']).toString()}"),
            Text("End Date: ${(_response?['enddate']).toString()}"),
            ElevatedButton(
                onPressed: () => startRecord(fileName: "eren"),
                child: const Text('START RECORD')),
            ElevatedButton(
                onPressed: () => resumeRecord(),
                child: const Text('RESUME RECORD')),
            ElevatedButton(
                onPressed: () => pauseRecord(),
                child: const Text('PAUSE RECORD')),
            ElevatedButton(
                onPressed: () => stopRecord(),
                child: const Text('STOP RECORD')),
          ],
        ),
      ),
    );
  }
}
