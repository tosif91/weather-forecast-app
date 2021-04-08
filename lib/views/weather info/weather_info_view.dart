import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/views/weather%20info/today_weather.dart';
import 'package:weather_app/views/weather%20info/weather_forecast.dart';
import 'package:weather_app/views/weather%20info/weather_info_model.dart';

class WeatherInfoView extends StatefulWidget {
  final LatLng position;
  WeatherInfoView({@required this.position});

  @override
  _WeatherInfoViewState createState() => _WeatherInfoViewState();
}

class _WeatherInfoViewState extends State<WeatherInfoView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    print('called main booking init state');
    _tabController = new TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WeatherInfoModel>.reactive(
      viewModelBuilder: () => WeatherInfoModel(),
      onModelReady: (model) => model.initialize(widget.position),
      builder: (context, model, _) => Scaffold(
          appBar: AppBar(
            title: Text(
              'WeatherInfo',
              // style: TextStyle(color: neonOrangeColor),
            ),
            centerTitle: true,
            bottom: TabBar(
              unselectedLabelColor: Colors.white,
              labelColor: Colors.white,
              tabs: [
                const Tab(
                  text: 'Todays Weather',
                ),
                const Tab(text: 'Forecast'),
              ],
              controller: _tabController,
              indicatorColor: orange,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            bottomOpacity: 1,
          ),
          floatingActionButton: (model.isSaved)
              ? null
              : FloatingActionButton(
                  backgroundColor: orange,
                  onPressed: () => model.saveToHistory(),
                  child: Icon(
                    Icons.add_location_alt_outlined,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
          body: TabBarView(
            children: [
              TodayWeather(
                data: model.currentWeatherResponse,
              ),
              WeatherForecast(
                data: model.weatherForecastResponse,
              )
            ],
            controller: _tabController,
          )),
    );
  }
}
