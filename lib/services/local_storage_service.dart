import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:weather_app/models/history_item_data.dart';

class LocalStorageService {
  Box _userInfoBox;
  Box _historyBox;
  Future<bool> initHive() async {
    try {
      final getappDocumentDirectory =
          //get path for hive
          await path_provider.getApplicationDocumentsDirectory();
      //intiliase hive.
      Hive.init(getappDocumentDirectory.path);
      Hive.registerAdapter(HistoryItemDataAdapter());
      return true;
    } catch (e) {
      return false;
    }
  }

  getHistoryLength() => _historyBox.length;
  HistoryItemData retrieveItem(int index) {
    return _historyBox.get(index) as HistoryItemData;
  }

  clearLocalState() {
    _userInfoBox?.clear();
    _historyBox?.clear();
  }

  openHiveBox() async {
    try {
      _userInfoBox = await Hive.openBox('userstate');
      _historyBox = await Hive.openBox<HistoryItemData>('history');
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  bool filterTrackHistory(HistoryItemData data) {
    var result;

    try {
      result =
          _historyBox.values.firstWhere((element) => data.name == element.name);
      return true;
    } catch (e) {
      return false;
    }
  }

  saveHistoy(HistoryItemData data) async {
    await _historyBox.add(data);
  }

  List<HistoryItemData> fetchHistory() {
    List<HistoryItemData> data = _historyBox.values;
    return data;
  }

  Future updateInfoMap(Map<dynamic, dynamic> data) async {
    // dont know whether it will remove previous value and update this map ??
    if (data != null)
      return await _userInfoBox
          .putAll(data)
          .then((value) => true)
          .catchError((onError) => false);
    return true;
  }

  Future updateSingleInfo({@required String key, @required var value}) async {
    if (value != null)
      return await _userInfoBox.put(key, value).then((value) {
        print('saved value $key ie ${_userInfoBox.get(key)}');
        return true;
      }).catchError((onError) => false);

    // return true;
  }

  dynamic fetchLocalData({@required String key}) {
    return _userInfoBox.get(key, defaultValue: null);
  }

  resetLocalStorage() async {
    await _userInfoBox.clear();
  }
}
