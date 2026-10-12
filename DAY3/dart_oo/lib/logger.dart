/// 日志是一项可复用能力，无须占用宿主的父类位置。
mixin Logger {
  void log(String message) => print('[$runtimeType] $message');
}
