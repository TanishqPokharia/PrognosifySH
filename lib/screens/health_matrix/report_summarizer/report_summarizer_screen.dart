import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

final medicalReportSummaryProvider =
    StateNotifierProvider<SummarizedDataNotifier, String>((ref) {
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
                ElevatedButton(
                    onPressed: () {
                      ref
                          .read(medicalReportSummaryProvider.notifier)
                          .fetchReportSummary();
                    },
                    child: Text("Select File")),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.all(mq(context, 20)),
                  width: MediaQuery.of(context).size.width,
                  height: mq(context, 1300),
                  child: MarkdownBody(
                    data: ref.watch(medicalReportSummaryProvider),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class SummarizedDataNotifier extends StateNotifier<String> {
  SummarizedDataNotifier()
      : super("Upload a medical report to get its summary");

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
        state = "Loading...";
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
          state = summary + insights;
        } else {
          state = "Some error occured, please try again later";
        }
      } catch (error) {
        print(error);
        state = "Some error occured, please try again later";
      }
    } else {
      state = "Could not pick file";
    }
  }
}
