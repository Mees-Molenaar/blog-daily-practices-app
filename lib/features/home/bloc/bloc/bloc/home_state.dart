part of 'home_bloc.dart';

@immutable
sealed class HomeState extends Equatable {
  final List<Practice> practices;

  const HomeState({required this.practices});

  @override
  List<Object> get props => [practices];
}

final class HomeInitial extends HomeState {
  const HomeInitial({required super.practices});
}

final class HomeLoading extends HomeState {
  const HomeLoading({required super.practices});
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({required super.practices});
}

final class HomeError extends HomeState {
  const HomeError({required super.practices});
}
