import 'package:cuidapet_mobile/app/core/ui/cuidapet_icons.dart';
import 'package:cuidapet_mobile/app/core/ui/extensions/size_screen_extension.dart';
import 'package:cuidapet_mobile/app/core/ui/extensions/theme_extension.dart';
import 'package:cuidapet_mobile/app/core/ui/widgets/cuidapet_rounded_button_with_icon.dart';
import 'package:cuidapet_mobile/app/models/social_type.dart';
import 'package:cuidapet_mobile/app/modules/auth/login/login_controller.dart';
import 'package:flutter/material.dart';

class LoginRegisterButton extends StatelessWidget {
  final LoginController _loginController;

  const LoginRegisterButton({
    required LoginController loginController,
    Key? key,
  })  : _loginController = loginController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        CuidapetRoundedButtonWithIcon(
          onTap: () {},
          color: const Color(0xFF4267B3),
          icon: CuidapetIcons.facebook_1,
          width: .42.sw,
          title: 'Facebook',
        ),
        CuidapetRoundedButtonWithIcon(
          onTap: () => _loginController.socialLogin(SocialType.google),
          color: const Color(0xFFE15030),
          icon: CuidapetIcons.google,
          width: .42.sw,
          title: 'Google',
        ),
        CuidapetRoundedButtonWithIcon(
          onTap: () => Navigator.pushNamed(context, '/auth/register/'),
          color: context.primaryColorDark,
          icon: Icons.mail,
          width: .42.sw,
          title: 'Cadastre-se',
        ),
      ],
    );
  }
}
