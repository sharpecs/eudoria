import 'package:eudoria/src/views/observation_view.dart';
import 'package:flutter/material.dart';
import 'package:eudoria/src/app_controller.dart';
import 'package:eudoria/src/app_router.dart';

class AppRadbar extends StatelessWidget {
  const AppRadbar({
    required this.controller,
    Key? key,
  }) : super(key: key);

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => {null},
                child: const Text(
                  ' ',
                  // style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              InkWell(
                onTap: () => controller.routerIndex = LandingView.viewIndex,
                child: const Text(
                  'Home',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Divider(
                  color: Colors.blueGrey.shade400,
                  thickness: 2,
                ),
              ),
              InkWell(
                onTap: () => controller.routerIndex = ObservationView.viewIndex,
                child: const Text(
                  'Observations',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Divider(
                  color: Colors.blueGrey.shade400,
                  thickness: 2,
                ),
              ),
              InkWell(
                onTap: () => controller.routerIndex = SettingsView.viewIndex,
                child: const Text(
                  'Settings',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    ' ',
                    style: TextStyle(
                      color: Colors.blueGrey.shade300,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
