# Local Notification Test App 

For Testing and Learning Local Notification

## Information

I made it by referring to the site below

- [[flutter] local notification Quick Start2 (ver 3.0.0)](https://velog.io/@adbr/flutter-local-notification-Quick-Start2)

There is a java.lang.NullPointerException error, So I've solved this problem by implementing as below code

```dart
void main() {
  runApp(MyApp());
  initNotiSetting(); // Init Local Notification After runApp
}
```