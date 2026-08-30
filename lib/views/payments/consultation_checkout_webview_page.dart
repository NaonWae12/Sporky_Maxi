import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ConsultationCheckoutResult {
  final bool isCompleted;
  final String? transactionUuid;

  const ConsultationCheckoutResult({
    required this.isCompleted,
    this.transactionUuid,
  });
}

class ConsultationCheckoutWebviewPage extends StatefulWidget {
  final String checkoutUrl;

  const ConsultationCheckoutWebviewPage({super.key, required this.checkoutUrl});

  @override
  State<ConsultationCheckoutWebviewPage> createState() =>
      _ConsultationCheckoutWebviewPageState();
}

class _ConsultationCheckoutWebviewPageState
    extends State<ConsultationCheckoutWebviewPage> {
  bool _isLoading = true;

  void _completeNavigation(String url) {
    final uri = Uri.parse(url);
    final isHistoryPage = uri.path.contains('/history');

    if (isHistoryPage) {
      Navigator.of(context).pop(
        ConsultationCheckoutResult(
          isCompleted: true,
          transactionUuid: uri.queryParameters['transaction_uuid'],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        leading: IconButton(
          onPressed: () => Navigator.of(
            context,
          ).pop(const ConsultationCheckoutResult(isCompleted: false)),
          icon: const Icon(Icons.close),
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.checkoutUrl)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              supportZoom: false,
            ),
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
              });
              _completeNavigation(url.toString());
            },
            onLoadStop: (controller, url) {
              setState(() {
                _isLoading = false;
              });
              _completeNavigation(url.toString());
            },
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
