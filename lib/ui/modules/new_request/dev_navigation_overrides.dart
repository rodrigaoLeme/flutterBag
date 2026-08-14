import 'package:flutter/foundation.dart';

/// Overrides temporários de navegação para facilitar desenvolvimento de telas.
///
/// TODO(dev): colocar [skipAdvanceValidation] = false (ou apagar este arquivo)
/// quando o fluxo normal de validação voltar a ser necessário.
abstract final class DevNavigationOverrides {
  /// true => botões Avançar / seta direta ficam habilitados sem preencher
  /// steps e substeps (apenas em debug).
  static const bool skipAdvanceValidation = true;

  static bool get allowAdvanceWithoutFill =>
      kDebugMode && skipAdvanceValidation;
}
//botoes desativados
