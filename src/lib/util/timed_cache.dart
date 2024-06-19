import 'dart:collection';

class TimedCache<K, V> {
  final int maxAge;
  final int maxEntries;
  final LinkedHashMap<K, _CacheEntry<V>> _cache;

  TimedCache(this.maxAge, {this.maxEntries = 200})
      : _cache = LinkedHashMap<K, _CacheEntry<V>>();

  V? get(K key) {
    final entry = _cache[key];
    if (entry == null) return null;
    if (DateTime.now().millisecondsSinceEpoch - entry.timestamp > maxAge) {
      _cache.remove(key);
      return null;
    }
    return entry.value;
  }

  bool contains(K key) {
    final entry = _cache[key];
    if (entry == null) return false;
    if (DateTime.now().millisecondsSinceEpoch - entry.timestamp > maxAge) {
      _cache.remove(key);
      return false;
    }
    return true;
  }

  void set(K key, V value) {
    final entry = _CacheEntry(value);
    _cache[key] = entry;
    if (_cache.length > maxEntries) {
      _cache.remove(_cache.keys.first);
    }
  }
}

class _CacheEntry<V> {
  final V value;
  final int timestamp;

  _CacheEntry(this.value) : timestamp = DateTime.now().millisecondsSinceEpoch;
}
