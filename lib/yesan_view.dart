import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yesan_weather/main.dart';

final yesanKeyProvider = Provider((ref) => GlobalKey());

class YesanView extends ConsumerStatefulWidget {
  const YesanView({super.key});

  @override
  ConsumerState createState() => _YesanViewState();
}

class _YesanViewState extends ConsumerState<YesanView> {
  late InAppWebViewController _webViewController;
  double progress = 0;
  final InAppWebViewSettings _options = InAppWebViewSettings(
    useShouldOverrideUrlLoading: true,
    // URL 로딩 제어
    mediaPlaybackRequiresUserGesture: false,
    // 미디어 자동 재생
    javaScriptEnabled: true,
    // 자바스크립트 실행 여부
    javaScriptCanOpenWindowsAutomatically: true,
    // 팝업 여부
    useHybridComposition: true,
    // 하이브리드 사용을 위한 안드로이드 웹뷰 최적화
    supportMultipleWindows: true,
    // 멀티 윈도우 허용
    allowsInlineMediaPlayback: true, // 웹뷰 내 미디어 재생 허용
  );

  @override
  Widget build(BuildContext context) {
    log.i("가즈아...");
    return Scaffold(
      body: SafeArea(
          child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          log.i("가즈아...");
          if (await _webViewController.canGoBack()) {
            await _webViewController.goBack();
          } else {
            exit(0);
          }
        },
        child: Stack(
          children: [
            InAppWebView(
              key: ref.watch(yesanKeyProvider),
              initialUrlRequest: URLRequest(url: WebUri("https://yesanweather.kr/")),
              initialSettings: _options,
              onLoadStop: (InAppWebViewController controller, uri) {
                log.i("onLoadStop $uri");
              },
              onLoadStart: (InAppWebViewController controller, uri) {
                log.i("onLoadStart $uri");
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url!;

                log.i("shouldOverrideUrlLoading $uri");

                return NavigationActionPolicy.ALLOW;
              },
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              onProgressChanged: (controller, progress) {

                setState(() {
                  this.progress = progress / 100;
                });
              },
            ),

            progress < 1.0
                ? LinearProgressIndicator(value: progress)
                : Container(),
          ],
        ),
      )),
    );
  }
}
