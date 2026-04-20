import 'package:flutter/material.dart';

@immutable
class CustomStep {
  /// Creates a step for a [Stepper].
  ///
  /// The [title], [content], and [state] arguments must not be null.
  const CustomStep({
    required this.title,
    this.subtitle,
    this.content = const SizedBox(),
    this.state = StepState.indexed,
    this.isActive = false,
    required this.icon,
    this.isComplete = false,
  });

  /// The title of the step that typically describes it.
  final Widget title;

  /// The subtitle of the step that appears below the title and has a smaller
  /// font size. It typically gives more details that complement the title.
  ///
  /// If null, the subtitle is not shown.
  final Widget? subtitle;

  /// The content of the step that appears below the [title] and [subtitle].
  ///
  /// Below the content, every step has a 'continue' and 'cancel' button.
  final Widget content;

  /// The state of the step which determines the styling of its components
  /// and whether steps are interactive.
  final StepState state;

  /// Whether or not the step is active. The flag only influences styling.
  final bool isActive;

  final Widget icon;

  final bool isComplete;
}
