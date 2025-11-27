import 'package:coinly/features/home/ui/widgets/home_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../logic/home_cubit.dart';
import '../../logic/home_state.dart';
import '../widgets/home_header.dart';
import '../widgets/add_worker_banner.dart';
import '../widgets/my_kiosks_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _homeCubit = di.sl<HomeCubit>();
    _homeCubit.loadHome();
  }

  @override
  void dispose() {
    _homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeCubit,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'خطأ: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _homeCubit.loadHome(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Section
                    HomeHeader(
                      ownerData: state is HomeLoaded ? state.ownerData : null,
                    ),
                    const SizedBox(height: 40),
                    HomePoints(
                      ownerData: state is HomeLoaded ? state.ownerData : null,
                    ),

                    const SizedBox(height: 16),
                    AddWorkerBanner(),
                    MyKiosksSection(
                      ownerData: state is HomeLoaded ? state.ownerData : null,
                    ),

                    // Body Content
                    const SizedBox(height: 20),
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
