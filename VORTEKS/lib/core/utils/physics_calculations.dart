import '../../data/models/content_models.dart';
import '../constants/learning_rules.dart';

class KirchhoffCurrents {
  const KirchhoffCurrents({
    required this.alternator,
    required this.battery,
    required this.lamp,
  });

  final double alternator;
  final double battery;
  final double lamp;
}

class PhysicsCalculations {
  const PhysicsCalculations._();

  static double currentFromCharge(double chargeC, double timeS) {
    if (timeS <= 0) throw ArgumentError.value(timeS, 'timeS', 'Must be positive.');
    return chargeC / timeS;
  }

  static double currentFromOhmsLaw(double voltageV, double resistanceOhm) {
    if (resistanceOhm <= 0) {
      throw ArgumentError.value(resistanceOhm, 'resistanceOhm', 'Must be positive.');
    }
    return voltageV / resistanceOhm;
  }

  static double crossSectionCircle(double diameterM) {
    if (diameterM <= 0) throw ArgumentError.value(diameterM, 'diameterM');
    final radius = diameterM / 2;
    return 3.141592653589793 * radius * radius;
  }

  /// Returns R/rho = length/area, not resistance in ohms.
  static double resistanceOverResistivity(double lengthM, double diameterM) {
    if (lengthM <= 0) throw ArgumentError.value(lengthM, 'lengthM');
    return lengthM / crossSectionCircle(diameterM);
  }

  static double seriesResistance(Iterable<double> resistances) {
    final values = resistances.toList();
    if (values.isEmpty || values.any((value) => value <= 0)) {
      throw ArgumentError('Series resistances must be positive and non-empty.');
    }
    return values.fold(0, (sum, value) => sum + value);
  }

  static double parallelResistance(Iterable<double> resistances) {
    final values = resistances.toList();
    if (values.isEmpty || values.any((value) => value <= 0)) {
      throw ArgumentError('Parallel resistances must be positive and non-empty.');
    }
    final conductance = values.fold<double>(0, (sum, value) => sum + 1 / value);
    return 1 / conductance;
  }

  static double lampVoltage({
    required double sourceVoltageV,
    required int lampCount,
    required bool parallel,
  }) {
    if (sourceVoltageV < 0 || lampCount <= 0) {
      throw ArgumentError('Voltage must not be negative and lamp count must be positive.');
    }
    return parallel ? sourceVoltageV : sourceVoltageV / lampCount;
  }

  /// Solves the two-loop car circuit in the textbook (pp. 37-38).
  static KirchhoffCurrents carCircuit({required double lampResistanceOhm}) {
    if (lampResistanceOhm <= 0) {
      throw ArgumentError.value(lampResistanceOhm, 'lampResistanceOhm');
    }
    const alternatorEmf = 14.0;
    const batteryEmf = 12.0;
    const alternatorInternalResistance = 0.1;
    const batteryInternalResistance = 0.01;

    // R_L I_C + r_b I_B = E_b; I_C = I_A + I_B.
    // r_a I_A - r_b I_B = E_a - E_b.
    final a = lampResistanceOhm;
    final b = lampResistanceOhm + batteryInternalResistance;
    final c = alternatorInternalResistance;
    final d = -batteryInternalResistance;
    final rhs1 = batteryEmf;
    final rhs2 = alternatorEmf - batteryEmf;
    final determinant = a * d - b * c;
    if (determinant.abs() < 1e-12) throw StateError('Circuit equations are singular.');
    final alternator = (rhs1 * d - b * rhs2) / determinant;
    final battery = (a * rhs2 - c * rhs1) / determinant;
    return KirchhoffCurrents(
      alternator: alternator,
      battery: battery,
      lamp: alternator + battery,
    );
  }

  static double powerWatts(double voltageV, double resistanceOhm) {
    if (resistanceOhm <= 0) throw ArgumentError.value(resistanceOhm, 'resistanceOhm');
    return voltageV * voltageV / resistanceOhm;
  }

  static double energyKwh(double powerW, double hours) {
    if (powerW < 0 || hours < 0) throw ArgumentError('Power and time must not be negative.');
    return powerW * hours / 1000;
  }

  static AssessmentOutcome assess({
    required List<LearningQuestion> questions,
    required Map<String, int> answers,
    int? passingPercent,
  }) {
    if (questions.isEmpty) throw ArgumentError('Assessment must contain questions.');
    final correct = questions.where((question) => answers[question.id] == question.correctIndex).length;
    final percent = (correct * 100 / questions.length).round();
    return AssessmentOutcome(
      correctCount: correct,
      total: questions.length,
      percent: percent,
      status: LearningRules.statusForPercent(percent, passingPercent: passingPercent),
    );
  }
}
