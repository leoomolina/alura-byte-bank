import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../http/webclients/i18n_webclient.dart';
import '../container.dart';
import 'i18n_cubit.dart';
import 'i18n_loadingview.dart';

class I18NLoadingContainer extends BlocContainer {
  I18NWidgetCreator? creator;
  String? viewKey;

  I18NLoadingContainer(
      {required String? viewKey, required I18NWidgetCreator? creator}) {
    this.viewKey = viewKey!;
    this.creator = creator!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<I18NMessagesCubit>(
      create: (BuildContext context) {
        final cubit = I18NMessagesCubit(this.viewKey!);
        cubit.reload(i18NWebClient(viewKey!));
        return cubit;
      },
      child: I18NLoadingView(this.creator!),
    );
  }
}
