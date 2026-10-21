import 'package:flutter_test/flutter_test.dart';
import 'package:vorteks/core/utils/physics_calculations.dart';

void main() {
  group('PhysicsCalculations', () {
    test('uses charge divided by time for current', () {
      expect(PhysicsCalculations.currentFromCharge(5, 30 * 60), closeTo(5 / 1800, 1e-12));
    });

    test('uses Ohm law for the reference 9 V and 100 ohm condition', () {
      expect(PhysicsCalculations.currentFromOhmsLaw(9, 100), closeTo(.09, 1e-12));
    });

    test('reports relative wire resistance factor through R over rho', () {
      final thin = PhysicsCalculations.resistanceOverResistivity(.6, .0001);
      final reference = PhysicsCalculations.resistanceOverResistivity(.6, .0005);
      expect(thin / reference, closeTo(25, 1e-10));
    });

    test('calculates series and parallel equivalents', () {
      expect(PhysicsCalculations.seriesResistance([2, 4, 6]), 12);
      expect(PhysicsCalculations.parallelResistance([6, 6]), 3);
    });

    test('reproduces the textbook two-source circuit example', () {
      final values = PhysicsCalculations.carCircuit(lampResistanceOhm: 1.2);
      expect(values.alternator, closeTo(19.1, .1));
      expect(values.battery, closeTo(-9, .1));
      expect(values.lamp, closeTo(10.1, .1));
      expect(values.alternator + values.battery, closeTo(values.lamp, 1e-12));
    });

    test('calculates power and energy separately', () {
      final power = PhysicsCalculations.powerWatts(12, 60);
      expect(power, closeTo(2.4, 1e-12));
      expect(PhysicsCalculations.energyKwh(power, 1), closeTo(.0024, 1e-12));
    });
  });
}
