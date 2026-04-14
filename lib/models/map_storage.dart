import 'dart:convert';

import 'package:toruru/common/utils/app_storage.dart';
import 'package:toruru/models/map_data.dart';

class MapStorage {
  static const _key = 'custom_maps';

  static List<MapData> loadAll() {
    final raw = AppStorage.instance.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => MapData.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static void save(MapData map) {
    final maps = loadAll();
    final idx = maps.indexWhere((m) => m.id == map.id);
    if (idx >= 0) {
      maps[idx] = map;
    } else {
      maps.add(map);
    }
    _writeAll(maps);
  }

  static void delete(String mapId) {
    final maps = loadAll();
    maps.removeWhere((m) => m.id == mapId);
    _writeAll(maps);
  }

  static String export(MapData mapData) {
    return const JsonEncoder.withIndent('  ').convert(mapData.toJson());
  }

  static MapData? import(String jsonStr) {
    try {
      return MapData.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static void _writeAll(List<MapData> maps) {
    final encoded = jsonEncode(maps.map((m) => m.toJson()).toList());
    AppStorage.instance.setString(_key, encoded);
  }
}
