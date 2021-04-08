import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:weather_app/models/history_item_data.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/styles.dart';
import 'package:weather_app/views/history/history_model.dart';
import 'package:weather_app/widget/progress_indicator.dart';

class HistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HistoryModel>.reactive(
        viewModelBuilder: () => HistoryModel(),
        onModelReady: (model) => model.initialize(),
        builder: (context, model, _) => Scaffold(
            appBar: AppBar(
              title: Text('Location History'),
            ),
            body: (model.isBusy)
                ? ProgressIndicatorWidget()
                : (model.historyLength == 0)
                    ? Center(
                        child: Container(
                        child: Text(
                          'no history found!',
                          style: headingwhite,
                        ),
                      ))
                    : Container(
                        child: ListView.builder(
                          itemCount: model.historyLength,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () => model.navigateToWeatherInfo(
                                model.retrieveItem(index)),
                            child: HistoryItem(
                              data: model.retrieveItem(index),
                            ),
                          ),
                        ),
                      )));
  }
}

class HistoryItem extends StatelessWidget {
  final HistoryItemData data;
  HistoryItem({@required this.data});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: background,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  (data?.name == null) ? '_' : '${data.name} ',
                  style: TextStyle(fontSize: 22),
                ),
                Text(
                  (data?.country == null) ? '_' : '${data.country}',
                  style: TextStyle(fontSize: 22, color: orange),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                LocationItem(coordinate: data.lat, title: 'lat'),
                LocationItem(coordinate: data.lon, title: 'lon')
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LocationItem extends StatelessWidget {
  final double coordinate;
  final String title;
  LocationItem({@required this.coordinate, @required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: orange)),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white60, fontSize: 18),
          ),
          Text(
            '${coordinate.toStringAsFixed(4)}',
            style: TextStyle(color: orange, fontSize: 20),
          )
        ],
      ),
    );
  }
}
