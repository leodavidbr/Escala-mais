// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Escala Mais';

  @override
  String get climbingRoutes => 'Rotas de Escalada';

  @override
  String get noRoutesYet => 'Nenhuma rota ainda';

  @override
  String get tapToCreateFirstRoute =>
      'Toque no botão + para criar sua primeira rota';

  @override
  String get errorLoadingRoutes => 'Erro ao carregar rotas';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get routeDetails => 'Detalhes da Rota';

  @override
  String get routeNotFound => 'Rota não encontrada';

  @override
  String get goBack => 'Voltar';

  @override
  String get imageNotFound => 'Imagem não encontrada';

  @override
  String grade(String grade) {
    return 'Grau: $grade';
  }

  @override
  String created(String date) {
    return 'Criado em: $date';
  }

  @override
  String get errorLoadingRoute => 'Erro ao carregar rota';

  @override
  String get createRoute => 'Criar Rota';

  @override
  String get noImageSelected => 'Nenhuma imagem selecionada';

  @override
  String get takePhoto => 'Tirar Foto';

  @override
  String get chooseFromGallery => 'Escolher da Galeria';

  @override
  String get pleaseSelectImage => 'Por favor, selecione uma imagem';

  @override
  String error(String message) {
    return 'Erro: $message';
  }

  @override
  String get routeCreatedSuccessfully => 'Rota criada com sucesso!';

  @override
  String get tapToAddPhoto => 'Toque para adicionar foto';

  @override
  String get cameraOrGallery => 'Câmera ou Galeria';

  @override
  String get routeName => 'Nome da Rota *';

  @override
  String get enterRouteName => 'Digite o nome da rota';

  @override
  String get pleaseEnterRouteName => 'Por favor, digite um nome para a rota';

  @override
  String get difficultyGradeOptional => 'Grau de Dificuldade (Opcional)';

  @override
  String get gradeHint => 'ex.: 5.10a, V4, 6a+';

  @override
  String get saveRoute => 'Salvar Rota';

  @override
  String get settings => 'Configurações';

  @override
  String get darkModeTitle => 'Modo Escuro';

  @override
  String get darkModeSubtitle => 'Alternar o tema do aplicativo';

  @override
  String get resetDatabaseTitle => 'Redefinir Banco de Dados';

  @override
  String get resetDatabaseSubtitle =>
      'Apaga todas as rotas salvas e restaura os dados iniciais';

  @override
  String get termsOfUseTitle => 'Termos de Uso';

  @override
  String get termsOfUseSubtitle =>
      'Visualizar os termos e políticas do aplicativo';

  @override
  String get confirmResetTitle => 'Confirmar Redefinição';

  @override
  String get confirmResetMessage =>
      'Tem certeza que deseja apagar todas as rotas e reverter para o estado inicial?';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get resetButton => 'Redefinir';

  @override
  String get closeButton => 'Fechar';

  @override
  String get resetSuccess => 'Banco de dados redefinido com sucesso!';

  @override
  String get resetFailure => 'Falha ao redefinir o banco de dados.';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'Escala Mais';

  @override
  String get climbingRoutes => 'Rotas de Escalada';

  @override
  String get noRoutesYet => 'Nenhuma rota ainda';

  @override
  String get tapToCreateFirstRoute =>
      'Toque no botão + para criar sua primeira rota';

  @override
  String get errorLoadingRoutes => 'Erro ao carregar rotas';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get routeDetails => 'Detalhes da Rota';

  @override
  String get routeNotFound => 'Rota não encontrada';

  @override
  String get goBack => 'Voltar';

  @override
  String get imageNotFound => 'Imagem não encontrada';

  @override
  String grade(String grade) {
    return 'Grau: $grade';
  }

  @override
  String created(String date) {
    return 'Criado em: $date';
  }

  @override
  String get errorLoadingRoute => 'Erro ao carregar rota';

  @override
  String get createRoute => 'Criar Rota';

  @override
  String get noImageSelected => 'Nenhuma imagem selecionada';

  @override
  String get takePhoto => 'Tirar Foto';

  @override
  String get chooseFromGallery => 'Escolher da Galeria';

  @override
  String get pleaseSelectImage => 'Por favor, selecione uma imagem';

  @override
  String error(String message) {
    return 'Erro: $message';
  }

  @override
  String get routeCreatedSuccessfully => 'Rota criada com sucesso!';

  @override
  String get tapToAddPhoto => 'Toque para adicionar foto';

  @override
  String get cameraOrGallery => 'Câmera ou Galeria';

  @override
  String get routeName => 'Nome da Rota *';

  @override
  String get enterRouteName => 'Digite o nome da rota';

  @override
  String get pleaseEnterRouteName => 'Por favor, digite um nome para a rota';

  @override
  String get difficultyGradeOptional => 'Grau de Dificuldade (Opcional)';

  @override
  String get gradeHint => 'ex.: 5.10a, V4, 6a+';

  @override
  String get saveRoute => 'Salvar Rota';

  @override
  String get settings => 'Configurações';

  @override
  String get darkModeTitle => 'Modo Escuro';

  @override
  String get darkModeSubtitle => 'Alternar o tema do aplicativo';

  @override
  String get resetDatabaseTitle => 'Redefinir Banco de Dados';

  @override
  String get resetDatabaseSubtitle =>
      'Apaga todas as rotas salvas e restaura os dados iniciais';

  @override
  String get termsOfUseTitle => 'Termos de Uso';

  @override
  String get termsOfUseSubtitle =>
      'Visualizar os termos e políticas do aplicativo';

  @override
  String get confirmResetTitle => 'Confirmar Redefinição';

  @override
  String get confirmResetMessage =>
      'Tem certeza que deseja apagar todas as rotas e reverter para o estado inicial?';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get resetButton => 'Redefinir';

  @override
  String get closeButton => 'Fechar';

  @override
  String get resetSuccess => 'Banco de dados redefinido com sucesso!';

  @override
  String get resetFailure => 'Falha ao redefinir o banco de dados.';
}
