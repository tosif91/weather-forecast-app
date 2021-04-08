class BaseData<T> {
  T data;
  int statusCode;
  String message;
  bool success;
  BaseData({this.data, this.message, this.success, this.statusCode = 0});
}
