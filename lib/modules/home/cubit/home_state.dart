part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {
  const HomeLoaded(
      {required this.items, required this.equipments, required this.cells});

  final List<Item> items;
  final List<Equipment> equipments;
  final List<Cell> cells;

  @override
  List<Object> get props => [items, equipments, cells];
}

class HomeLoading extends HomeState {}
