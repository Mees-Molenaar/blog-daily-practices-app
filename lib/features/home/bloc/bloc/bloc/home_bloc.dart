import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:practices_repository/practices_repository.dart';
import 'package:logging/logging.dart';

part 'home_event.dart';
part 'home_state.dart';

final log = Logger('HomeBlocLogger');

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PracticesRepository _practicesRepository;

  HomeBloc({required PracticesRepository practicesRepository})
      : _practicesRepository = practicesRepository,
        super(const HomeInitial(practices: [])) {
    on<HomeLoad>(_onInitial);
  }

  void _onInitial(HomeLoad event, Emitter<HomeState> emit) {
    final practicesStream = _practicesRepository.getPractices();

    practicesStream.listen((practices) {
      emit(HomeLoaded(practices: practices));
    }).onError((error) {
      log.severe('Error while loading practices: $error');

      emit(const HomeError(practices: []));
    });
  }

  @override
  void onEvent(HomeEvent event) {
    super.onEvent(event);
    log.fine('Event: $event');
  }

  @override
  void onChange(Change<HomeState> change) {
    super.onChange(change);
    log.fine('Change: $change');
  }

  @override
  void onTransition(Transition<HomeEvent, HomeState> transition) {
    super.onTransition(transition);
    log.fine('Change: $transition');
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    log.severe('Error: $error');
  }
}
