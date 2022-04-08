import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:durood_together_app/Screens/HomeTabs/Settings/send_feedback.dart';
import 'package:durood_together_app/Screens/HomeTabs/Settings/user_profile_editing.dart';
import 'package:durood_together_app/Services/Firebase/authentication.dart';
import 'package:durood_together_app/Services/theme_provider.dart';
import 'package:durood_together_app/Widgets/my_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MyScaffold(
      topHeight: 0,
      body: Expanded(
        child: SettingsList(
          darkTheme: SettingsThemeData(
            dividerColor: Theme.of(context).primaryColorDark,
            settingsTileTextColor: Theme.of(context).primaryColorDark,
            settingsListBackground: Theme.of(context).primaryColor,
            leadingIconsColor: Theme.of(context).primaryColorDark,
            tileDescriptionTextColor:
                Theme.of(context).primaryColorDark.withAlpha(200),
          ),
          lightTheme: SettingsThemeData(
            dividerColor: Theme.of(context).primaryColorDark,
            settingsTileTextColor: Theme.of(context).primaryColorDark,
            settingsListBackground: Theme.of(context).primaryColor,
            leadingIconsColor: Theme.of(context).primaryColorDark,
            tileDescriptionTextColor:
                Theme.of(context).primaryColorDark.withAlpha(200),
          ),
          sections: [
            SettingsSection(
              title: const Text(
                'Settings',
                style: TextStyle(
                  color: Constants.appHighlightColor,
                  fontSize: Constants.appHeading3Size,
                ),
              ),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  onPressed: (context) {},
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  value: const Text('English'),
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    setState(() {
                      darkMode = !darkMode;
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(darkMode);
                    });
                  },
                  initialValue: themeProvider.isDarkMode,
                  leading: const Icon(Icons.format_paint),
                  title: const Text('Dark mode'),
                ),
                SettingsTile.navigation(
                  title: const Text(
                    "Profile",
                  ),
                  leading: const Icon(Icons.person),
                  onPressed: (context) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const UserProfileEditing(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
                SettingsTile.navigation(
                  title: const Text(
                    "Feedback/Suggestion",
                  ),
                  leading: const Icon(Icons.sticky_note_2),
                  onPressed: (context) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SendFeedBack(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
                SettingsTile.navigation(
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Constants.appRedColor,
                    ),
                  ),
                  leading: const Icon(
                    Icons.logout,
                    color: Constants.appRedColor,
                  ),
                  onPressed: (context) {
                    logoutNow(context);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void logoutNow(context) {
    final provider = Provider.of<Auth>(context, listen: false);
    provider.signOut(context);
  }
}
