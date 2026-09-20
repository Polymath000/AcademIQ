import 'dart:io';

void main() {
  var file = File('lib/features/home/presentation/widgets/show_add_subject_dialog.dart');
  var content = file.readAsStringSync();
  
  content = content.replaceFirst('value: selectedGrade,', 'initialValue: selectedGrade,');
  content = content.replaceFirst('items: enabledGrades.map((grade) {', 'items: enabledGrades.map<DropdownMenuItem<String>>((grade) {');
  
  file.writeAsStringSync(content);
}
