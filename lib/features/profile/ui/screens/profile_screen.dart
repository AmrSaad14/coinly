import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../home/logic/home_cubit.dart';
import '../../../home/logic/home_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/profile_menu_list.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<HomeCubit>()..loadHome(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final ownerData = state is HomeLoaded ? state.ownerData : null;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const ProfileHeader(),
                    const SizedBox(height: 16),
                    ProfileInfoCard(name: ownerData?.fullName ?? ''),
                    StatsCard(
                      employeeCount: ownerData?.workersCount ?? 0,
                      totalSales: (ownerData?.profits ?? 0).toDouble(),
                      balance: (ownerData?.points ?? 0).toDouble(),
                    ),
                    const SizedBox(height: 8),
                    const ProfileMenuList(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
