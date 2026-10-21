import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/physics_calculations.dart';
import '../../data/models/content_models.dart';
import '../../shared/widgets/circuit_painters.dart';
import '../../shared/widgets/vorteks_widgets.dart';

class MiniLabScreen extends StatelessWidget {
  const MiniLabScreen({super.key, required this.lesson});
  final LessonContent lesson;

  Widget _experiment() => switch (lesson.labKind) {
        'current' => const _CurrentLab(),
        'iv-graph' => const _OhmicLab(),
        'resistivity' => const _ResistivityLab(),
        'topology' => const _TopologyLab(),
        'kirchhoff' => const _KirchhoffLab(),
        _ => const _PowerLab(),
      };

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(leading: const BrandBackButton(), title: const Text('MINI LAB')),
        body: PageBody(children: [
          SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(lesson.labTitle, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.navy, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            const Text('Apa yang akan kamu lakukan?', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(lesson.labActivity, style: const TextStyle(height: 1.45)),
            const SizedBox(height: 10),
            const Text('Tujuan eksperimen', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(lesson.labObjective),
            const SizedBox(height: 10),
            const Text('Petunjuk penggunaan', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            for (var index = 0; index < lesson.labSteps.length; index++)
              Padding(padding: const EdgeInsets.only(top: 5), child: Text('${index + 1}. ${lesson.labSteps[index]}', style: const TextStyle(height: 1.4))),
          ])),
          const SizedBox(height: 12),
          _experiment(),
          const SizedBox(height: 12),
          SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionTitle('Kesimpulan'),
            const SizedBox(height: 7),
            Text(lesson.labObservation, style: const TextStyle(height: 1.45)),
          ])),
          const SizedBox(height: 18),
        ]),
      );
}

class _CurrentLab extends StatefulWidget {
  const _CurrentLab();
  @override
  State<_CurrentLab> createState() => _CurrentLabState();
}

class _CurrentLabState extends State<_CurrentLab> {
  double _charge = 5;
  double _time = 10;

  @override
  Widget build(BuildContext context) {
    final current = PhysicsCalculations.currentFromCharge(_charge, _time);
    return Column(children: [
      const SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [SectionTitle('Area eksperimen', icon: Icons.electrical_services), SizedBox(height: 8), CircuitDiagram(caption: 'I = Q/t; arah arus konvensional berlawanan dengan gerak elektron.')])) ,
      const SizedBox(height: 12),
      SectionCard(child: Column(children: [
        _SliderValue(label: 'Muatan Q', valueText: '${_charge.toStringAsFixed(0)} C', value: _charge, min: 1, max: 30, divisions: 29, onChanged: (value) => setState(() => _charge = value)),
        const Divider(),
        _SliderValue(label: 'Waktu t', valueText: '${_time.toStringAsFixed(0)} s', value: _time, min: 1, max: 30, divisions: 29, onChanged: (value) => setState(() => _time = value)),
      ])),
      const SizedBox(height: 12),
      SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionTitle('Hasil pengamatan'), const SizedBox(height: 9),
        LabeledValue(label: 'Arus I = Q/t', value: '${current.toStringAsFixed(2)} A'),
        const SizedBox(height: 7), Text('Q = ${_charge.toStringAsFixed(0)} C melewati penampang selama ${_time.toStringAsFixed(0)} s.', style: const TextStyle(color: AppColors.muted)),
      ])),
      const SizedBox(height: 12),
      LabChallengePanel(question: 'Tantangan: atur muatan dan waktu agar arus tepat 0,20 A.', onCheck: () => (current - .20).abs() < 1e-9, success: 'Tepat. I = Q/t menghasilkan 0,20 A.', retry: 'Coba kombinasi Q dan t lain, lalu hitung kembali I = Q/t.'),
    ]);
  }
}

class _Observation {
  const _Observation({required this.component, required this.voltage, required this.current});
  final String component;
  final double voltage;
  final double current;
}

class _OhmicLab extends StatefulWidget {
  const _OhmicLab();
  @override
  State<_OhmicLab> createState() => _OhmicLabState();
}

class _OhmicLabState extends State<_OhmicLab> {
  final _voltage = TextEditingController();
  final _current = TextEditingController();
  final List<_Observation> _observations = [];
  String _component = 'Resistor';
  String? _message;

  @override
  void dispose() { _voltage.dispose(); _current.dispose(); super.dispose(); }

  void _addReading() {
    final voltage = double.tryParse(_voltage.text.replaceAll(',', '.'));
    final current = double.tryParse(_current.text.replaceAll(',', '.'));
    if (voltage == null || current == null || voltage <= 0 || current <= 0) {
      setState(() => _message = 'Masukkan tegangan dan arus hasil pengamatan yang lebih besar dari 0.');
      return;
    }
    setState(() {
      _observations.add(_Observation(component: _component, voltage: voltage, current: current));
      _message = 'Data pengamatan ditambahkan.';
      _voltage.clear();
      _current.clear();
    });
  }

  List<Offset> _normalized(String component) {
    final rows = _observations.where((item) => item.component == component).toList();
    if (rows.isEmpty) return const [];
    final maxV = rows.map((item) => item.voltage).reduce((a, b) => a > b ? a : b);
    final maxI = rows.map((item) => item.current).reduce((a, b) => a > b ? a : b);
    return rows.map((item) => Offset(item.voltage / maxV, item.current / maxI)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final resistorCount = _observations.where((item) => item.component == 'Resistor').length;
    final ledCount = _observations.where((item) => item.component == 'LED').length;
    final resistorVoltages = _observations.where((item) => item.component == 'Resistor').map((item) => item.voltage.toStringAsPrecision(8)).toSet().length;
    final ledVoltages = _observations.where((item) => item.component == 'LED').map((item) => item.voltage.toStringAsPrecision(8)).toSet().length;
    return Column(children: [
      SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionTitle('Area eksperimen', icon: Icons.show_chart),
        const SizedBox(height: 4),
        const Text('Aplikasi tidak mengarang nilai pengukuran LED/resistor. Masukkan pasangan V dan I dari pengamatanmu.'),
        const SizedBox(height: 12),
        DropdownButton<String>(value: _component, isExpanded: true, items: const [DropdownMenuItem(value: 'Resistor', child: Text('Resistor')), DropdownMenuItem(value: 'LED', child: Text('LED'))], onChanged: (value) { if (value != null) setState(() => _component = value); }),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: TextField(controller: _voltage, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Tegangan V', suffixText: 'V'))),
          const SizedBox(width: 10),
          Expanded(child: TextField(controller: _current, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Arus I', suffixText: 'A'))),
        ]),
        const SizedBox(height: 10),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _addReading, icon: const Icon(Icons.add), label: const Text('Tambah data pengamatan'))),
        if (_message != null) Padding(padding: const EdgeInsets.only(top: 6), child: Text(_message!, style: const TextStyle(color: AppColors.muted))),
      ])),
      const SizedBox(height: 12),
      SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionTitle('Grafik V–I', icon: Icons.insert_chart_outlined),
        const SizedBox(height: 8),
        SizedBox(height: 190, width: double.infinity, child: CustomPaint(painter: IvGraphPainter(resistorPoints: _normalized('Resistor'), ledPoints: _normalized('LED')))),
        const Wrap(spacing: 14, children: [Text('● Resistor', style: TextStyle(color: AppColors.navy)), Text('● LED', style: TextStyle(color: AppColors.cyan))]),
        const SizedBox(height: 7),
        Text('Titik: resistor $resistorCount, LED $ledCount. Skala grafik dinormalisasi untuk membantu membandingkan bentuk; tabel menjaga nilai aslinya.'),
        for (final row in _observations)
          Padding(padding: const EdgeInsets.only(top: 5), child: Text('${row.component}: V ${row.voltage} V · I ${row.current} A')),
      ])),
      const SizedBox(height: 12),
      LabChallengePanel(question: 'Tantangan: kumpulkan sedikitnya empat tegangan berbeda untuk masing-masing komponen, lalu bandingkan grafiknya.', onCheck: () => resistorVoltages >= 4 && ledVoltages >= 4, success: 'Data sudah cukup untuk perbandingan yang diminta Aktivitas 2.1. Periksa pola linear kedua grafik.', retry: 'Tambahkan pengamatan pada tegangan berbeda hingga setiap komponen memiliki minimal empat nilai tegangan.'),
      const SizedBox(height: 12),
      const SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [SectionTitle('Hasil pengamatan'), SizedBox(height: 7), Text('Amati apakah perbandingan V/I pada data resistor tetap dan apakah grafik LED menunjukkan pola non-linear. Nilai eksperimen bergantung pada pengukuran yang kamu masukkan.')])) ,
    ]);
  }
}

class _ResistivityLab extends StatefulWidget {
  const _ResistivityLab();
  @override
  State<_ResistivityLab> createState() => _ResistivityLabState();
}

class _ResistivityLabState extends State<_ResistivityLab> {
  double _diameterMm = .5;
  static const double _lengthM = .6;
  static const List<double> _diameters = [.1, .5, 1];

  double get _overRho => PhysicsCalculations.resistanceOverResistivity(_lengthM, _diameterMm / 1000);
  double get _relative => _overRho / PhysicsCalculations.resistanceOverResistivity(_lengthM, .0005);

  @override
  Widget build(BuildContext context) {
    final areaMm2 = PhysicsCalculations.crossSectionCircle(_diameterMm / 1000) * 1e6;
    return Column(children: [
      SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionTitle('Area eksperimen', icon: Icons.straighten),
        const SizedBox(height: 8),
        const Text('Model menggunakan kawat nikrom 60 cm yang disebut pada Aktivitas 2.2. Pilih diameter kawat dari pilihan pada buku.'),
        const SizedBox(height: 12),
        DropdownButton<double>(value: _diameterMm, isExpanded: true, items: _diameters.map((value) => DropdownMenuItem(value: value, child: Text('Diameter ${value.toStringAsFixed(value == 1 ? 0 : 1)} mm'))).toList(), onChanged: (value) { if (value != null) setState(() => _diameterMm = value); }),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: _diameters.map((diameter) => Column(children: [
          Container(width: 24 + diameter * 28, height: 24 + diameter * 28, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.paleBlue, border: Border.all(color: AppColors.navy, width: 2))),
          const SizedBox(height: 5), Text('${diameter.toStringAsFixed(diameter == 1 ? 0 : 1)} mm', style: const TextStyle(fontSize: 12)),
        ])).toList()),
      ])),
      const SizedBox(height: 12),
      SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionTitle('Hasil pengamatan'), const SizedBox(height: 8),
        LabeledValue(label: 'Luas penampang A', value: '${areaMm2.toStringAsPrecision(3)} mm²'),
        const SizedBox(height: 6),
        LabeledValue(label: 'R/ρ = ℓ/A', value: '${_overRho.toStringAsExponential(2)} m⁻¹'),
        const SizedBox(height: 6),
        LabeledValue(label: 'Relatif terhadap 0,5 mm', value: '${_relative.toStringAsFixed(2)}×'),
        const SizedBox(height: 8),
        const Text('Nilai R/ρ bukan hambatan dalam ohm. Nilai R nyata memerlukan ρ bahan yang tidak diberikan dalam aktivitas buku.', style: TextStyle(color: AppColors.muted, height: 1.4)),
      ])),
      const SizedBox(height: 12),
      LabChallengePanel(question: 'Tantangan: untuk bahan dan panjang yang sama, pilih diameter yang membuat hambatan paling kecil.', onCheck: () => _diameterMm == 1, success: 'Benar. Diameter terbesar memiliki luas penampang terbesar sehingga R lebih kecil.', retry: 'Bandingkan luas penampang dan posisi A pada penyebut rumus R = ρℓ/A.'),
    ]);
  }
}

class _TopologyLab extends StatefulWidget {
  const _TopologyLab();
  @override
  State<_TopologyLab> createState() => _TopologyLabState();
}

class _TopologyLabState extends State<_TopologyLab> {
  bool _parallel = false;
  int _count = 5;
  static const double _supply = 9;
  static const double _rated = 2.1;

  double get _lampVoltage => PhysicsCalculations.lampVoltage(sourceVoltageV: _supply, lampCount: _count, parallel: _parallel);

  @override
  Widget build(BuildContext context) => Column(children: [
    SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionTitle('Area eksperimen', icon: Icons.lightbulb_outline),
      const SizedBox(height: 8),
      const Text('Skenario buku: lima lampu 2,1 V dan sumber 9 V. Pilih hubungan lampu lalu amati tegangan model pada tiap lampu.'),
      const SizedBox(height: 8),
      SegmentedButton<bool>(segments: const [ButtonSegment(value: false, label: Text('Seri')), ButtonSegment(value: true, label: Text('Paralel'))], selected: {_parallel}, onSelectionChanged: (selection) => setState(() => _parallel = selection.first)),
      const SizedBox(height: 12),
      _SliderValue(label: 'Jumlah lampu identik', valueText: '$_count', value: _count.toDouble(), min: 1, max: 5, divisions: 4, onChanged: (value) => setState(() => _count = value.round())),
      const SizedBox(height: 4),
      SizedBox(height: 125, width: double.infinity, child: CustomPaint(painter: _TopologyPainter(parallel: _parallel, count: _count))),
    ])),
    const SizedBox(height: 12),
    SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionTitle('Hasil pengamatan'), const SizedBox(height: 8),
      LabeledValue(label: 'Tegangan tiap lampu (model)', value: '${_lampVoltage.toStringAsFixed(2)} V'),
      const SizedBox(height: 6),
      LabeledValue(label: 'Tegangan nominal contoh buku', value: '$_rated V'),
      const SizedBox(height: 7),
      Text(_lampVoltage > _rated ? 'Tegangan model melebihi 2,1 V.' : 'Tegangan model tidak melebihi 2,1 V.', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.navy)),
      const SizedBox(height: 6),
      const Text('Asumsi: lampu identik, pembagian tegangan seri sama, dan sumber ideal. Model tidak menghitung karakteristik lampu non-ohmik atau hambatan dalam baterai.', style: TextStyle(color: AppColors.muted, height: 1.4)),
    ])),
    const SizedBox(height: 12),
    LabChallengePanel(question: 'Tantangan: gunakan lima lampu seri agar tegangan model setiap lampu tidak melebihi 2,1 V.', onCheck: () => !_parallel && _count == 5 && _lampVoltage <= _rated, success: 'Susunan ini memberi 9/5 = 1,8 V per lampu pada model ideal.', retry: 'Bandingkan lima lampu seri dengan setiap lampu yang langsung mendapat tegangan sumber.'),
  ]);
}

class _TopologyPainter extends CustomPainter {
  const _TopologyPainter({required this.parallel, required this.count});
  final bool parallel;
  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    final wire = Paint()..color = AppColors.navy..strokeWidth = 2..style = PaintingStyle.stroke;
    final lamp = Paint()..color = AppColors.cyan..strokeWidth = 2..style = PaintingStyle.stroke;
    final left = size.width * .12;
    final right = size.width * .88;
    final top = size.height * .18;
    final bottom = size.height * .82;
    if (!parallel) {
      final y = size.height * .5;
      canvas.drawLine(Offset(left, y), Offset(right, y), wire);
      for (var i = 0; i < count; i++) {
        final x = left + (right - left) * (i + .5) / count;
        canvas.drawCircle(Offset(x, y), 10, lamp);
        canvas.drawLine(Offset(x - 6, y - 6), Offset(x + 6, y + 6), lamp);
        canvas.drawLine(Offset(x - 6, y + 6), Offset(x + 6, y - 6), lamp);
      }
    } else {
      canvas.drawLine(Offset(left, top), Offset(left, bottom), wire);
      canvas.drawLine(Offset(right, top), Offset(right, bottom), wire);
      for (var i = 0; i < count; i++) {
        final y = top + (bottom - top) * (i + .5) / count;
        canvas.drawLine(Offset(left, y), Offset(size.width * .5 - 10, y), wire);
        canvas.drawCircle(Offset(size.width * .5, y), 9, lamp);
        canvas.drawLine(Offset(size.width * .5 + 9, y), Offset(right, y), wire);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TopologyPainter oldDelegate) => oldDelegate.parallel != parallel || oldDelegate.count != count;
}

class _KirchhoffLab extends StatefulWidget {
  const _KirchhoffLab();
  @override
  State<_KirchhoffLab> createState() => _KirchhoffLabState();
}

class _KirchhoffLabState extends State<_KirchhoffLab> {
  double _lampResistance = 1.2;
  KirchhoffCurrents get _currents => PhysicsCalculations.carCircuit(lampResistanceOhm: _lampResistance);

  @override
  Widget build(BuildContext context) => Column(children: [
    SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionTitle('Area eksperimen', icon: Icons.account_tree_outlined),
      const SizedBox(height: 8),
      const Text('Skema model dua sumber menggunakan contoh alternator, aki, dan lampu pada buku.'),
      const SizedBox(height: 8),
      SizedBox(height: 150, width: double.infinity, child: CustomPaint(painter: MixedCircuitPainter())),
      const SizedBox(height: 6),
      const Text('ε alternator = 14 V; r = 0,1 Ω · ε aki = 12 V; r = 0,01 Ω · R lampu awal = 1,20 Ω', style: TextStyle(fontSize: 12, color: AppColors.muted)),
      const SizedBox(height: 12),
      _SliderValue(label: 'Hambatan lampu Rₗ', valueText: '${_lampResistance.toStringAsFixed(1)} Ω', value: _lampResistance, min: .6, max: 2.4, divisions: 18, onChanged: (value) => setState(() => _lampResistance = value)),
    ])),
    const SizedBox(height: 12),
    SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionTitle('Hasil pengamatan'), const SizedBox(height: 8),
      LabeledValue(label: 'Arus alternator Iₐ', value: '${_currents.alternator.toStringAsFixed(2)} A'),
      const SizedBox(height: 6),
      LabeledValue(label: 'Arus aki Iᵦ (arah acuan)', value: '${_currents.battery.toStringAsFixed(2)} A'),
      const SizedBox(height: 6),
      LabeledValue(label: 'Arus lampu I꜀', value: '${_currents.lamp.toStringAsFixed(2)} A'),
      const SizedBox(height: 6),
      Text(_currents.battery < 0 ? 'Tanda negatif: arus aki berlawanan arah dengan arah acuan.' : 'Tanda positif: arus aki searah dengan arah acuan.', style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
      Text('Pemeriksaan cabang: Iₐ + Iᵦ = ${(_currents.alternator + _currents.battery).toStringAsFixed(2)} A = I꜀.', style: const TextStyle(color: AppColors.muted)),
    ])),
    const SizedBox(height: 12),
    LabChallengePanel(question: 'Tantangan: kembalikan R lampu ke 1,20 Ω. Apa arti tanda arus aki yang muncul?', onCheck: () => (_lampResistance - 1.2).abs() < 1e-9 && _currents.battery < 0, success: 'Arus aki bernilai negatif terhadap arah acuan; besar arusnya berlawanan arah.', retry: 'Gunakan nilai R lampu pada contoh buku, lalu baca tanda arus aki.'),
  ]);
}

class _PowerLab extends StatefulWidget {
  const _PowerLab();
  @override
  State<_PowerLab> createState() => _PowerLabState();
}

class _PowerLabState extends State<_PowerLab> {
  double _voltage = 12;
  double _resistance = 60;
  double _hours = 1;

  @override
  Widget build(BuildContext context) {
    final current = PhysicsCalculations.currentFromOhmsLaw(_voltage, _resistance);
    final power = PhysicsCalculations.powerWatts(_voltage, _resistance);
    final energy = PhysicsCalculations.energyKwh(power, _hours);
    return Column(children: [
      SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionTitle('Area eksperimen', icon: Icons.bolt),
        const SizedBox(height: 8),
        const Text('Ubah tegangan, hambatan beban, dan lama penggunaan. Amati daya serta energi yang dihitung.'),
        const SizedBox(height: 12),
        _SliderValue(label: 'Tegangan V', valueText: '${_voltage.toStringAsFixed(0)} V', value: _voltage, min: 1, max: 24, divisions: 46, onChanged: (value) => setState(() => _voltage = value)),
        _SliderValue(label: 'Hambatan R', valueText: '${_resistance.toStringAsFixed(0)} Ω', value: _resistance, min: 10, max: 1000, divisions: 99, onChanged: (value) => setState(() => _resistance = value)),
        _SliderValue(label: 'Lama penggunaan', valueText: '${_hours.toStringAsFixed(1)} jam', value: _hours, min: .5, max: 8, divisions: 15, onChanged: (value) => setState(() => _hours = value)),
        const SizedBox(height: 4),
        const CircuitDiagram(caption: 'Daya pada beban resistif: P = V I = V²/R.'),
      ])),
      const SizedBox(height: 12),
      SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionTitle('Hasil pengamatan'), const SizedBox(height: 8),
        LabeledValue(label: 'Arus I = V/R', value: '${current.toStringAsFixed(3)} A'),
        const SizedBox(height: 6), LabeledValue(label: 'Daya P = V²/R', value: '${power.toStringAsFixed(2)} W'),
        const SizedBox(height: 6), LabeledValue(label: 'Energi selama ${_hours.toStringAsFixed(1)} jam', value: '${energy.toStringAsFixed(5)} kWh'),
        const SizedBox(height: 7), const Text('Energi ditampilkan dari P × waktu. Tarif listrik tidak dihitung.', style: TextStyle(color: AppColors.muted)),
      ])),
      const SizedBox(height: 12),
      _PowerLawChallenge(
        key: ValueKey('power-challenge-${_voltage}_$_resistance'),
        voltageV: _voltage,
        resistanceOhm: _resistance,
      ),
    ]);
  }
}

class _SliderValue extends StatelessWidget {
  const _SliderValue({required this.label, required this.valueText, required this.value, required this.min, required this.max, required this.divisions, required this.onChanged});
  final String label;
  final String valueText;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) => Column(children: [
    Row(children: [Expanded(child: Text(label)), Text(valueText, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.navy))]),
    Slider(value: value.clamp(min, max).toDouble(), min: min, max: max, divisions: divisions, onChanged: onChanged),
  ]);
}

class _PowerLawChallenge extends StatefulWidget {
  const _PowerLawChallenge({super.key, required this.voltageV, required this.resistanceOhm});
  final double voltageV;
  final double resistanceOhm;

  @override
  State<_PowerLawChallenge> createState() => _PowerLawChallengeState();
}

class _PowerLawChallengeState extends State<_PowerLawChallenge> {
  int? _prediction;
  bool? _correct;

  @override
  Widget build(BuildContext context) => SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SectionTitle('Tantangan', icon: Icons.flag_outlined),
    const SizedBox(height: 7),
    const Text('Jika hambatan tetap dan tegangan digandakan, berapa kali daya semula?'),
    for (final factor in [2, 3, 4, 8])
      RadioListTile<int>(
        contentPadding: EdgeInsets.zero,
        dense: true,
        title: Text('$factor kali'),
        value: factor,
        groupValue: _prediction,
        onChanged: (value) => setState(() { _prediction = value; _correct = null; }),
      ),
    SizedBox(width: double.infinity, child: FilledButton(
      onPressed: _prediction == null ? null : () {
        final first = PhysicsCalculations.powerWatts(widget.voltageV, widget.resistanceOhm);
        final doubled = PhysicsCalculations.powerWatts(widget.voltageV * 2, widget.resistanceOhm);
        setState(() => _correct = _prediction == (doubled / first).round());
      },
      child: const Text('Periksa Jawaban'),
    )),
    if (_correct != null) Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        _correct! ? 'Benar. P = V²/R, sehingga tegangan dua kali menghasilkan daya empat kali saat R tetap.' : 'Belum tepat. Substitusikan 2V ke P = V²/R dengan hambatan yang sama.',
        style: TextStyle(color: _correct! ? AppColors.success : AppColors.warning, height: 1.4),
      ),
    ),
  ]));
}

class LabChallengePanel extends StatefulWidget {
  const LabChallengePanel({super.key, required this.question, required this.onCheck, required this.success, required this.retry});
  final String question;
  final bool Function() onCheck;
  final String success;
  final String retry;

  @override
  State<LabChallengePanel> createState() => _LabChallengePanelState();
}

class _LabChallengePanelState extends State<LabChallengePanel> {
  bool? _result;

  @override
  void didUpdateWidget(covariant LabChallengePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onCheck != oldWidget.onCheck) _result = null;
  }

  @override
  Widget build(BuildContext context) => SectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SectionTitle('Tantangan', icon: Icons.flag_outlined),
    const SizedBox(height: 7),
    Text(widget.question),
    const SizedBox(height: 10),
    FilledButton(onPressed: () => setState(() => _result = widget.onCheck()), child: const Text('Periksa Jawaban')),
    if (_result != null) Padding(padding: const EdgeInsets.only(top: 9), child: Text(_result! ? widget.success : widget.retry, style: TextStyle(color: _result! ? AppColors.success : AppColors.warning, height: 1.4))),
  ]));
}
