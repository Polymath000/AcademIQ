import 'dart:io';

void main() {
  var file = File('lib/features/main_layout/presentation/views/main_layout_view.dart');
  var content = file.readAsStringSync();
  
  content = content.replaceFirst('        return Scaffold(\n          backgroundColor: AppColors.bgDark,', 
'''        return Container(
          decoration: BoxDecoration(
            color: AppColors.bgDark,
            gradient: LinearGradient(
              colors: [
                AppColors.gradeWeak.withValues(alpha: 0.15),
                AppColors.brandIndigo.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Scaffold(
            backgroundColor: AppColors.transparent,''');

  content = content.replaceFirst('        );\n      },\n    );\n  }\n}', 
'''          ),
        );
      },
    );
  }
}''');

  content = content.replaceFirst(
'''          bottomNavigationBar: BottomAppBar(
            color: AppColors.bgDark.withValues(alpha: 0.9),''',
'''          bottomNavigationBar: BottomAppBar(
            color: AppColors.navBarPlum,''');

  file.writeAsStringSync(content);
}
