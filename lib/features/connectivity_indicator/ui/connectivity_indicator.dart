import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/features/connectivity_indicator/connection_status_singleton.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ConnectivityIndicator extends StatefulWidget {

  late var child;

  ConnectivityIndicator({Key? key, required Widget this.child}) {
    //super(key: key);
    if (key == null) {
      key = UniqueKey();
    }
  }

  @override
  State<ConnectivityIndicator> createState() => _ConnectivityIndicatorState();
}

class _ConnectivityIndicatorState extends State<ConnectivityIndicator> {

  bool isOffline = !ConnectionStatusSingleton.getInstance().hasConnection;

  late var _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = ConnectionStatusSingleton.getInstance().connectionChange.listen((hasConnection) {
      setState(() {
        isOffline = !hasConnection;
      });
    });
  }

  /*
  Future<void> initConnectivityListener() async {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {

        connectivity = result;
      });
    });
    setState(() async {
      connectivity = await(Connectivity().checkConnectivity());
    });
  }

   */

  @override
  void dispose() {
    //_connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          widget.child,
          if (isOffline) SimpleShadow(
            opacity: 0.2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: ColorSchemes.errorColor,
              ),
              height: 40.0,
              width: 270.0,
              margin: EdgeInsets.symmetric(vertical: AppBar().preferredSize.height / 2 + MediaQuery.of(context).viewPadding.top - 40.0 / 2),
              //padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(padding: EdgeInsets.only(right: 8.0), child: Icon(Icons.signal_wifi_bad, color: Colors.white,)),
                    Text(
                      Strings.errorConnectivity,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}