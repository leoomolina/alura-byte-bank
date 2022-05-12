import '../../components/container.dart';
import '../../components/localization/i18n_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/name.dart';
import 'dashboard_i18n.dart';
import 'dashboard_view.dart';

class DashboardContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NameCubit('Leonardo'),
      child: I18NLoadingContainer(
        viewKey: 'dashboard',
        creator: (messages) => DashboardView(DashboardViewLazyI18N(messages)),
      ),
    );
  }
}
