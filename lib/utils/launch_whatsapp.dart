import 'package:url_launcher/url_launcher.dart';

Future<void> launchWhatsApp({
  required String phone,
  required String message,
}) async {
  final Uri whatsappUrl = Uri.parse(
    'https://wa.me/$phone?text=${Uri.encodeQueryComponent(message)}',
  );

  if (await canLaunchUrl(whatsappUrl)) {
    await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $whatsappUrl';
  }
}
