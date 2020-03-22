///    This program is free software: you can redistribute it and/or modify
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

import 'package:covid19mobile/resources/style/text_styles.dart';
import 'package:covid19mobile/ui/assets/colors.dart';
import 'package:covid19mobile/ui/screens/home/components/accordion.dart';
import 'package:covid19mobile/utils/launch_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class InitiativesItem extends StatelessWidget {
  final String title;
  final String body;
  final Function(bool) onExpansionChanged;

  const InitiativesItem(
      {Key key, this.title, this.body, this.onExpansionChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Accordion(
      key: key,
      withBorder: false,
      title: title,
      onExpansionChanged: onExpansionChanged,
      children: <Widget>[
        Html(
            useRichText: false,
            data: body.replaceAll("\\n", ""),
            backgroundColor: Colors.white,
            defaultTextStyle: Theme.of(context).textTheme.body1,
            onLinkTap: launchURL,
            linkStyle: Theme.of(context)
                .textTheme
                .body1
                .copyWith(color: Theme.of(context).primaryColor),
            customTextStyle: (dom.Node node, TextStyle baseStyle) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "b":
                    return TextStyles.subtitle(
                      color: Covid19Colors.darkGrey,
                    );
                  case "a":
                    return Theme.of(context).textTheme.body1.copyWith(
                          color: Theme.of(context).primaryColor,
                        );
                }
              }
              return baseStyle;
            },
            customRender: (node, children) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "custom_tag":
                    return Column(children: children);
                }
              }
              return null;
            })
      ],
    );
  }
}
