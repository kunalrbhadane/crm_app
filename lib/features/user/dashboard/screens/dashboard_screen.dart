import 'package:crm_app/features/user/dashboard/widgets/dashboardwidget.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
       
        color: const Color(0xFFF4F7FC),
        child: Column(
          children: [
           
            Stack(

              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                
                const WelcomeHeaderWidget(),
                const Positioned(
                  top: 120, 
                  child: StatsCardWidget(),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const ActionButtonsWidget(),
            const SizedBox(height: 20),
            const EnquiriesSectionWidget(),
             const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}