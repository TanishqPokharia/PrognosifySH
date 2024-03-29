import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

final medicalReportSummaryProvider =
    StateNotifierProvider<SummarizedDataNotifier, Widget>((ref) {
  return SummarizedDataNotifier();
});

class MedicalReportSummarizer extends ConsumerWidget {
  MedicalReportSummarizer({super.key});

  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Medical Report Summarizer"),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(mq(context, 20)),
                  width: double.infinity,
                  child: TextButton(
                    style: ButtonStyle(
                        padding: MaterialStatePropertyAll(
                            EdgeInsets.all(mq(context, 20)))),
                    onPressed: () {
                      ref
                          .read(medicalReportSummaryProvider.notifier)
                          .fetchReportSummary();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.attach_file),
                        SizedBox(
                          width: mq(context, 10),
                        ),
                        Text(
                          "Select File",
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.all(mq(context, 20)),
                    width: MediaQuery.of(context).size.width,
                    child: ref.watch(medicalReportSummaryProvider))
              ],
            ),
          ),
        ));
  }
}

class SummarizedDataNotifier extends StateNotifier<Widget> {
  SummarizedDataNotifier()
      : super(Text("Upload a medical report to get its summary"));

  Future<void> fetchReportSummary() async {
    //pick pdf file from device
    FilePickerResult? pickerResult = await FilePicker.platform
        .pickFiles(allowedExtensions: ['pdf'], type: FileType.custom);
    if (pickerResult != null) {
      //upload the file to api
      String filepath = pickerResult.files.single.path!;
      print(filepath);
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filepath,
            filename: "MedicalReport.pdf")
      });

      try {
        state = CircularProgressIndicator();
        Response response = await dio.post(
          "https://prognosifyassistantchatapi.onrender.com/reportAI",
          data: formData,
        );

        if (response.statusCode == 200) {
          print(response.data);

          final Map<String, dynamic> result = jsonDecode(response.data);
          String summary = result["Summary"]!;
          String insights = result["Insights"]!;
          // print(result);
          // print(summary);
          // print(insights);
          state = Text(summary + insights);
        } else {
          state = Text("Some error occured, please try again later");
        }
      } catch (error) {
        print(error);
        state = Text("Some error occured, please try again later");
      }
    } else {
      state = Text("Could not pick file");
    }
  }
}
