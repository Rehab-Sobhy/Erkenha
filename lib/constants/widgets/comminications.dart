import 'package:url_launcher/url_launcher.dart';

class CommunicationHelper {
  Future<void> openWhatsApp(String phone, String message) async {
    final Uri url =
        Uri.parse("https://wa.me/$phone?text=${Uri.encodeFull(message)}");

    launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> sendEmail(String to, String subject, String body) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: to,
      query: Uri.encodeFull('subject=$subject&body=$body'),
    );

    if (!await launchUrl(emailUri)) {
      throw 'Could not launch email';
    }
  }
}
