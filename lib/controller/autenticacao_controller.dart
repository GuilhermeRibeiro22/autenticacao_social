import 'package:autenticacao_social/model/autenticacao_model.dart';

class AutenticacaoController {
  final AutenticacaoModel autenticacaoModel = AutenticacaoModel();

  Future<void> logar() async{
    await autenticacaoModel.entrarComGoogle();
  }

  Future<void> deslogar() async {
    await autenticacaoModel.deslogar();
  }
}