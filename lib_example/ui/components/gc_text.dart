import 'package:flutter/material.dart';

import '../../share/utils/app_color.dart';
import 'enum/design_system_enums.dart';
import 'themes/gc_styles.dart';

// ignore: must_be_immutable
class GcText extends StatefulWidget {
  final String text;
  final TextOverflow? overflow;
  final int? maxLines;
  TextStyle? style;
  final TextAlign? textAlign;
  final bool? softWrap;
  final GcTextSizeEnum textSize;
  final GcTextStyleEnum textStyleEnum;
  final Color? color;
  final GcStyles gcStyles;

  GcText({
    super.key,
    required this.text,
    this.overflow,
    this.maxLines,
    this.style,
    this.textAlign,
    this.softWrap,
    this.textSize = GcTextSizeEnum.h1,
    this.textStyleEnum = GcTextStyleEnum.regular,
    this.color,
    required this.gcStyles,
  }) {
    if (textStyleEnum == GcTextStyleEnum.regular) {
      fontRegularStyleResolver(textSize, gcStyles);
    } else {
      fontBoldStyleResolver(textSize);
    }
  }

  @override
  State<GcText> createState() => _GcTextState();

  void fontRegularStyleResolver(
      GcTextSizeEnum textSizeEnum, GcStyles gcStyles) {
    switch (textSizeEnum) {
      case GcTextSizeEnum.h1:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 32.0,
          letterSpacing: 0.37,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.h28:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 28.0,
          letterSpacing: 0.36,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.h2:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 24.0,
          letterSpacing: 0.36,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.h3:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 20.0,
          letterSpacing: 0.35,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.h3w5:
        styleStyleModifier(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
          letterSpacing: 0.38,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.h4:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
          letterSpacing: 0.38,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.h4w500:
        styleStyleModifier(
          fontWeight: FontWeight.w500,
          fontSize: 18.0,
          letterSpacing: 0.38,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;

      case GcTextSizeEnum.headline:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
          letterSpacing: -0.41,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.body:
        styleStyleModifier(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
          letterSpacing: -0.41,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.callout:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          letterSpacing: -0.32,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.subheadline:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          letterSpacing: -0.24,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.subhead:
        styleStyleModifier(
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
          letterSpacing: -0.24,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.footnote:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 13.0,
          letterSpacing: -0.08,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.caption1:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 12.0,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.caption2:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 10.0,
          letterSpacing: 0.07,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.handModel:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          letterSpacing: 0.07,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.subheadlineW400:
        styleStyleModifier(
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
          letterSpacing: -0.5,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
    }
  }

  void fontBoldStyleResolver(GcTextSizeEnum textSizeEnum) {
    switch (textSizeEnum) {
      case GcTextSizeEnum.h1:
        styleStyleModifier(
          fontWeight: FontWeight.w700,
          fontSize: 32.0,
          letterSpacing: 0.37,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.h28:
        styleStyleModifier(
          fontWeight: FontWeight.w700,
          fontSize: 28.0,
          letterSpacing: 0.36,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.h2:
        styleStyleModifier(
          fontWeight: FontWeight.w700,
          fontSize: 24.0,
          letterSpacing: 0.36,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.h3w5:
        styleStyleModifier(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
          letterSpacing: 0.38,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.h3:
        styleStyleModifier(
          fontWeight: FontWeight.w700,
          fontSize: 20.0,
          letterSpacing: 0.35,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.h4:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
          letterSpacing: 0.38,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.h4w500:
        styleStyleModifier(
          fontWeight: FontWeight.w700,
          fontSize: 18.0,
          letterSpacing: 0.38,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.headline:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
          letterSpacing: -0.41,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.body:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
          letterSpacing: -0.41,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.callout:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
          letterSpacing: -0.32,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.subheadline:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
          letterSpacing: -0.5,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.subhead:
        styleStyleModifier(
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
          letterSpacing: -0.24,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.subheadlineW400:
        styleStyleModifier(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          letterSpacing: -0.5,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.footnote:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 13.0,
          letterSpacing: -0.08,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.caption1:
        styleStyleModifier(
          fontWeight: FontWeight.w700,
          fontSize: 12.0,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;
      case GcTextSizeEnum.caption2:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 10.0,
          letterSpacing: 0.06,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.primaryLight),
        );
        break;

      case GcTextSizeEnum.handModel:
        styleStyleModifier(
          fontWeight: FontWeight.w600,
          fontSize: 10.0,
          letterSpacing: 0.06,
          fontFamily: TypographyHelper.getFontFamily(gcStyles),
          color: color ?? (style?.color ?? AppColors.black),
        );
        break;
    }
  }

  void styleStyleModifier({
    bool inherit = true,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? lineHeight,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? fontFamily,
    TextOverflow? overflow,
  }) {
    style = TextStyle(
      inherit: inherit,
      color: color ?? style?.color,
      backgroundColor: backgroundColor ?? style?.backgroundColor,
      fontSize: fontSize ?? style?.fontSize,
      fontWeight: fontWeight ?? style?.fontWeight,
      fontStyle: fontStyle ?? style?.fontStyle,
      letterSpacing: letterSpacing ?? style?.letterSpacing,
      wordSpacing: wordSpacing ?? style?.wordSpacing,
      textBaseline: textBaseline ?? style?.textBaseline,
      height: lineHeight ?? style?.height,
      locale: locale ?? style?.locale,
      foreground: foreground ?? style?.foreground,
      background: background ?? style?.background,
      shadows: style?.shadows,
      fontFeatures: style?.fontFeatures,
      fontVariations: style?.fontVariations,
      decoration: decoration ?? style?.decoration,
      decorationColor: decorationColor ?? style?.decorationColor,
      decorationStyle: decorationStyle ?? style?.decorationStyle,
      decorationThickness: decorationThickness ?? style?.decorationThickness,
      debugLabel: style?.debugLabel,
      fontFamily: fontFamily ?? style?.fontFamily,
      fontFamilyFallback: style?.fontFamilyFallback,
      overflow: overflow ?? style?.overflow,
    );
  }
}

class _GcTextState extends State<GcText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      overflow: widget.overflow,
      maxLines: widget.maxLines,
      style: widget.style,
      textAlign: widget.textAlign,
      softWrap: widget.softWrap,
    );
  }
}
