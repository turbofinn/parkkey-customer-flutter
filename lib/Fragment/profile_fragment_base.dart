import 'package:flutter/material.dart';
import 'package:parkey_customer/Fragment/ProfileFragment.dart';
import 'package:parkey_customer/Fragment/add_vehicle_fragment.dart';

class ProfileFragmentBase extends StatefulWidget {
  BuildContext context;
  ProfileFragmentBase({required this.context,super.key});

  @override
  State<ProfileFragmentBase> createState() => _ProfileFragmentBaseState();
}

class _ProfileFragmentBaseState extends State<ProfileFragmentBase> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        // Determine the screen to display based on the route name
        switch (settings.name) {
          case '/':
            builder = (BuildContext _) => ProfileFragment(context: widget.context,);
            break;
          case '/AddVehicle':
            builder = (BuildContext _) => AddVehicleFragment(
            );
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
