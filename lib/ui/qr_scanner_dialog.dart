import 'package:flutter/material.dart';
import 'package:kinga/constants/strings.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerDialog extends StatefulWidget {
  const QrScannerDialog({Key? key}) : super(key: key);

  @override
  State<QrScannerDialog> createState() => _QrScannerDialogState();
}

class _QrScannerDialogState extends State<QrScannerDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(Strings.cancel),
        ),
      ],
      //insetPadding: EdgeInsets.all(10),
      contentPadding: const EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            child: MobileScanner(
              allowDuplicates: false,
              controller: MobileScannerController(
                facing: CameraFacing.back,
                //torchEnabled: true,
              ),
              onDetect: (barcode, args) {
                if (barcode.rawValue == null) {
                  // TODO: maybe add error/retry message
                } else {
                  Navigator.of(context).pop(barcode.rawValue);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
