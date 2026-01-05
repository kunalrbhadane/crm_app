import 'package:crm_app/features/user/dashboard/widgets/dashboardwidget.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                const HeaderWidget(),
                
                Positioned(
                  top: 200,
                  child: const StatsCardWidget(),
                ),
              ],
            ),
            const SizedBox(height: 20), 

            const ActionButtonsWidget(),
            const SizedBox(height: 6),

            const EnquiriesSectionWidget(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }
}