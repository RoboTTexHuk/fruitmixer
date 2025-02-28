import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:progress_bar_countdown/progress_bar_countdown.dart';




class WebViewWithLoader extends StatefulWidget {
  @override
  _WebViewWithLoaderState createState() => _WebViewWithLoaderState();
}

class _WebViewWithLoaderState extends State<WebViewWithLoader> {
  late InAppWebViewController webViewController;
  bool isLoading = true; // Показывать лоадер пока страница загружается
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Фон экрана
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://mixgame.fruitmixer.click/3nT6vV"), // URL для загрузки
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onProgressChanged: (controller, progressValue) {
              setState(() {
                progress = progressValue / 100;
                if (progress == 1.0) {
                  isLoading = false; // Убираем лоадер, когда страница загружена
                }
              });
            },
          ),
          if (isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Loading...",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ProgressBarCountdown(
                      initialDuration: Duration(seconds: 60),
                      progressColor: Colors.blue,
                      progressBackgroundColor: Colors.grey[300]!,
                      initialTextColor: Colors.black,
                      revealedTextColor: Colors.white,
                      height: 40,
                      textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      countdownDirection: ProgressBarCountdownAlignment.left,
                      controller: ProgressBarCountdownController(),
                      autoStart: true,
                      onComplete: () {
                        print('Countdown Completed');
                      },
                      onStart: () {
                        print('Countdown Started');
                      },
                      onChange: (String timeStamp) {
                        print('Countdown Changed $timeStamp');
                      },
                      timeFormatter: (Duration remainingTime) {
                        final minutes = remainingTime.inMinutes
                            .remainder(60)
                            .toString()
                            .padLeft(2, '0');
                        final seconds = remainingTime.inSeconds
                            .remainder(60)
                            .toString()
                            .padLeft(2, '0');
                        final milliseconds = (remainingTime.inMilliseconds % 1000 ~/ 10)
                            .toString()
                            .padLeft(2, '0');
                        return '$minutes:$seconds:$milliseconds';
                      }
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}