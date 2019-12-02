import 'package:flutter/cupertino.dart';

import 'exercise_bloc.dart';

class BlocProvider extends InheritedWidget {
  final ExerciseBloc bloc;
  Widget child;

  BlocProvider({this.child})
      : bloc = ExerciseBloc(),
        super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static BlocProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(BlocProvider);
  }
}
