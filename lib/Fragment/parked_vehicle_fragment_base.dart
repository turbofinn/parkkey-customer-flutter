import 'package:flutter/material.dart';
import 'package:parkey_customer/Fragment/parked_vehicles_fragment.dart';

import 'dedicated_history_fragment.dart';

class ParkedVehicleFragmentBase extends StatefulWidget {
  const ParkedVehicleFragmentBase({super.key});

  @override
  State<ParkedVehicleFragmentBase> createState() => _ParkedVehicleFragmentBaseState();
}

class _ParkedVehicleFragmentBaseState extends State<ParkedVehicleFragmentBase> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        // Determine the screen to display based on the route name
        switch (settings.name) {
          case '/':
            builder = (BuildContext _) => ParkedFragment();
            break;
          case '/DedicatedHistoryFragment':
            builder = (BuildContext _) => DedicatedHistoryFragment(parkingTicketID: settings.arguments as String,);
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
