import 'package:cuidapet_mobile/app/core/exceptions/failure_exception.dart';
import 'package:cuidapet_mobile/app/core/helpers/constants.dart';
import 'package:cuidapet_mobile/app/core/helpers/logger.dart';
import 'package:cuidapet_mobile/app/core/local_storages/local_storage.dart';
import 'package:cuidapet_mobile/app/repositories/user/user_repository.dart';
import 'package:cuidapet_mobile/app/services/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final Logger _log;
  final LocalStorage _localStorage;

  UserServiceImpl({
    required UserRepository userRepository,
    required Logger log,
    required LocalStorage localStorage,
  })  : _userRepository = userRepository,
        _log = log,
        _localStorage = localStorage;

  @override
  Future<void> register(String email, String password) async {
    try {
      await _userRepository.register(email, password);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e, s) {
      _log.error('Erro ao criar usuário no FirebaseAuth', e, s);
      throw FailureException(message: 'Erro ao criar usuário no FirebaseAuth');
    }
  }

  @override
  Future<void> login(String login, String password) async {
    try {
      final accessToken = await _userRepository.login(login, password);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: login,
        password: password,
      );

      await _saveAccessToken(accessToken);
    } on FirebaseAuthException catch (e, s) {
      _log.error('Erro ao fazer login no FirebaseAuth', e, s);
      throw FailureException(message: 'Erro ao fazer login no Firebase');
    }
  }

  Future<void> _saveAccessToken(String accessToken) async {
    await _localStorage.write(Constants.ACCESS_TOKEN_KEY, accessToken);
  }
}
