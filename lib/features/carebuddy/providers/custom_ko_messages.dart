import 'package:timeago/timeago.dart';

class MyCustomKomassages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '전';
  @override
  String suffixFromNow() => '후';

  // 여기서부터 원하는 문구로 수정하세요!
  @override
  String lessThanOneMinute(int seconds) => '방금';
  @override
  String aboutAMinute(int minutes) => '1분';
  @override
  String minutes(int minutes) => '$minutes분';
  @override
  String aboutAnHour(int minutes) => '1시간';
  @override
  String hours(int hours) => '$hours시간';
  @override
  String aDay(int hours) => '하루';
  @override
  String days(int days) => '$days일';
  @override
  String aboutAMonth(int days) => '한 달';
  @override
  String months(int months) => '$months개월';
  @override
  String aboutAYear(int year) => '1년';
  @override
  String years(int years) => '$years년';
  @override
  String wordSeparator() => ' ';
}
