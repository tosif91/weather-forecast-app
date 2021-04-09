import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:stacked/stacked.dart';
import 'package:weather_app/mixins/data_handler.dart';
import 'package:weather_app/models/weather_forecast_response.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/views/weather%20info/weather_info_model.dart';
import 'package:weather_app/widget/error_info_widget.dart';
import 'package:weather_app/widget/progress_indicator.dart';

class WeatherForecast extends ViewModelWidget<WeatherInfoModel>
    with DataHandler {
  final WeatherForecastResponse data;
  WeatherForecast({@required this.data});
  @override
  Widget build(BuildContext context, WeatherInfoModel model) {
    return (model.fetchingForecastData)
        ? ProgressIndicatorWidget()
        : Container(
            child: (data == null)
                ? ErrorInfoWidget(
                    index: 1,
                  )
                : ListView.builder(
                    itemCount: model.dayForecastList.length,
                    itemBuilder: (context, index) => Card(
                          elevation: 10,
                          child: Container(
                            decoration: background,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Location',
                                            style: TextStyle(
                                                color: Colors.white60),
                                          ),
                                          Text(
                                            '${model?.currentWeatherResponse?.name ?? '_'},${model?.currentWeatherResponse?.sys?.country ?? '_'}',
                                            style: TextStyle(
                                                fontSize: 12, color: orange),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Date',
                                            style: TextStyle(
                                                color: Colors.white60),
                                          ),
                                          Text(
                                            converTimeStamptoDate(model
                                                .dayForecastList[index]
                                                .first
                                                .dt),
                                            style: TextStyle(
                                                fontSize: 12, color: orange),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                // Divider(
                                //   color: Colors.white54,
                                // ),
                                Container(
                                  height: 320,
                                  child: PageView(
                                    children: List.generate(
                                        model.dayForecastList[index].length,
                                        (subindex) => ForecastSubItem(
                                            data: model.dayForecastList[index]
                                                [subindex])),
                                  ),
                                )
                                // Container(
                                //   height: 200,
                                //   // width: MediaQuery.of(context).size.width,
                                //   child: ListView.builder(
                                //       scrollDirection: Axis.horizontal,
                                //       itemCount: 10,
                                //       itemBuilder: (context, index) =>
                                //           ForecastSubItem(
                                //               data: data.list[index])),
                                // )
                              ],
                            ),
                          ),
                        )

                    // ForecastSubItem(
                    //       data: data.list[index],
                    //     )
                    ),
          );
  }
}

class ForecastSubItem extends StatelessWidget with DataHandler {
  final ListElement data;
  ForecastSubItem({@required this.data});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 10,
      color: Colors.grey[400].withOpacity(.5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                fetchHours(data.dt),
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(10),
                      ),
                  child: Card(
                    margin: const EdgeInsets.all(0),
                    elevation: 10,
                    child: Container(
                      child: OptimizedCacheImage(
                        imageUrl: getIconURL(data?.weather?.first?.icon ?? ''),
                      ),
                      // child: Image.network(
                      //   getIconURL(data.weather.first.icon),
                      //   fit: BoxFit.cover,
                      //   alignment: Alignment.center,
                      //   errorBuilder: (context, o, s) => Icon(
                      //     Icons.broken_image_outlined,
                      //     color: orange,
                      //   ),
                      // ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FittedBox(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Icon(FontAwesomeIcons.temperatureHigh),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('${data?.main?.tempMax ?? '_'} K')
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Icon(FontAwesomeIcons.temperatureLow),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('${data?.main?.tempMin ?? '_'} K')
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Icon(FontAwesomeIcons.wind),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('${data?.wind?.speed ?? '_'} m/s')
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${data.weather?.first?.description ?? '_'}',
              style: TextStyle(fontSize: 19),
            ),
            Divider(),
            SubTag(
                title: 'Groud', value: '${data?.main?.grndLevel ?? '_'} hPa'),
            SubTag(title: 'Sea', value: '${data?.main?.seaLevel ?? '_'} hPa'),
            SubTag(title: 'Cloudiness', value: '${data?.clouds?.all ?? '_'} %'),
            SubTag(
                title: 'Humidity', value: '${data?.main?.humidity ?? '_'} %'),
            SubTag(title: 'Rain', value: '${data?.rain?.the3H ?? '_'} mm/3h'),
            SubTag(title: 'Snow', value: '${data?.snow?.the3H ?? '_'} mm/3h'),
            SubTag(title: 'Visibility', value: '${data?.visibility ?? '_'} m'),
          ],
        ),
      ),
    );
  }
}

class SubTag extends StatelessWidget {
  final String title;
  final String value;
  SubTag({@required this.title, @required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: Text(title)),
        Expanded(
          flex: 1,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              // textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16, color: orange),
            ),
          ),
        )
      ],
    );
  }
}
