import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

const _url = 'https://flutter-10333-default-rtdb.asia-southeast1.firebasedatabase.app';

/// Realtime Database instance. This region (asia-southeast1) needs the URL passed explicitly.
final db = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: _url);

/// Dates are stored as milliseconds since epoch.
DateTime? dateFrom(Object? ms) =>
    ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms as int);

/// Turns a snapshot value into (key, fields) pairs; empty when nothing is stored.
Iterable<MapEntry<String, Map<String, dynamic>>> entriesOf(Object? raw) {
  if (raw is! Map) return const [];
  return raw.entries.map(
      (e) => MapEntry(e.key as String, Map<String, dynamic>.from(e.value as Map)));
}