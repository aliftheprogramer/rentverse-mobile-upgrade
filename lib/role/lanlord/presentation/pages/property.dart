import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/role/lanlord/presentation/cubit/property/cubit.dart';
import 'package:rentverse/role/lanlord/widget/my_property/land_lord_property_view.dart';

class LandlordPropertyPage extends StatelessWidget {
  const LandlordPropertyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LandlordPropertyCubit(sl())..load()),
        ],
        child: const LandLordPropertyView(),
      ),
    );
  }
}
