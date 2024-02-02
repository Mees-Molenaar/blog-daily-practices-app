import 'package:practices_api/practices_api.dart';

class PracticesRepository {
  final PracticesApi _practicesApi;

  PracticesRepository({required PracticesApi practicesApi})
      : _practicesApi = practicesApi;

  Stream<List<Practice>> getPractices() => _practicesApi.getPractices();
}
