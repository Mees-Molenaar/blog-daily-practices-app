import 'package:practices_api/src/models/practice.dart';

abstract class PracticesApi {
  const PracticesApi();

  Stream<List<Practice>> getPractices();
}
