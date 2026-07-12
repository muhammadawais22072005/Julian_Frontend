import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:julian_medical_center/presentation/theme/app_theme.dart';
import 'package:julian_medical_center/presentation/widgets/responsive_builder.dart';
import 'package:julian_medical_center/providers/auth_provider.dart';
import 'package:julian_medical_center/presentation/screens/landing_screen.dart';
import 'package:julian_medical_center/presentation/screens/dashboard_view.dart';
import 'package:julian_medical_center/presentation/screens/patients_view.dart';
import 'package:julian_medical_center/presentation/screens/doctors_view.dart';
import 'package:julian_medical_center/presentation/screens/appointments_view.dart';
import 'package:julian_medical_center/presentation/screens/records_view.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  String _activeTab = 'dashboard';

  final List<Map<String, dynamic>> _menuItems = [
    {'id': 'dashboard', 'label': 'Dashboard', 'icon': LucideIcons.layoutDashboard},
    {'id': 'appointments', 'label': 'Appointments', 'icon': LucideIcons.calendar},
    {'id': 'patients', 'label': 'Patients', 'icon': LucideIcons.users},
    {'id': 'doctors', 'label': 'Doctors', 'icon': LucideIcons.userCog},
    {'id': 'records', 'label': 'Records', 'icon': LucideIcons.fileText},
  ];

  Widget _buildActiveView() {
    switch (_activeTab) {
      case 'dashboard':
        return const DashboardView();
      case 'patients':
        return const PatientsView();
      case 'doctors':
        return const DoctorsView();
      case 'appointments':
        return const AppointmentsView(isModal: false);
      case 'records':
        return const RecordsView();
      default:
        return const Center(child: Text("Coming Soon"));
    }
  }

  void _signOut(BuildContext context) {
    ref.read(authProvider.notifier).logout();

    // Safety measure: ensuring routing operates outside of frame assembly cycles
    Future.microtask(() {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LandingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBuilder.isDesktop(context);

    if (isDesktop) {
      return Scaffold(
          body: Row(
            children: [
            // Persistent Sidebar (Desktop)
            Container(
            width: 240,
            color: AppTheme.secondaryDark,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            // Logo / Header
            Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppTheme.highlightBlue, AppTheme.highlightTeal]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(LucideIcons.heart, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Julian Medical", style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                    Row(
                      children: [
                        const Icon(LucideIcons.shieldAlert, color: AppTheme.highlightTeal, size: 10),
                        const SizedBox(width: 4),
                        Text("ADMIN PORTAL", style: GoogleFonts.outfit(fontSize: 9, color: AppTheme.highlightTeal, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 16),

          // Menu Items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("MANAGEMENT", style: GoogleFonts.outfit(fontSize: 10, color: Colors.white30, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    final item = _menuItems[index];
                    final isSelected = _activeTab == item['id'];
                    return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            child: InkWell(
                                onTap: () => setState(() => _activeTab = item['id']),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppTheme.highlightBlue : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                        children: [
                                    Icon(item['icon'] as IconData, color: isSelected ? Colors.white : Colors.white , size: 16),
                                    const SizedBox(width: 12),
                                          Text(
                                            item['label'] as String,
                                            style: GoogleFonts.outfit(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: isSelected ? Colors.white : Colors.white54
                                            ),
                                          ),
                                        ],
                                    ),
                                ),
                            ),
                        ),
                    );
                  },
              ),
          ),
                ],
            ),
            ),
              // Main Content Area
              Expanded(child: _buildActiveView()),
            ],
          ),
      );
    } else {
      // Mobile fallback
      return Scaffold(
        appBar: AppBar(title: const Text("Admin Portal")),
        body: _buildActiveView(),
      );}
    }
  }
