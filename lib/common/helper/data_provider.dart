abstract class IDataProvider {
  Future receiveData(String path);
  Future sendData(String path, dynamic data);
}