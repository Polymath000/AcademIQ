import 'show_edit_subject_dialog.dart';
import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../data/models/subject_model.dart';
import '../cubit/home_cubit.dart';

class SubjectListItem extends StatelessWidget {
  final SubjectModel subject;
  final HomeCubit cubit;

  const SubjectListItem({
    super.key,
    required this.subject,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    subject.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Text(
                    '${subject.credits} Cr.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.statusExcellent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.statusExcellent.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  subject.gradeLetter,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.statusExcellent,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.edit,
                  size: 20,
                  color: AppColors.textMuted,
                ),
                onPressed: () {
                  showEditSubjectDialog(context, cubit, subject);
                },
              ),
              const SizedBox(width: 4),
              IconButton(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.close,
                  size: 20,
                  color: AppColors.textMuted,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.navBarBg,
                      title: const Text('Delete Course'),
                      content: Text(
                        'Are you sure you want to delete \${subject.name}?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error.withValues(
                              alpha: 0.9,
                            ),
                          ),
                          onPressed: () {
                            cubit.deleteSubject(subject.id);
                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
