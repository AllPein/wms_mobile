import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'loading_state.dart';

class LoadingCubit extends Cubit<bool> {
  LoadingCubit() : super(false);

  void startLoading() {
    emit(true);
  }

  void stopLoading() {
    emit(false);
  }
}
