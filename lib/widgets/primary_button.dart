import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms_mobile/domain/blocs/cubit/loading_cubit.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool loading;
  final Widget child;
  PrimaryButton(
      {Key? key, this.onPressed, this.loading = false, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Theme.of(context).primaryColor,
          padding: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Center(child: BlocBuilder<LoadingCubit, bool>(
          builder: (context, state) {
            if (state) {
              return SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  backgroundColor: Colors.white,
                ),
              );
            }
            return DefaultTextStyle(
              child: child,
              style: TextStyle(color: Colors.white, fontSize: 16),
            );
          },
        )),
      ),
    );
  }
}
