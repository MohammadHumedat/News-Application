import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/core/models/article_model.dart';

import 'package:news_app/core/utils/constants/app_constants.dart';

class LocalDataBaseHive {
  static Future<void> initHive() async {
    Hive.initFlutter();
    Hive.registerAdapter(ArticleAdapter());
    Hive.registerAdapter(SourceAdapter());
  }

  Future<void> saveData<T>(String key, T value) async {
    final box = await Hive.openBox(AppConstants.localDatabaseBoxName);
    await box.put(key, value);
  }

  Future<T?> getData<T>(String key) async {
    final box = await Hive.openBox(AppConstants.localDatabaseBoxName);
    return box.get(key) as T?;
  }

  Future<void> deleteData(String key) async {
    final box = await Hive.openBox(AppConstants.localDatabaseBoxName);
    await box.delete(key);
  }
}
