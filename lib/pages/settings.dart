import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac/services/provider.dart';
import 'package:tic_tac/services/sound.dart';
import 'package:tic_tac/core/theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final soundService = locator<SoundService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: soundService.enableSound$,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final bool isSoundEnabled = snapshot.data ?? true;

        return Scaffold(
          backgroundColor: MyTheme.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text("SETTINGS"),
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: <Widget>[
                // بطاقة خيار الصوت
                _buildSettingsTile(
                  title: "Game Sound",
                  subtitle: "Enable or disable sound effects",
                  icon: isSoundEnabled ? Icons.volume_up : Icons.volume_off,
                  trailing: CupertinoSwitch(
                    value: isSoundEnabled,
                    activeTrackColor: MyTheme.orange,
                    onChanged: (val) {
                      soundService.enableSound$.add(val);
                      if (val) soundService.playSound('click');
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // يمكنك إضافة خيار آخر هنا مستقبلاً مثل الاهتزاز (Vibration)
                _buildSettingsTile(
                  title: "Vibrations",
                  subtitle: "Haptic feedback on moves",
                  icon: Icons.vibration,
                  trailing: CupertinoSwitch(
                    value: true,
                    activeTrackColor: MyTheme.red,
                    onChanged: (val) {},
                  ),
                ),

                const Spacer(),

                // نسخة التطبيق في الأسفل (لمسة احترافية)
                Text(
                  "Version 1.0.0",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.3), fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ودجت لبناء صفوف الإعدادات بشكل موحد
  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: MyTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MyTheme.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: MyTheme.orange, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5), fontSize: 13),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
