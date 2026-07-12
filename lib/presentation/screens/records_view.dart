import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:julian_medical_center/presentation/theme/app_theme.dart';
import 'package:julian_medical_center/presentation/widgets/responsive_builder.dart';
import 'package:julian_medical_center/data/models/medical_record_model.dart';
import 'package:julian_medical_center/providers/record_provider.dart';

class RecordsView extends ConsumerWidget {
  const RecordsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredRecordsAsync = ref.watch(filteredRecordsProvider);
    final prescriptionsAsync = ref.watch(prescriptionListProvider);

    final searchQuery = ref.watch(recordSearchQueryProvider);
    final categoryFilter = ref.watch(recordCategoryFilterProvider);

    final isDesktop = ResponsiveBuilder.isDesktop(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── TITLE HEADER ────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Medical Records", style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                    const Text("Patient files, lab results & prescriptions", style: TextStyle(fontSize: 13, color: AppTheme.textGray)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.fileText, size: 14),
                  label: const Text("Upload Record"),
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
            const SizedBox(height: 24),

            // ─── TOP SUMMARY KPIS (REPLACE GRIDVIEW SHRINKWRAP WITH LAYOUT WRAP/FLEX) ───
            if (isDesktop)
              Row(
                children: [
                  Expanded(child: _summaryKPI("Total Records", "1,284", LucideIcons.fileText, AppTheme.highlightTeal, const Color(0xFFE6F7F7))),
                  const SizedBox(width: 16),
                  Expanded(child: _summaryKPI("Lab Results", "438", LucideIcons.beaker, AppTheme.stableGreen, const Color(0xFFEBF7ED))),
                  const SizedBox(width: 16),
                  Expanded(child: _summaryKPI("Active Prescriptions", "97", LucideIcons.pill, Colors.indigo, const Color(0xFFEEF0FC))),
                ],
              )
            else
              Column(
                children: [
                  _summaryKPI("Total Records", "1,284", LucideIcons.fileText, AppTheme.highlightTeal, const Color(0xFFE6F7F7)),
                  const SizedBox(height: 12),
                  _summaryKPI("Lab Results", "438", LucideIcons.beaker, AppTheme.stableGreen, const Color(0xFFEBF7ED)),
                  const SizedBox(height: 12),
                  _summaryKPI("Active Prescriptions", "97", LucideIcons.pill, Colors.indigo, const Color(0xFFEEF0FC)),
                ],
              ),
            const SizedBox(height: 28),

            // ─── RECENT RECORDS CONTAINER ────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.softBorder),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search & Filters Row Header
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      Text("Recent Records", style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 200,
                            height: 38,
                            child: TextFormField(
                              initialValue: searchQuery,
                              onChanged: (val) => ref.read(recordSearchQueryProvider.notifier).state = val,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(LucideIcons.search, size: 14),
                                hintText: "Search records...",
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _categoryFilterBtn(ref, "All", categoryFilter),
                                const SizedBox(width: 4),
                                _categoryFilterBtn(ref, "Lab", categoryFilter),
                                const SizedBox(width: 4),
                                _categoryFilterBtn(ref, "Report", categoryFilter),
                                const SizedBox(width: 4),
                                _categoryFilterBtn(ref, "Imaging", categoryFilter),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Data Core Async Handler
                  filteredRecordsAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(color: AppTheme.highlightTeal),
                      ),
                    ),

                    error: (err, stack) => Center(
                      child: Text(
                        "Error: $err",
                        style: const TextStyle(color: AppTheme.criticalRed),
                      ),
                    ),

                    data: (records) {
                      if (records.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Text(
                              "No records match your criteria.",
                              style: GoogleFonts.inter(color: AppTheme.textGray),
                            ),
                          ),
                        );
                      }

                      return isDesktop
                          ? _buildDesktopTable(context, records)
                          : _buildMobileList(records);
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── PRESCRIPTIONS CONTAINER ─────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.softBorder),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Active Prescriptions", style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                  const SizedBox(height: 16),
                  prescriptionsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.highlightTeal)),
                    error: (err, stack) => Center(child: Text("Error: $err", style: const TextStyle(color: AppTheme.criticalRed))),
                    data: (prescriptions) => ListView.separated(
                      shrinkWrap: true, // Fine here since prescription count is natively constrained by business rules
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: prescriptions.length,
                      separatorBuilder: (context, index) => const Divider(height: 24, color: AppTheme.softBorder),
                      itemBuilder: (context, index) {
                        final rx = prescriptions[index];
                        return Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(color: Color(0xFFF5F3FF), shape: BoxShape.circle),
                              child: const Icon(LucideIcons.pill, color: Color(0xFF7C3AED), size: 16),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(rx.drug, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                                  const SizedBox(height: 2),
                        Text("${rx.drug} · ${rx.frequency}", style: const TextStyle(fontSize: 11, color: AppTheme.textGray)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(rx.duration, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
                                const SizedBox(height: 2),
                                Text(
                                  "${rx.refills} refills · since ${rx.date.day}/${rx.date.month}/${rx.date.year}",
                                  style: const TextStyle(fontSize: 10, color: AppTheme.textGray),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                side: const BorderSide(color: AppTheme.softBorder),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                              child: const Text("Renew", style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryKPI(String label, String value, IconData icon, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.softBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textGray)),
              const SizedBox(height: 2),
              Text(value, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
            ],
          )
        ],
      ),
    );
  }

  Widget _categoryFilterBtn(WidgetRef ref, String category, String activeFilter) {
    final isAct = activeFilter == category;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ChoiceChip(
        label: Text(category),
        selected: isAct,
        selectedColor: AppTheme.highlightBlue,
        checkmarkColor: Colors.white,
        showCheckmark: false,
        labelStyle: TextStyle(fontSize: 11, color: isAct ? Colors.white : AppTheme.textGray, fontWeight: isAct ? FontWeight.bold : FontWeight.normal),
        onSelected: (sel) {
          if (sel) {
            ref.read(recordCategoryFilterProvider.notifier).state = category;
          }
        },
      ),
    );
  }

  // ─── DESKTOP DATA TABLE (RESOLVES HORIZONTAL OVERFLOW CRASH RISKS) ──────────
  Widget _buildDesktopTable(BuildContext context, List<MedicalRecordModel> list) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 96),
        child: DataTable(
          showCheckboxColumn: false,
          dataRowMinHeight: 48,
          dataRowMaxHeight: 56,
          headingRowHeight: 42,
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
          columns: const [
            DataColumn(label: Text("Record ID", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.primaryNavy))),
            DataColumn(label: Text("Patient", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.primaryNavy))),
            DataColumn(label: Text("Type", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.primaryNavy))),
            DataColumn(label: Text("Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.primaryNavy))),
            DataColumn(label: Text("Doctor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.primaryNavy))),
            DataColumn(label: Text("Size", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.primaryNavy))),
            DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppTheme.primaryNavy))),
            DataColumn(label: Text("")),
          ],
          rows: list.map((r) {
            return DataRow(
              onSelectChanged: (_) {},
              cells: [
                DataCell(Text(r.id, style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: AppTheme.textGray))),
                DataCell(Text(r.patient, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy))),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _categoryIcon(r.category),
                      const SizedBox(width: 8),
                      Text(r.type, style: const TextStyle(fontSize: 13, color: AppTheme.primaryNavy)),
                    ],
                  ),
                ),
                DataCell(Text(r.date, style: const TextStyle(fontSize: 12, color: AppTheme.textGray))),
                DataCell(Text(r.doctor, style: const TextStyle(fontSize: 12, color: AppTheme.textGray))),
                DataCell(Text(r.size, style: const TextStyle(fontSize: 12, color: AppTheme.textGray))),
                DataCell(_statusBadge(r.status)),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(LucideIcons.eye, size: 14, color: AppTheme.textGray), onPressed: () {}),
                      IconButton(icon: const Icon(LucideIcons.download, size: 14, color: AppTheme.textGray), onPressed: () {}),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─── MOBILE CARDS LIST ─────────────────────────────────────────────────────
  Widget _buildMobileList(List<MedicalRecordModel> list) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, idx) {
        final r = list[idx];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.softBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(r.id, style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: AppTheme.textGray)),
                  _statusBadge(r.status),
                ],
              ),
              const SizedBox(height: 6),
              Text(r.patient, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
              const SizedBox(height: 6),
              Row(
                children: [
                  _categoryIcon(r.category),
                  const SizedBox(width: 8),
                  Text(r.type, style: const TextStyle(fontSize: 13, color: AppTheme.primaryNavy)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Dr: ${r.doctor} · ${r.size}", style: const TextStyle(fontSize: 11, color: AppTheme.textGray)),
                  Text(r.date, style: const TextStyle(fontSize: 11, color: AppTheme.textGray)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _categoryIcon(String category) {
    IconData icon;
    Color color;
    Color bg;
    switch (category.toLowerCase()) {
      case 'lab':
        icon = LucideIcons.beaker;
        color = const Color(0xFF0D9488);
        bg = const Color(0xFFCCFBF1);
        break;
      case 'report':
        icon = LucideIcons.clipboard;
        color = const Color(0xFF4F46E5);
        bg = const Color(0xFFE0E7FF);
        break;
      case 'imaging':
      default:
        icon = LucideIcons.eye;
        color = const Color(0xFFEA580C);
        bg = const Color(0xFFFFEDD5);
        break;
    }
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Icon(icon, color: color, size: 12),
    );
  }

  Widget _statusBadge(String status) {
    final isRev = status == 'reviewed';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isRev ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.outfit(fontSize: 8, fontWeight: FontWeight.bold, color: isRev ? AppTheme.stableGreen : const Color(0xFFD97706)),
      ),
    );
  }
}