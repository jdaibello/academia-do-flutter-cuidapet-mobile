import 'package:cuidapet_mobile/app/core/exceptions/failure_exception.dart';
import 'package:cuidapet_mobile/app/core/helpers/constants.dart';
import 'package:cuidapet_mobile/app/core/helpers/logger.dart';
import 'package:cuidapet_mobile/app/core/local_storages/local_security_storage.dart';
import 'package:cuidapet_mobile/app/core/local_storages/local_storage.dart';
import 'package:cuidapet_mobile/app/models/social_network_model.dart';
import 'package:cuidapet_mobile/app/models/social_type.dart';
import 'package:cuidapet_mobile/app/repositories/social/social_repository.dart';
import 'package:cuidapet_mobile/app/repositories/user/user_repository.dart';
import 'package:cuidapet_mobile/app/services/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final Logger _log;
  final LocalStorage _localStorage;
  final LocalSecurityStorage _localSecurityStorage;
  final SocialRepository _socialRepository;

  UserServiceImpl({
    required UserRepository userRepository,
    required Logger log,
    required LocalStorage localStorage,
    required LocalSecurityStorage localSecurityStorage,
    required SocialRepository socialRepository,
  })  : _userRepository = userRepository,
        _log = log,
        _localStorage = localStorage,
        _localSecurityStorage = localSecurityStorage,
        _socialRepository = socialRepository;

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
      await _confirmLogin();
      await _getUserData();
    } on FirebaseAuthException catch (e, s) {
      _log.error('Erro ao fazer login no FirebaseAuth', e, s);
      throw FailureException(message: 'Erro ao fazer login no Firebase');
    }
  }

  @override
  Future<void> socialLogin(SocialType socialType) async {
    // Declarações
    String? email;

    try {
      final SocialNetworkModel socialModel;
      final AuthCredential authCredential;
      final firebaseAuth = FirebaseAuth.instance;

      switch (socialType) {
        case SocialType.google:
          // Chamar o login
          socialModel = await _socialRepository.googleLogin();
          authCredential = GoogleAuthProvider.credential(
            accessToken: socialModel.accessToken,
            idToken: socialModel.id,
          );
          break;
      }

      // Processo comum do login com rede social
      await firebaseAuth.signInWithCredential(authCredential);
      final accessToken = await _userRepository.socialLogin(socialModel);
      await _saveAccessToken(accessToken);
      await _confirmLogin();
      await _getUserData();
    } on FirebaseAuthException catch (e, s) {
      _log.error('Erro ao realizar login no Firebase', e, s);
      throw FailureException(message: 'Erro ao realizar login no Firebase');
    }
  }

  Future<void> _getUserData() async {
    final userLogged = await _userRepository.getUserLogged();
    await _localStorage.write<String>(
      Constants.USER_DATA_KEY,
      userLogged.toJson(),
    );
  }

  Future<void> _saveAccessToken(String accessToken) async {
    await _localStorage.write(Constants.ACCESS_TOKEN_KEY, accessToken);
  }

  Future<void> _confirmLogin() async {
    final confirmModel = await _userRepository.confirmLogin();
    await _saveAccessToken(confirmModel.accessToken);
    await _localSecurityStorage.write(
      Constants.REFRESH_TOKEN_KEY,
      confirmModel.refreshToken,
    );
  }
}
