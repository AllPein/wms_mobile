import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wms_mobile/domain/models/models.dart';
import 'package:wms_mobile/domain/repositories/home.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(HomeInitial());

  final HomeRepository _repository;

  void loadItems() async {
    emit(HomeLoading());
    final items = await _repository.fetchItems();
    final eqs = await _repository.fetchEquipments();
    final cells = await _repository.fetchCells();
    emit(HomeLoaded(items: items, equipments: eqs, cells: cells));
  }

  void loadCells() async {
    final cells = await _repository.fetchCells();
    final s = state as HomeLoaded;
    emit(HomeLoaded(items: s.items, equipments: s.equipments, cells: cells));
  }

  Future<void> updateItem(Item item) async {
    await _repository.updateItem(item);
    loadItems();
  }

  Future<void> updateCell(Item item) async {
    await _repository.updateItem(item);
    loadCells();
  }

  Future<void> addItem(Item item) async {
    
    await _repository.addItem(item);
    loadItems();
  }
}
