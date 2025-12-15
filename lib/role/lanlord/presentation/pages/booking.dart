import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/role/lanlord/presentation/cubit/booking_request/cubit.dart';
import 'package:rentverse/role/lanlord/widget/booking/land_lord_booking_view.dart';

class LandlordBookingPage extends StatelessWidget {
  const LandlordBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: BlocProvider(
        create: (_) => LandlordBookingRequestCubit(sl(), sl(), sl())..load(),
        child: const LandLordBookingView(),
      ),
    );
  }
}
