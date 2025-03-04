import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWithLoader extends StatefulWidget {
  @override
  _WebViewWithLoaderState createState() => _WebViewWithLoaderState();
}

class _WebViewWithLoaderState extends State<WebViewWithLoader> {
  late final WebViewController webViewController; // Контроллер WebView
  bool isLoading = true; // Флаг для отображения лоадера

  @override
  void initState() {
    super.initState();
    // Инициализация WebViewController
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Включение JavaScript
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true; // Показывать лоадер при начале загрузки
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false; // Убрать лоадер после завершения загрузки
            });
          },
          onWebResourceError: (error) {
            // Обработка ошибок загрузки
            print("Error loading page: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse("https://mixgame.fruitmixer.click/3nT6vV")); // URL для загрузки
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Фон экрана
      body: Stack(
        children: [
          // WebView
          WebViewWidget(controller: webViewController),
          // Лоадер
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
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}