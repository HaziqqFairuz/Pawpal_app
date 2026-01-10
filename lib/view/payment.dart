import 'package:flutter/material.dart';
import 'package:pawpal_app/models/user.dart';
import 'package:pawpal_app/myconfig.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final User user;
  final int credits;
  final String petId; // New parameter

  const PaymentPage({
    super.key, 
    required this.user, 
    required this.credits, 
    required this.petId
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late WebViewController _webcontroller;

  @override
  void initState() {
    super.initState();
    
    final String email = widget.user.userEmail.toString();
    final String phone = widget.user.userPhone.toString();
    final String name = widget.user.userName.toString();
    final String userId = widget.user.userId.toString();

    _webcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/api/payment.php?email=$email&phone=$phone&userid=$userId&name=$name&amount=${widget.credits}&petid=${widget.petId}',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: const Color.fromRGBO(222, 91, 61, 0.941),
        foregroundColor: Colors.white,
      ),
      body: WebViewWidget(controller: _webcontroller),
    );
  }
}