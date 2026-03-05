import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../utils/theme.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});
  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final _api = ApiService();
  List<CourseModel> _courses = [];
  bool _loading = true;
  String? _err;
  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _err = null; });
    try {
      final courses = await _api.getAllCourses();
      setState(() { _courses = courses; _loading = false; });
    } catch (_) {
      setState(() { _err = 'Erreur de chargement'; _loading = false; });
    }
  }

  // Dates de passage ce mois depuis le backend
  Set<int> get _joursPassage {
    return _courses
        .where((c) {
          final d = c.dateTime;
          return d != null && d.month == _focusedMonth.month && d.year == _focusedMonth.year;
        })
        .map((c) => c.dateTime!.day)
        .toSet();
  }

  // Prochains passages futurs
  List<CourseModel> get _prochains {
    final now = DateTime.now();
    final list = _courses.where((c) {
      final d = c.dateTime;
      return d != null && d.isAfter(now);
    }).toList();
    list.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
    return list.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Calendrier des collectes'),
        automaticallyImplyLeading: false,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _err != null
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(_err!, style: const TextStyle(color: AppColors.textGrey)),
                  TextButton(onPressed: _load, child: const Text('Réessayer')),
                ]))
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _load,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // ── Calendrier ──
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))]),
                        child: Column(children: [
                          // Navigateur mois
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              IconButton(icon: const Icon(Icons.chevron_left),
                                onPressed: () => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1))),
                              Text(_monthLabel(_focusedMonth),
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textDark)),
                              IconButton(icon: const Icon(Icons.chevron_right),
                                onPressed: () => setState(() => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1))),
                            ]),
                          ),
                          // Jours de la semaine
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: ['Lu','Ma','Me','Je','Ve','Sa','Di'].map((d) => SizedBox(width: 36,
                                child: Center(child: Text(d, style: const TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.w600))))).toList()),
                          ),
                          const SizedBox(height: 8),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), child: _buildGrid()),
                          const SizedBox(height: 12),
                        ]),
                      ),
                      const SizedBox(height: 20),

                      // ── Légende ──
                      Row(children: [
                        _LegItem(color: AppColors.primary, label: 'Passage planifié'),
                        const SizedBox(width: 16),
                        _LegItem(color: AppColors.grey.withOpacity(0.4), label: 'Aujourd\'hui'),
                      ]),
                      const SizedBox(height: 20),

                      // ── Prochains passages ──
                      Text('Prochains passages (${_prochains.length})',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      const SizedBox(height: 12),
                      _prochains.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: const Center(child: Text('Aucun passage planifié', style: TextStyle(color: AppColors.textGrey))))
                          : Column(children: _prochains.map((c) => _PassageItem(course: c)).toList()),
                      const SizedBox(height: 20),

                      // ── Rappel ──
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primaryLight)),
                        child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                          SizedBox(width: 8),
                          Expanded(child: Text(
                              'Rappel : Pensez à sortir vos poubelles la veille au soir ou avant 7h00 le jour de la collecte.',
                              style: TextStyle(color: AppColors.textGrey, fontSize: 12))),
                        ]),
                      ),
                      const SizedBox(height: 80),
                    ]),
                  ),
                ),
    );
  }

  Widget _buildGrid() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final startWeekday = (firstDay.weekday - 1) % 7; // 0=Lun
    final joursPassage = _joursPassage;
    final cells = <Widget>[];

    for (int i = 0; i < startWeekday; i++) {
      cells.add(const SizedBox(width: 36, height: 36));
    }
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final isToday = _isSameDay(date, DateTime.now());
      final isSelected = _isSameDay(date, _selectedDate);
      final isPassage = joursPassage.contains(day);

      cells.add(GestureDetector(
        onTap: () => setState(() => _selectedDate = date),
        child: Container(
          width: 36, height: 36,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isPassage ? AppColors.primary
                : isSelected ? AppColors.primaryLight.withOpacity(0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isToday && !isPassage ? Border.all(color: AppColors.primary, width: 1.5) : null,
          ),
          child: Center(child: Text('$day', style: TextStyle(
            color: isPassage ? Colors.white : AppColors.textDark,
            fontWeight: isToday || isPassage ? FontWeight.w700 : FontWeight.normal,
            fontSize: 13))),
        ),
      ));
    }
    return Wrap(children: cells);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _monthLabel(DateTime d) {
    const mois = ['Janvier','Février','Mars','Avril','Mai','Juin','Juillet','Août','Septembre','Octobre','Novembre','Décembre'];
    return '${mois[d.month - 1]} ${d.year}';
  }
}

class _PassageItem extends StatelessWidget {
  final CourseModel course;
  const _PassageItem({required this.course});
  @override
  Widget build(BuildContext context) {
    final secteurs = course.secteurs.map((s) => s.nomSecteur).join(', ');
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Row(children: [
        const Icon(Icons.local_shipping_outlined, color: AppColors.primary, size: 22),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(course.dateFormatted,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark)),
          if (secteurs.isNotEmpty)
            Text(secteurs, style: const TextStyle(color: AppColors.textGrey, fontSize: 12), overflow: TextOverflow.ellipsis),
        ])),
        Container(width: 10, height: 10,
          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
      ]),
    );
  }
}

class _LegItem extends StatelessWidget {
  final Color color; final String label;
  const _LegItem({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 16, height: 16, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
    const SizedBox(width: 6),
    Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
  ]);
}
