import 'package:cuidapet_mobile/app/core/ui/widgets/cuidapet_default_button.dart';
import 'package:cuidapet_mobile/app/core/ui/widgets/cuidapet_text_form_field.dart';
import 'package:cuidapet_mobile/app/modules/auth/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:validatorless/validatorless.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ModularState<LoginForm, LoginController> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          CuidapetTextFormField(
            controller: _emailEC,
            label: 'E-mail',
            validator: Validatorless.multiple([
              Validatorless.required('E-mail obrigatório'),
              Validatorless.email('E-mail inválido'),
            ]),
          ),
          const SizedBox(height: 10),
          CuidapetTextFormField(
            controller: _passwordEC,
            label: 'Senha',
            obscureText: true,
            validator: Validatorless.multiple([
              Validatorless.required('Senha obrigatória'),
              Validatorless.min(6, 'Senha deve conter pelo menos 6 caracteres'),
            ]),
          ),
          const SizedBox(height: 20),
          CuidapetDefaultButton(
            onPressed: () {
              final formValid = _formKey.currentState?.validate() ?? false;
              if (formValid) {
                controller.login(_emailEC.text, _passwordEC.text);
              }
            },
            label: 'Entrar',
          ),
        ],
      ),
    );
  }
}
