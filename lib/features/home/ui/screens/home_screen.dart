import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/utils/constants.dart';
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
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString(AppConstants.accessToken);
      
      if (accessToken != null && accessToken.isNotEmpty) {
        final authorization = 'Bearer $accessToken';
        _homeCubit.getOwnerMe(authorization);
      } else {
        print('❌ No access token found in storage');
      }
    } catch (e) {
      print('❌ Error in _loadHomeData: $e');
    }
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
        backgroundColor: const Color(0xFFF5F5F5),
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
                        onPressed: _loadHomeData,
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
                    HomeHeader(ownerData: state is HomeLoaded ? state.ownerData : null),
                    AddWorkerBanner(),
                    MyKiosksSection(ownerData: state is HomeLoaded ? state.ownerData : null),

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
