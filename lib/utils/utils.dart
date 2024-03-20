import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/scan_model.dart';


void launchUrl(BuildContext context, ScanModel scan) async {
  final url = scan.valor;
  if(scan.tipus == 'http'){
    if (!await launch(url)) throw Exception('Could not launch $url');
  } else {
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }


}