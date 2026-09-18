import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_calculator/config/theme/app_colors.dart';
import 'package:gpa_calculator/config/theme/app_text_styles.dart';
import 'package:gpa_calculator/core/constants/borders.dart';
import 'package:gpa_calculator/features/settings/data/models/grading_scale_model.dart';
import 'package:gpa_calculator/features/settings/presentation/cubit/settings_cubit.dart';

class GradeItemRow extends StatefulWidget {
  final GradingScaleModel grade;
  final int index;

  const GradeItemRow({super.key, required this.grade, required this.index});

  @override
  State<GradeItemRow> createState() => _GradeItemRowState();
}

class _GradeItemRowState extends State<GradeItemRow> {
  late TextEditingController _gpaController;
  late TextEditingController _scoreController;

  @override
  void initState() {
    super.initState();
    _gpaController = TextEditingController(text: widget.grade.gpa.toString());
    _scoreController = TextEditingController(
      text: widget.grade.minScore.toString(),
    );
  }

  @override
  void dispose() {
    _gpaController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  void _updateDraft() {
    final gpa = double.tryParse(_gpaController.text);
    final minScore = int.tryParse(_scoreController.text);
    if (gpa != null && minScore != null) {
      context.read<SettingsCubit>().updateDraftGrade(
        widget.index,
        gpa: gpa,
        minScore: minScore,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              widget.grade.letter,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Container(
              height: 40,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.bgDark,
                borderRadius: AppBorders.xs,
              ),
              child: TextField(
                controller: _scoreController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Min %',
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(bottom: 12),
                ),
                onChanged: (_) => _updateDraft(),
              ),
            ),
          ),

          Expanded(
            child: Container(
              height: 40,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: AppColors.bgDark,
                borderRadius: AppBorders.xs,
              ),
              child: TextField(
                controller: _gpaController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'GPA',
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(bottom: 12),
                ),
                onChanged: (_) => _updateDraft(),
              ),
            ),
          ),

          Switch(
            value: widget.grade.enable,
            activeThumbColor: AppColors.brandAccent,
            activeTrackColor: AppColors.brandPurple,
            inactiveThumbColor: AppColors.textMuted,
            inactiveTrackColor: AppColors.border,
            onChanged: (val) {
              context.read<SettingsCubit>().updateDraftGrade(
                widget.index,
                enable: val,
              );
            },
          ),
        ],
      ),
    );
  }
}
