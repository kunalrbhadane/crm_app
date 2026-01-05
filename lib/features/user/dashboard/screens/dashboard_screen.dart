import 'package:crm_app/features/user/dashboard/widgets/dashboardwidget.dart';

import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
    return Stack(
      children: [
       
        Container(color: const Color(0xFFF4F7FC)),

        const WelcomeHeaderWidget(),

        SingleChildScrollView(
          child: Column(
            children: [
         
              const SizedBox(height: 120),

              const StatsCardWidget(),
              const SizedBox(height: 40),
              
              const ActionButtonsWidget(),
              const SizedBox(height: 8),
              const EnquiriesSectionWidget(),
            ],
          ),
        ),
      ],
    );
  }
}