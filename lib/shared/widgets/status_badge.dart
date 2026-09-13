import 'package:flutter/material.dart';

import 'package:catlab_studios/core/l10n/localized_text.dart';
import 'package:catlab_studios/data/models/app_status.dart';

/// Small dot-and-label badge showing where a project stands.
/// AI-hint: Colours come from AppStatus — never hard-code one here.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status, this.compact = false});

  final AppStatus status;

  /// Drops the padding and border for use inside dense card headers.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final label = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: status.color,
            boxShadow: [
              BoxShadow(color: status.color.withAlpha(120), blurRadius: 6),
            ],
          ),
        ),
        const SizedBox(width: 7),
        // Flexible so a longer translation shrinks instead of overflowing:
        // "In Development" is 14 characters, "Fortgeschritten" is 15, and the
        // card header that holds this badge has no slack to give.
        Flexible(
          child: Text(
            context.t(status.label),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: status.color,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );

    if (compact) return label;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status.color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color.withAlpha(60)),
      ),
      child: label,
    );
  }
}
