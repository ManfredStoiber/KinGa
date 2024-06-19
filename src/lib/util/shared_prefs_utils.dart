import 'package:get_it/get_it.dart';
import 'package:kinga/constants/keys.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class SharedPrefsUtils {
  static void updateFinishedShowcases(String showcase) {
    List<String> finishedShowcases = GetIt.instance.get<StreamingSharedPreferences>().getStringList(Keys.finishedShowcases, defaultValue: []).getValue();
    finishedShowcases.add(showcase);
    GetIt.instance.get<StreamingSharedPreferences>().setStringList(Keys.finishedShowcases, finishedShowcases);
  }
}