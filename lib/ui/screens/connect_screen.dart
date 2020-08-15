import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:jukebox_application/ui/screen_controllers/connect_screen_controller.dart';
import 'package:jukebox_application/ui/screens/reusable/fiield_button.dart';
import 'package:jukebox_application/utils/constants.dart';
import 'package:jukebox_application/utils/server_location_utils.dart';
import 'package:jukebox_application/utils/utils.dart';

class ConnectScreen extends StatefulWidget {
  @override
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  BuildContext context;

  bool _first = true;
  TextEditingController _serverCodeController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    if (_first) {}
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Builder(builder: (buildContext) {
          this.context = buildContext;
          return buildBody();
        }),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _serverCodeController,
        ),
        FilledButton(
          onCLick: () {
            startScan();
          },
          text: "next Screen",
          colorFill: Colors.red,
        ),
      ],
    );
  }

  startScan() async {
//    var result = await BarcodeScanner.scan();
//    if (result != null &&
//        result.rawContent != null &&
//        result.rawContent.isNotEmpty) {
//
//    }
    String serverCode = _serverCodeController.text;
    ConnectScreenController().getServerLocations(serverCode, (responseModel) {
      if (responseModel != null) {
        if (responseModel.error != null) {
          showSnackBar(context, responseModel.error);
        } else {
          ServerLocationsUtils.IP_ADDRESS = responseModel.response.location;
          Navigator.of(context).pushNamed(Constants.ROUTE_MUSIC_SCREEN);
        }
      }
    });
  }
}
