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

import 'package:covid19mobile/providers/slider_provider.dart';
import 'package:covid19mobile/resources/style/text_styles.dart';
import 'package:covid19mobile/ui/assets/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app.dart';
import 'card_home_slider_indicator.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({
    Key key,
  }) : super(key: key);

  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  final _controller = PageController(initialPage: 0);

  /// Builds the dots
  Widget _dots(int length) => Center(
        child: CardHomeSliderIndicator(
          controller: _controller,
          itemCount: length,
          color: Covid19Colors.green,
          onPageSelected: (int page) {
            _controller.animateToPage(
              page,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
        ),
      );

  /// Builds the PageView
  Widget _pageView(slides) => PageView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _controller,
        itemBuilder: (BuildContext context, int index) {
          if (index >= slides.length) {
            return null;
          }

          var slide = slides[index];

          return CardHomeSlide(
            titleLabel: slide.title,
            secondaryLabel: "Ver detalhe",
            backgroundPath: slide.image,
            onTap: () => _onSlideTap(slide),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    var sliderProvider = Provider.of<SliderProvider>(context);

    return Container(
      height: 138,
      child: sliderProvider.slider != null
          ? Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 128,
                  child: _pageView(sliderProvider.slider),
                ),
                Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: _dots(sliderProvider.slider.length))
              ],
            )
          : Container(),
    );
  }

  /// Callback to open Url on tap
  _onSlideTap(slide) {
    var urlToOpen = slide.url;
    if (urlToOpen.isEmpty) {
      return;
    }

    if (!(slide.url.startsWith("https://") ||
        slide.url.startsWith("http://"))) {
      urlToOpen = "https://${slide.url}";
    }
    _launch(urlToOpen);
  }

  /// Opens Url
  _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class CardHomeSlide extends StatelessWidget {
  const CardHomeSlide(
      {Key key,
      this.titleLabel,
      this.secondaryLabel,
      this.backgroundPath,
      this.onTap})
      : super(key: key);

  final String titleLabel;
  final String secondaryLabel;
  final String backgroundPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
            Image.network(
              backgroundPath,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
            Container(
              color: Covid19Colors.green50,
            ),
            Container(
                padding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                child: Stack(
                  children: <Widget>[
                    Text(
                      titleLabel.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyles.h1(color: Covid19Colors.white),
                    ),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Row(children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(5),
                                  height: 30,
                                  color: Covid19Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        secondaryLabel,
                                        style: TextStyles.subtitle(
                                            color: Covid19Colors.green),
                                      ),
                                      SizedBox(width: 7),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 16,
                                        color: Covid19Colors.green,
                                      )
                                    ],
                                  ))
                            ])))
                  ],
                ))
          ]),
        ));
  }
}
