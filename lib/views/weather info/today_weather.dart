import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:stacked/stacked.dart';
import 'package:weather_app/mixins/data_handler.dart';
import 'package:weather_app/models/current_weather_response.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/views/weather%20info/weather_info_model.dart';
import 'package:weather_app/widget/error_info_widget.dart';
import 'package:weather_app/widget/progress_indicator.dart';

class TodayWeather extends ViewModelWidget<WeatherInfoModel> with DataHandler {
  CurrentWeatherResponse data;

  TodayWeather({@required this.data});
  @override
  Widget build(BuildContext context, WeatherInfoModel model) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: (model.fetchingWeatherData)
            ? ProgressIndicatorWidget()
            : (data == null)
                ? ErrorInfoWidget(
                    index: 0,
                  )
                : ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (data?.name != null &&
                                          data?.sys?.country != null)
                                      ? Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.mapMarkerAlt,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                '${data.name}, ${data.sys.country}'),
                                            // Spacer(),
                                          ],
                                        )
                                      : Container(),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.calendar,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(converTimeStamptoDate(data.dt)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.clock,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(fetchHours(data.dt))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  FittedBox(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${data?.main?.temp ?? '_'}',
                                          style: TextStyle(fontSize: 45),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                                height: 15,
                                                width: 15,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.black),
                                                  height: 10,
                                                  width: 10,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'K',
                                              style: TextStyle(fontSize: 30),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: orange)),
                                  child: OptimizedCacheImage(
                                    imageUrl: getIconURL(
                                        data.weather?.first?.icon ?? ''),
                                  ),
                                  // child: Image.network(
                                  //   getIconURL(data.weather.first.icon),
                                  //   fit: BoxFit.cover,
                                  //   alignment: Alignment.center,
                                  // ),
                                ))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(FontAwesomeIcons.temperatureHigh),
                              const SizedBox(height: 5),
                              Text(
                                '${data?.main?.tempMax ?? ''} k',
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Icon(FontAwesomeIcons.temperatureLow),
                              const SizedBox(height: 5),
                              Text(
                                '${data?.main?.tempMin ?? ''} k',
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        endIndent: 20,
                        indent: 20,
                        color: Colors.white60,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Cloudiness',
                                style: TextStyle(fontSize: 35),
                              ),
                              Text(
                                '${data?.clouds?.all ?? '_'}%',
                                style: TextStyle(fontSize: 25, color: orange),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Opacity(
                              opacity: data.clouds.all / 100,
                              child: Icon(
                                FontAwesomeIcons.cloudflare,
                                size: 60,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Humidity',
                                style: TextStyle(fontSize: 35),
                              ),
                              Text(
                                '${data?.main?.humidity ?? '_'}%',
                                style: TextStyle(fontSize: 25, color: orange),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Opacity(
                              opacity: data.main.humidity / 100,
                              child: Icon(
                                FontAwesomeIcons.water,
                                size: 60,
                              ),
                            ),
                          ),
                        ],
                      ),
                      MainItem(
                          data: Tag(
                              title: 'Pressure',
                              value: '${data?.main?.pressure ?? '_'} hPa')),
                      MainItem(
                          data: Tag(
                              title: 'Sea level',
                              value: '${data?.main?.sea_lvl ?? '_'} hPa')),
                      MainItem(
                          data: Tag(
                              title: 'Ground level',
                              value: '${data?.main?.grnd_lvl ?? '_'} hPa')),
                      // Text(
                      //   'Scattered Cloud',
                      //   style: TextStyle(color: Colors.lightBlue),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      WeatherInfoItem(
                        title: 'Wind',
                        data: [
                          Tag(
                              title: 'Speed',
                              value: "${data?.wind?.speed ?? '_'} m/s"),
                          Tag(title: 'Deg', value: '${data?.wind?.deg ?? '_'}')
                        ],
                      ),
                      WeatherInfoItem(
                        title: 'Snow',
                        data: [
                          Tag(
                              title: '1 Hour',
                              value: '${data?.snow?.first ?? '_'}'),
                          Tag(
                              title: '2 Hour',
                              value: '${data?.snow?.second ?? '_'}')
                        ],
                      ),
                      WeatherInfoItem(
                        title: 'Rain',
                        data: [
                          Tag(
                              title: '1 Hour',
                              value: '${data?.rain?.first ?? '-_'}'),
                          Tag(
                              title: '2 Hour',
                              value: '${data?.rain?.second ?? '_'}')
                        ],
                      ),

                      // Column((ChildBackButtonDispatcher))
                    ],
                  ));
  }
}

// class WeatherIcon extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child:,
//     );
//   }
// }

class WeatherInfoItem extends StatelessWidget {
  final String title;
  List<Tag> data = <Tag>[];
  WeatherInfoItem({@required this.title, @required this.data});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$title',
          // textAlign: TextAlign.center,
          style: TextStyle(color: orange, fontSize: 35),
        ),
        ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: List.generate(
            data.length,
            (index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${data[index].title}',
                    style: TextStyle(fontSize: 23),
                  ),
                  Text(
                    '${data[index].value}',
                    style: TextStyle(fontSize: 35),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Tag {
  String title;
  var value;
  Tag({@required this.title, @required this.value});
}

class MainItem extends StatelessWidget {
  final Tag data;
  MainItem({@required this.data});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          data.title,
          style: TextStyle(fontSize: 35),
        ),
        Text(
          data.value,
          style: TextStyle(fontSize: 25, color: orange),
        )
      ],
    );
  }
}
