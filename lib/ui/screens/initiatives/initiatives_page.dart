///     This program is free software: you can redistribute it and/or modify
///    it under the terms of the GNU General Public License as published by
///    the Free Software Foundation, either version 3 of the License, or
///    (at your option) any later version.
///
///    This program is distributed in the hope that it will be useful,
///    but WITHOUT ANY WARRANTY; without even the implied warranty of
///    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
///    GNU General Public License for more details.
///
///    You should have received a copy of the GNU General Public License
///    along with this program.  If not, see <https://www.gnu.org/licenses/>.

import 'package:covid19mobile/bloc/app_bloc.dart';
import 'package:covid19mobile/bloc/base_bloc.dart';
import 'package:covid19mobile/generated/l10n.dart';
import 'package:covid19mobile/model/initiative_model.dart';
import 'package:covid19mobile/providers/initiatives_provider.dart';
import 'package:covid19mobile/resources/style/text_styles.dart';
import 'package:covid19mobile/ui/assets/colors.dart';
import 'package:covid19mobile/ui/core/base_stream_service_screen_page.dart';
import 'package:covid19mobile/ui/widgets/initiatives_item.dart';
import 'package:covid19mobile/ui/widgets/loading.dart';
import 'package:covid19mobile/ui/widgets/separator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitiativesPage extends BasePage {
  /// Initiatives page view
  InitiativesPage({Key key}) : super(key: key);

  @override
  _InitiativesPageState createState() => _InitiativesPageState();
}

class _InitiativesPageState extends BaseState<InitiativesPage, AppBloc> {
  /// For the initial list of initiatives
  List<InitiativeModel> _initiatives;

  /// ScrollController for changing the scroll position
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    /// TODO: in case of slow connection show loading?

    /// Gets all faqs from the Provider or the Modal Route arguments
    ///
    /// If pushing from home and faqs have initial data
    /// In case of no initial data reverts to fetch faqs
    /// and update with the Provider
    _initiatives = Provider.of<InitiativesProvider>(context).initiatives ??
        ModalRoute.of(context).settings.arguments;

    /// Check if have any data to present, if not show [CircularProgressIndicator]
    /// while wait for data
    var hasData = _initiatives != null && _initiatives.length > 0;

    return Scaffold(
      appBar: AppBar(
        iconTheme:
            Theme.of(context).iconTheme.copyWith(color: Covid19Colors.darkGrey),
        title: Text(
          S.of(context).initiativesPageTitle.toUpperCase(),
          style: TextStyles.h2(color: Covid19Colors.darkGreyLight),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.zero,
        child: hasData
            ? ListView.separated(
                controller: scrollController,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                        bottom: (index == _initiatives.length - 1) ? 18.0 : 0),
                    child: InitiativesItem(
                      title: _initiatives[index].title,
                      body: _initiatives[index].content,
                      onExpansionChanged: (value) {},
                    ),
                  );
                },
                separatorBuilder: (_, __) {
                  return ListSeparator(
                    color: Covid19Colors.lightGreyLight,
                  );
                },
                itemCount: _initiatives != null ? _initiatives.length : 0)
            : const Loading(),
      ),
    );
  }

  @override
  void initBloc(AppBloc bloc) {
    /// In case [_initiatives] is null then fetch if again

    var provider = Provider.of<InitiativesProvider>(context);

    if (provider.initiatives == null ||
        (provider.initiatives != null && provider.initiatives.isEmpty)) {
      bloc.getInitiatives();
    }
  }

  @override
  Stream<ResultStream> get onStateListener => bloc.onListener;

  @override
  void onStateResultListener(ResultStream result) {
    if (result is InitiativeResultStream) {
      /// Updates faqs list on the provider
      Provider.of<InitiativesProvider>(context, listen: false)
          .setInitiatives(result.model);

      /// Updates faqs list
      _initiatives = result.model;
    }
  }
}
