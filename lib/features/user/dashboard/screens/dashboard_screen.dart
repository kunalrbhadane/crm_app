import 'package:crm_app/features/user/dashboard/provider/dashboard_provider.dart';
import 'package:crm_app/features/user/dashboard/widgets/dashboardwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

   @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to safely call provider after the build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch data without causing a rebuild during the build phase
      Provider.of<DashboardProvider>(context, listen: false).fetchDashboardData();
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<DashboardProvider>(context, listen: false).fetchDashboardData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
          children: [

            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Consumer<DashboardProvider>(
                  builder: (context, provider, child) {
                    return WelcomeHeaderWidget(userName: provider.userName);
                  },
                ),
                Positioned(
                  top: 120, // Adjusted position for overlap
                  child: Consumer<DashboardProvider>(
                    builder: (context, provider, child) {
                      return StatsCardWidget(
                        isLoading: provider.isLoading,
                        summary: provider.dashboardSummary,
                      );
                    },
                  ),
                ),
              ],
            ),
            
            // Spacer for the overlapping stats card
            const SizedBox(height: 20),

            const ActionButtonsWidget(),
            //const SizedBox(height: 6),

            const EnquiriesSectionWidget(),
            const SizedBox(height: 60),
          ],
        ),
        ),
      ),
    
    );
  }
}