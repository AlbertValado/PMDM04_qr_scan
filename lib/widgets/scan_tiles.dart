import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scan/providers/scan_list_provider.dart';
import 'package:qr_scan/utils/utils.dart';

class ScanTiles extends StatelessWidget {
  final String tipus;

  const ScanTiles({Key? key, required this.tipus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;

    return ListView.builder(
        itemCount: scans.length,
        itemBuilder: (_, index) => Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red,
                child: const Align(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.delete_forever),
                  ),
                  alignment: Alignment.centerRight,
                ),
              ),
              onDismissed: (DismissDirection direccio) {
                Provider.of<ScanListProvider>(context, listen: false)
                    .esborraPerId(scans[index].id!);
              },
              child: ListTile(
                leading: Icon(
                  this.tipus == 'http'
                      ? Icons.home_outlined
                      : Icons.map_outlined,
                ),
                title: Text(scans[index].valor),
                subtitle: Text(scans[index].id.toString()),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                ),
                onTap: () {
                  launchUrl(context, scans[index]);
                },
              ),
            ));
  }
}
