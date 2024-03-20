import 'package:flutter/widgets.dart';
import 'package:qr_scan/providers/db_provider.dart';

import '../models/scan_model.dart';

//Intermediaria entre la BD i els widgets
class ScanListProvider extends ChangeNotifier{

  List<ScanModel> scans = [];
  String tipusSeleccionat = 'http';

  Future<ScanModel> nouScan(String valor) async {
    final nouScan = ScanModel(valor: valor);
    final id = await DBProvider.db.insertScan(nouScan);
    nouScan.id = id;

    if(nouScan.tipus == tipusSeleccionat){
      this.scans.add(nouScan);
      notifyListeners();
    }

    return nouScan;
  }

  carregaScans() async {
    final scans = await DBProvider.db.getAllScans();
    this.scans = [...scans];
    notifyListeners();
  }

  //TODO: implementar
  carregarScansPerTipus(String tipus) async {
    final scans = await DBProvider.db.getScanByTipus(tipus);
    this.scans = [...scans];
    this.tipusSeleccionat = tipus;
    notifyListeners();
  }

  esborraTots() async {
    final scans = await DBProvider.db.deleteAllScans();
    this.scans = [];
    notifyListeners();
  }

  //Només esborra un en concret
  esborraPerId(int id) async {

  }
}