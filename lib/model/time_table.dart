import 'package:admin/model/class.dart';
import 'package:admin/model/shift.dart';
import 'package:admin/model/teacher.dart';

class TimeTable{
  String id;
  Class lop;
  Teacher teacher;
  Map<DateTime, List<Shift>> schedule;

  TimeTable(this.id, this.lop, this.teacher, this.schedule);
}