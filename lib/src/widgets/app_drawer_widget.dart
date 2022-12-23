import 'package:eudoria/src/app_builder.dart';
import 'package:flutter/material.dart';
import 'package:eudoria/src/app_controller.dart';
import 'package:eudoria/src/app_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    required this.controller,
    Key? key,
  }) : super(key: key);

  final AppController controller;

  Drawer appDrawer(context) => Drawer(
      backgroundColor: AppStyler.themeData(context).primaryColorLight,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: SizedBox(
              // height: 500,
              width: double.infinity,
              child: Image.asset(
                'assets/images/eudoria_logo.png',
                // fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  onTap: () =>
                      controller.routerIndex = ObservationView.viewIndex,
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
                  onTap: () => controller.routerIndex = SpeciesView.viewIndex,
                  child: const Text(
                    'Species',
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
                  onTap: () => controller.routerIndex = MapView.viewIndex,
                  child: const Text(
                    'Map',
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  ),
                ),
                if (controller.accessManager.authToRecord) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Divider(
                      color: Colors.blueGrey.shade400,
                      thickness: 2,
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        controller.routerIndex = SettingsView.viewIndex,
                    child: const Text(
                      'Settings',
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                  ),
                ],
                // if (!controller.accessManager.authToRecord) ...[
                //   Padding(
                //     padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                //     child: Divider(
                //       color: Colors.blueGrey.shade400,
                //       thickness: 2,
                //     ),
                //   ),
                //   InkWell(
                //     onTap: () =>
                //         controller.routerIndex = SettingsView.viewIndex,
                //     child: const Text(
                //       'Sign Up',
                //       style: TextStyle(color: Colors.black, fontSize: 22),
                //     ),
                //   ),
                //   Padding(
                //     padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                //     child: Divider(
                //       color: Colors.blueGrey.shade400,
                //       thickness: 2,
                //     ),
                //   ),
                //   InkWell(
                //     onTap: () =>
                //         controller.routerIndex = SettingsView.viewIndex,
                //     child: const Text(
                //       'Donate',
                //       style: TextStyle(color: Colors.black, fontSize: 22),
                //     ),
                //   ),
                // ],
              ]),
        ],
      ));

  @override
  Widget build(BuildContext context) {
    return appDrawer(context);
  }
}
