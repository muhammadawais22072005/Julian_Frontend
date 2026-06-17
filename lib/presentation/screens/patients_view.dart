import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:julian_medical_center/presentation/theme/app_theme.dart';
import 'package:julian_medical_center/presentation/widgets/responsive_builder.dart';
import 'package:julian_medical_center/data/models/patient_model.dart';
import 'package:julian_medical_center/providers/patient_provider.dart';
import 'package:intl/intl.dart';

class PatientsView extends ConsumerStatefulWidget {
  const PatientsView({super.key});

  @override
  ConsumerState<PatientsView> createState() => _PatientsViewState();
}

class _PatientsViewState extends ConsumerState<PatientsView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(patientListProvider);
    final selectedPatient = ref.watch(selectedPatientProvider);
    final isDesktop = ResponsiveBuilder.isDesktop(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Main patient roster list/table
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Patients", style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                          patientsAsync.maybeWhen(
                            data: (list) => Text("${list.length} registered patients", style: const TextStyle(fontSize: 13, color: AppTheme.textGray)),
                            orElse: () => const Text("Loading roster...", style: TextStyle(fontSize: 13, color: AppTheme.textGray)),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(LucideIcons.plus, size: 14),
                        label: const Text("Add Patient"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.highlightTeal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  SizedBox(
                    width: 360,
                    child: TextFormField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(LucideIcons.search, size: 16),
                        hintText: "Search by name or condition...",
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Table/Cards Content
                  Expanded(
                    child: patientsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.highlightTeal)),
                      error: (err, stack) => Center(child: Text("Error: $err", style: const TextStyle(color: AppTheme.criticalRed))),
                      data: (list) {
                        final filteredList = list.where((p) {
                          return p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                              p.condition.toLowerCase().contains(_searchQuery.toLowerCase());
                        }).toList();

                        if (filteredList.isEmpty) {
                          return Center(
                            child: Text("No patients found.", style: GoogleFonts.inter(color: AppTheme.textGray)),
                          );
                        }

                        if (isDesktop) {
                          return _buildDesktopTable(filteredList, selectedPatient);
                        } else {
                          return _buildMobileCards(filteredList, selectedPatient);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Slide-out Profile detail panel (Desktop only)
          if (isDesktop && selectedPatient != null)
            Container(
              width: 340,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(left: BorderSide(color: AppTheme.softBorder)),
              ),
              child: SingleChildScrollView(
                child: _buildDetailsPanel(selectedPatient, isModal: false),
              ),
            ),
        ],
      ),
    );
  }

  // ─── DESKTOP DATA TABLE ────────────────────────────────────────────────────
  Widget _buildDesktopTable(List<PatientModel> list, PatientModel? selected) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.softBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Enabled to guard the data coordinates against responsive cropping structural errors
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - (selected != null ? 388 : 48)),
            child: DataTable(
              showCheckboxColumn: false,
              dataRowMinHeight: 52,
              dataRowMaxHeight: 60,
              headingRowHeight: 46,
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
              columns: const [
                DataColumn(label: Text("Patient", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryNavy))),
                DataColumn(label: Text("Age", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryNavy))),
                DataColumn(label: Text("Blood Type", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryNavy))),
                DataColumn(label: Text("Condition", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryNavy))),
                DataColumn(label: Text("Last Visit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryNavy))),
                DataColumn(label: Text("Doctor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryNavy))),
                DataColumn(label: Text("")),
              ],
              rows: list.map((p) {
                final isSelected = selected?.id == p.id;
                return DataRow(
                  selected: isSelected,
                  onSelectChanged: (_) {
                    ref.read(selectedPatientProvider.notifier).state = p;
                  },
                  color: WidgetStateProperty.resolveWith<Color?>((states) {
                    if (isSelected) return const Color(0xFFF0F7FF);
                    if (states.contains(WidgetState.hovered)) return const Color(0xFFF8FAFC);
                    return null;
                  }),
                  cells: [
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: AppTheme.highlightTeal.withOpacity(0.1),
                            child: Text(
                              p.name.split(" ").map((n) => n[0]).take(2).join(),
                              style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.highlightTeal),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(p.name, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                              Text(p.gender, style: const TextStyle(fontSize: 10, color: AppTheme.textGray)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(p.age.toString(), style: const TextStyle(fontSize: 13, color: AppTheme.textGray))),
                    DataCell(_bloodBadge(p.bloodType)),
                    DataCell(Text(p.condition, style: const TextStyle(fontSize: 13, color: AppTheme.primaryNavy))),
                    DataCell(Text (DateFormat('yyyy-MM-dd').format(p.lastVisit), style: const TextStyle(fontSize: 12, color: AppTheme.textGray))),
                    DataCell(Text(p.doctor, style: const TextStyle(fontSize: 12, color: AppTheme.textGray))),
                    DataCell(
                      Icon(LucideIcons.chevronRight, size: 14, color: AppTheme.textGray.withOpacity(0.6)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // ─── MOBILE CARDS VIEW ─────────────────────────────────────────────────────
  Widget _buildMobileCards(List<PatientModel> list, PatientModel? selected) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final p = list[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.softBorder),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.highlightTeal.withOpacity(0.1),
              child: Text(
                p.name.split(" ").map((n) => n[0]).take(2).join(),
                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.highlightTeal),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(p.name, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                _bloodBadge(p.bloodType),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Condition: ${p.condition}", style: const TextStyle(fontSize: 12, color: AppTheme.primaryNavy)),
                  const SizedBox(height: 2),
                  Text("Last Visit: ${p.lastVisit} · Dr: ${p.doctor}", style: const TextStyle(fontSize: 11, color: AppTheme.textGray)),
                ],
              ),
            ),
            onTap: () {
              ref.read(selectedPatientProvider.notifier).state = p;
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                builder: (context) => DraggableScrollableSheet(
                  initialChildSize: 0.85,
                  maxChildSize: 0.95,
                  minChildSize: 0.5,
                  expand: false,
                  builder: (context, scrollController) => _buildDetailsPanel(p, isModal: true, scrollController: scrollController),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ─── BLOOD TYPE BADGE ──────────────────────────────────────────────────────
  Widget _bloodBadge(String bloodType) {
    Color bg;
    Color fg;
    if (bloodType.contains('O')) {
      bg = const Color(0xFFFFF1F2);
      fg = const Color(0xFFE11D48);
    } else if (bloodType.contains('A')) {
      bg = const Color(0xFFE8F4FB);
      fg = AppTheme.highlightTeal;
    } else if (bloodType.contains('B')) {
      bg = const Color(0xFFF0FDF4);
      fg = const Color(0xFF16A34A);
    } else {
      bg = const Color(0xFFF5F3FF);
      fg = const Color(0xFF7C3AED);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(bloodType, style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.bold, color: fg)),
    );
  }

  // ─── DETAILS PANEL & CHART ─────────────────────────────────────────────────
  Widget _buildDetailsPanel(PatientModel patient, {required bool isModal, ScrollController? scrollController}) {
    final vitalsAsync = ref.watch(patientVitalsProvider(patient.id));

    return ListView(
      controller: scrollController, // Links up explicitly to resolve standard modal scrolling drag context issues
      padding: const EdgeInsets.all(24),
      children: [
        // Action Header Rows
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Patient Profile", style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
            IconButton(
              icon: const Icon(LucideIcons.x, size: 16, color: AppTheme.textGray),
              onPressed: () {
                Navigator.pop(context);
                ref.read(selectedPatientProvider.notifier).state = null;
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Hero Profile Node Card
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: const Color(0xFFE8F4FB),
                child: Text(
                  patient.name.split(" ").map((n) => n[0]).take(2).join(),
                  style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.highlightTeal),
                ),
              ),
              const SizedBox(height: 12),
              Text(patient.name, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
              const SizedBox(height: 4),
              Text("${patient.age} yrs · ${patient.gender}", style: const TextStyle(fontSize: 12, color: AppTheme.textGray)),
              const SizedBox(height: 8),
              _statusBadge(patient.status),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Metadata Map Details Rows
        _detailsItem("Date of Birth", DateFormat('yyyy-MM-dd').format(patient.dob)),
        _detailsItem("Blood Type", patient.bloodType),
        _detailsItem("Condition", patient.condition),
        _detailsItem("Primary Doctor", patient.doctor),
        _detailsItem("Last Visit", DateFormat('yyyy-MM-dd').format(patient.lastVisit)),
        const SizedBox(height: 20),

        // Direct Action Trigger Comm Links
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(LucideIcons.phone, size: 12, color: AppTheme.highlightTeal),
          label: Text(patient.phone, style: const TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 40),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: const BorderSide(color: AppTheme.softBorder),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(LucideIcons.mail, size: 12, color: AppTheme.highlightTeal),
          label: Text(patient.email, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 40),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: const BorderSide(color: AppTheme.softBorder),
          ),
        ),
        const SizedBox(height: 28),

        // Live Medical Vitals Tracking Dashboard Area
        Text("Vitals Tracking", style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
        const SizedBox(height: 12),
        vitalsAsync.when(
          loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator(color: AppTheme.highlightTeal))),
          error: (err, stack) => Center(child: Text("Failed to load vitals data.", style: const TextStyle(fontSize: 11, color: AppTheme.criticalRed))),
          data: (vitals) {
            final List<int> hrHistory = List<int>.from(vitals['heartRateHistory']);
            final String currentBp = vitals['currentBloodPressure'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(LucideIcons.heart, color: Colors.red, size: 14),
                            const SizedBox(height: 6),
                            Text("${hrHistory.last} bpm", style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
                            const Text("Heart Rate", style: TextStyle(fontSize: 10, color: AppTheme.textGray)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFFF0F6FF), borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(LucideIcons.activity, color: AppTheme.highlightBlue, size: 14),
                            const SizedBox(height: 6),
                            Text(currentBp, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.highlightBlue)),
                            const Text("Blood Pressure", style: TextStyle(fontSize: 10, color: AppTheme.textGray)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text("Heart Rate History (7 sessions)", style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textGray)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 90,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: hrHistory.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList(),
                          isCurved: true,
                          color: Colors.red,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.red.withOpacity(0.05),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.highlightTeal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            elevation: 0,
          ),
          child: const Text("View Full Record", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _detailsItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: GoogleFonts.outfit(fontSize: 9, color: AppTheme.textGray, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 13, color: AppTheme.primaryNavy)),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final isCritical = status == 'critical';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCritical ? const Color(0xFFFFF1F2) : const Color(0xFFEBF7ED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.bold, color: isCritical ? AppTheme.criticalRed : AppTheme.stableGreen),
      ),
    );
  }
}