// sample.dart
import 'package:creator/creator.dart';
//
//
//
//Simple creators bind to UI.
final cityCreator = Creator.value('London');
final unitCreator = Creator.value('Fahrenheit');
// repo.dart
// final counter = Creator.value(0);
final counter = Creator((ref)=>0);
final doubleCreator = Creator((ref) => ref.watch(counter) * 2);
// Pretend calling a backend service to get fahrenheit temperature.
Future<int> getFahrenheit(String city) async {
  await Future.delayed(const Duration(milliseconds: 100));
  return 60 + city.hashCode % 20;
}
// Write fluid code with methods like map, where, etc.
final fahrenheitCreator = cityCreator.asyncMap(getFahrenheit);

// Combine creators for business logic.
final temperatureCreator = Emitter<String>((ref, emit) async {
  final f = await ref.watch(fahrenheitCreator);
  final unit = ref.watch(unitCreator);
  emit(unit == 'Fahrenheit' ? '$f F' : '${f2c(f)} C');
});

// Fahrenheit to celsius converter.
int f2c(int f) => ((f - 32) * 5 / 9).round();