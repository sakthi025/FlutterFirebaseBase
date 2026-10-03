import 'package:cloud_firestore/cloud_firestore.dart';
import '../logging/app_logger.dart';

/// Generic Database Layer service wrapping [FirebaseFirestore].
/// Supports CRUD operations, streams, pagination, and batch operations.
class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  FirebaseFirestore get rawInstance => _firestore;

  /// Get collection reference
  CollectionReference<Map<String, dynamic>> collection(String collectionPath) {
    return _firestore.collection(collectionPath);
  }

  /// Create or overwrite document with a specific ID
  Future<void> setDocument({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    try {
      AppLogger.instance.debug('Firestore SET: $collectionPath/$docId');
      await _firestore
          .collection(collectionPath)
          .doc(docId)
          .set(data, SetOptions(merge: merge));
    } catch (e, stack) {
      AppLogger.instance.error('Firestore SET error on $collectionPath/$docId', e, stack);
      rethrow;
    }
  }

  /// Add document with auto-generated ID
  Future<DocumentReference<Map<String, dynamic>>> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    try {
      AppLogger.instance.debug('Firestore ADD: $collectionPath');
      return await _firestore.collection(collectionPath).add(data);
    } catch (e, stack) {
      AppLogger.instance.error('Firestore ADD error on $collectionPath', e, stack);
      rethrow;
    }
  }

  /// Fetch a single document by ID
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      AppLogger.instance.debug('Firestore GET: $collectionPath/$docId');
      return await _firestore.collection(collectionPath).doc(docId).get();
    } catch (e, stack) {
      AppLogger.instance.error('Firestore GET error on $collectionPath/$docId', e, stack);
      rethrow;
    }
  }

  /// Real-time stream of a single document
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument({
    required String collectionPath,
    required String docId,
  }) {
    return _firestore.collection(collectionPath).doc(docId).snapshots();
  }

  /// Fetch a collection query
  Future<QuerySnapshot<Map<String, dynamic>>> getCollection({
    required String collectionPath,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)? queryBuilder,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }
      return await query.get();
    } catch (e, stack) {
      AppLogger.instance.error('Firestore GET Collection error on $collectionPath', e, stack);
      rethrow;
    }
  }

  /// Real-time stream of a collection with optional query filtering
  Stream<List<T>> streamCollection<T>({
    required String collectionPath,
    required T Function(Map<String, dynamic> data, String id) fromFirestore,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)? queryBuilder,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  /// Update specific fields in a document
  Future<void> updateDocument({
    required String collectionPath,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      AppLogger.instance.debug('Firestore UPDATE: $collectionPath/$docId');
      await _firestore.collection(collectionPath).doc(docId).update(data);
    } catch (e, stack) {
      AppLogger.instance.error('Firestore UPDATE error on $collectionPath/$docId', e, stack);
      rethrow;
    }
  }

  /// Delete document by ID
  Future<void> deleteDocument({
    required String collectionPath,
    required String docId,
  }) async {
    try {
      AppLogger.instance.debug('Firestore DELETE: $collectionPath/$docId');
      await _firestore.collection(collectionPath).doc(docId).delete();
    } catch (e, stack) {
      AppLogger.instance.error('Firestore DELETE error on $collectionPath/$docId', e, stack);
      rethrow;
    }
  }

  /// Execute batched writes atomically
  Future<void> runBatch(
    Future<void> Function(WriteBatch batch) batchFunction,
  ) async {
    final batch = _firestore.batch();
    await batchFunction(batch);
    await batch.commit();
  }
}
