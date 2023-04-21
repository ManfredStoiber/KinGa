import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/strings.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShowInstitutionQrCodeScreen extends StatelessWidget {

  final String _institutionId;
  final String _institutionPassword;

  const ShowInstitutionQrCodeScreen(this._institutionId, this._institutionPassword, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? confirmed = await showDialog(context: context, builder: (context) => AlertDialog(
          title: const Text(Strings.institutionCredentialsConfirm),
          actions: [
            TextButton(onPressed: () => context.pop(false), child: const Text(Strings.cancel)),
            TextButton(onPressed: () => context.pop(true), child: const Text(Strings.next)),
          ],
        ),);
        if (confirmed == true) {
          return true;
        }
        return false;
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 2, child: Container()),
            Container(padding: const EdgeInsets.all(8.0), child: const Text(textAlign: TextAlign.center, Strings.institutionCredentialsHint)),
            Expanded(flex: 1, child: Container()),
            Container(
              margin: const EdgeInsets.all(32),
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
              child: Column(
                children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0), child: QrImage(data: json.encode({Keys.institutionId: _institutionId, Keys.institutionPassword: _institutionPassword}))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            style: TextStyle(fontSize: 20),
                            "${Strings.institutionId}: ",
                        ),
                        Text(
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          _institutionId,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            style: TextStyle(fontSize: 20),
                            "${Strings.password}: ",
                        ),
                        Text(
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          _institutionPassword,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(flex: 1, child: Container()),
            Container(padding: const EdgeInsets.all(8.0), child: const Text(textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold), Strings.institutionCredentialsWarning)),
            Expanded(flex: 1, child: Container()),
          ]
        ),
        bottomNavigationBar: ButtonBar(
          alignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () async {
                await showDialog(context: context, builder: (context) => AlertDialog(
                  title: const Text(Strings.institutionCredentialsConfirm),
                  actions: [
                    TextButton(onPressed: () => context.pop(false), child: const Text(Strings.cancel)),
                    TextButton(onPressed: () => context.pop(true), child: const Text(Strings.next)),
                  ],
                ),).then((confirmed) {
                  if (confirmed == true) {
                    context.pop();
                  }
                  return null;
                });
              },
              child: const Text(Strings.next),
            ),
          ],
        ),
      ),
    );
  }
}
