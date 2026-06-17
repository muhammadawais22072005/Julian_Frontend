import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:julian_medical_center/presentation/theme/app_theme.dart';
import 'package:julian_medical_center/presentation/widgets/responsive_builder.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBuilder.isDesktop(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Admin Dashboard",
                      style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Tuesday, June 16, 2026 · System overview",
                      style: TextStyle(fontSize: 13, color: AppTheme.textGray),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.download, size: 14),
                    label: const Text("Export Report"),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      side: const BorderSide(color: AppTheme.softBorder),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.softBorder),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Badge(
                        label: Text("3", style: TextStyle(fontSize: 9)),
                        child: Icon(LucideIcons.bell, size: 16, color: AppTheme.textGray),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // KPIs Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isDesktop ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isDesktop ? 1.5 : 1.1, // Fixed mobile ratio to avoid text squishing
            children: [
              _kpiCard("Total Patients", "2,847", "+124 this month", LucideIcons.users, AppTheme.highlightBlue, const Color(0xFFF0F6FF), true),
              _kpiCard("Today's Appts", "43", "8 remaining", LucideIcons.calendar, AppTheme.highlightTeal, const Color(0xFFE6F7F7), true),
              _kpiCard("Monthly Revenue", "\$71,800", "+6.7% vs May", LucideIcons.dollarSign, AppTheme.stableGreen, const Color(0xFFEBF7ED), true),
              _kpiCard("Avg Wait Time", "11 min", "−3m vs last wk", LucideIcons.clock, Colors.orange, const Color(0xFFFFF7ED), false),
            ],
          ),
          const SizedBox(height: 24),

          // Charts Row
          ResponsiveBuilder(
            mobile: Column(
              children: [
                _buildRevenueChart(),
                const SizedBox(height: 24),
                _buildDeptLoadChart(),
              ],
            ),
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildRevenueChart()),
                const SizedBox(width: 24),
                Expanded(flex: 1, child: _buildDeptLoadChart()),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Lists Row
          ResponsiveBuilder(
            mobile: Column(
              children: [
                _buildRecentAppointments(),
                const SizedBox(height: 24),
                _buildSystemAlerts(),
              ],
            ),
            desktop: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildRecentAppointments()),
                const SizedBox(width: 24),
                Expanded(flex: 1, child: _buildSystemAlerts()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kpiCard(String label, String value, String delta, IconData icon, Color color, Color bg, bool isPositive) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.softBorder),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textGray), overflow: TextOverflow.ellipsis)),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    isPositive ? LucideIcons.trendingUp : LucideIcons.trendingDown,
                    color: isPositive ? AppTheme.stableGreen : Colors.orange,
                    size: 11,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      delta,
                      style: const TextStyle(fontSize: 11, color: AppTheme.textGray),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── REVENUE AREA CHART ───────────────────────────────────────────────────
  Widget _buildRevenueChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.softBorder),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Revenue vs Expenses", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                  const SizedBox(height: 2),
                  const Text("January – June 2026", style: TextStyle(fontSize: 11, color: AppTheme.textGray)),
                ],
              ),
              const Icon(LucideIcons.barChart2, color: AppTheme.textGray, size: 16),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => const FlLine(color: AppTheme.softBorder, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox();
                        return Text('\$${(value / 1000).toStringAsFixed(0)}k', style: const TextStyle(fontSize: 10, color: AppTheme.textGray));
                      },
                      reservedSize: 32,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Text(months[value.toInt()], style: const TextStyle(fontSize: 10, color: AppTheme.textGray));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 5,
                minY: 20000,
                maxY: 80000,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 48200),
                      FlSpot(1, 52100),
                      FlSpot(2, 61400),
                      FlSpot(3, 58900),
                      FlSpot(4, 67300),
                      FlSpot(5, 71800),
                    ],
                    isCurved: true,
                    color: AppTheme.highlightBlue,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.highlightBlue.withOpacity(0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 31000),
                      FlSpot(1, 29500),
                      FlSpot(2, 33200),
                      FlSpot(3, 30800),
                      FlSpot(4, 35100),
                      FlSpot(5, 36400),
                    ],
                    isCurved: true,
                    color: AppTheme.highlightTeal,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.highlightTeal.withOpacity(0.05),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── DEPT LOAD PIE CHART ──────────────────────────────────────────────────
  Widget _buildDeptLoadChart() {
    final List<Map<String, dynamic>> deptData = [
      {"name": "General Practice", "value": 38.0, "color": AppTheme.highlightBlue},
      {"name": "Cardiology", "value": 18.0, "color": AppTheme.highlightTeal},
      {"name": "Pediatrics", "value": 16.0, "color": Colors.indigo},
      {"name": "Orthopedics", "value": 14.0, "color": Colors.amber},
      {"name": "Others", "value": 14.0, "color": AppTheme.textGray},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.softBorder),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Dept. Load", style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
              const Icon(LucideIcons.pieChart, color: AppTheme.textGray, size: 14),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 32,
                sections: deptData.map((d) {
                  return PieChartSectionData(
                    color: d['color'] as Color,
                    value: d['value'] as double,
                    title: '',
                    radius: 20,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...deptData.map((d) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: d['color'] as Color, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text(d['name'] as String, style: const TextStyle(fontSize: 11, color: AppTheme.textGray)),
                    ],
                  ),
                  Text("${(d['value'] as double).toInt()}%", style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── RECENT APPOINTMENTS ──────────────────────────────────────────────────
  Widget _buildRecentAppointments() {
    final appointments = [
      {"id": "APT-3841", "patient": "Emma Thompson", "doctor": "Dr. Sarah Chen", "type": "General Checkup", "time": "09:00 AM", "status": "completed"},
      {"id": "APT-3842", "patient": "James Wilson", "doctor": "Dr. Marcus Patel", "type": "Follow-up", "time": "09:30 AM", "status": "completed"},
      {"id": "APT-3843", "patient": "Olivia Martinez", "doctor": "Dr. Sarah Chen", "type": "Blood Pressure Review", "time": "10:15 AM", "status": "in-progress"},
      {"id": "APT-3844", "patient": "Noah Anderson", "doctor": "Dr. Priya Sharma", "type": "Vaccination", "time": "11:00 AM", "status": "upcoming"},
      {"id": "APT-3845", "patient": "Sophia Davis", "doctor": "Dr. Sarah Chen", "type": "Annual Physical", "time": "11:45 AM", "status": "upcoming"},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.softBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Today's Appointments", style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text("View all", style: TextStyle(fontSize: 12, color: AppTheme.highlightBlue)),
                      const SizedBox(width: 4),
                      const Icon(LucideIcons.chevronRight, size: 12, color: AppTheme.highlightBlue),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.softBorder),
          // Clean layout representation using Column maps over a virtual list inside SingleChildScrollView
          Column(
            children: appointments.map((a) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppTheme.softBorder, width: 0.5)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Text(a['id']!, style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textGray, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a['patient']!, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                          Text("${a['type']} · ${a['doctor']}", style: const TextStyle(fontSize: 11, color: AppTheme.textGray)),
                        ],
                      ),
                    ),
                    Text(a['time']!, style: const TextStyle(fontSize: 12, color: AppTheme.textGray)),
                    const SizedBox(width: 16),
                    _statusBadge(a['status']!),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color fg;
    switch (status) {
      case 'completed':
        bg = const Color(0xFFEBF7ED);
        fg = AppTheme.stableGreen;
        break;
      case 'in-progress':
        bg = const Color(0xFFF0F6FF);
        fg = AppTheme.highlightBlue;
        break;
      case 'upcoming':
      default:
        bg = const Color(0xFFFFF7ED);
        fg = Colors.orange;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }

  // ─── SYSTEM ALERTS ────────────────────────────────────────────────────────
  Widget _buildSystemAlerts() {
    final alerts = [
      {"type": "error", "msg": "Lab results overdue for 4 patients", "time": "5 min ago"},
      {"type": "warning", "msg": "Dr. Okafor's schedule has 3 unassigned slots", "time": "18 min ago"},
      {"type": "info", "msg": "Monthly billing report is ready to download", "time": "1 hr ago"},
      {"type": "warning", "msg": "Amoxicillin stock below reorder threshold", "time": "2 hr ago"},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.softBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text("System Alerts", style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
          ),
          const Divider(height: 1, color: AppTheme.softBorder),
          Column(
            children: alerts.map((a) {
              return Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppTheme.softBorder, width: 0.5)),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _alertIcon(a['type']!),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a['msg']!, style: const TextStyle(fontSize: 12, color: AppTheme.primaryNavy, height: 1.4)),
                          const SizedBox(height: 4),
                          Text(a['time']!, style: const TextStyle(fontSize: 10, color: AppTheme.textGray)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _alertIcon(String type) {
    IconData icon;
    Color color;
    switch (type) {
      case 'error':
        icon = LucideIcons.xCircle;
        color = AppTheme.criticalRed;
        break;
      case 'warning':
        icon = LucideIcons.alertCircle;
        color = Colors.orange;
        break;
      case 'info':
      default:
        icon = LucideIcons.checkCircle2;
        color = AppTheme.highlightTeal;
        break;
    }
    return Icon(icon, color: color, size: 14);
  }
}