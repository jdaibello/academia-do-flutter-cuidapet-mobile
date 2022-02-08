import 'package:cuidapet_mobile/app/core/exceptions/failure_exception.dart';
import 'package:cuidapet_mobile/app/core/exceptions/user_exists_exception.dart';
import 'package:cuidapet_mobile/app/core/helpers/logger.dart';
import 'package:cuidapet_mobile/app/core/rest_client/rest_client.dart';
import 'package:cuidapet_mobile/app/core/rest_client/rest_client_exception.dart';
import 'package:cuidapet_mobile/app/repositories/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RestClient _restClient;
  final Logger _log;

  UserRepositoryImpl({
    required RestClient restClient,
    required Logger log,
  })  : _restClient = restClient,
        _log = log;

  @override
  Future<void> register(String email, String password) async {
    try {
      await _restClient.unauth().post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
        },
      );
    } on RestClientException catch (e, s) {
      // Validando se o usuário já existe na base de dados
      if (e.statusCode == 400 &&
          e.response?.data['message']
              .toLowerCase()
              .contains('user already registered')) {
        _log.error('Usuário já cadastrado', e, s);
        throw UserExistsException('Usuário já cadastrado');
      }

      _log.error('Erro ao registrar usuário', e, s);
      throw FailureException();
    }
  }
}
