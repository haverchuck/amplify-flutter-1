import 'dart:async';

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:meta/meta.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_datastore.dart';

class AmplifyDataStore extends DataStorePluginInterface {
  static final Object _token = Object();

  /// Constructs an AmplifyDataStore plugin
  AmplifyDataStore({@required List<ModelSchema> modelSchemas})
      : super(token: _token, modelSchemas: modelSchemas);

  static AmplifyDataStore _instance = AmplifyDataStoreMethodChannel();

  static set instance(DataStorePluginInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  @override
  Future<List<T>> query<T extends Model>(ModelType<T> modelType,
      {QueryPredicate where,
      QueryPagination pagination,
      List<QuerySortBy> sortBy}) async {
    return _instance.query(modelType,
        where: where, pagination: pagination, sortBy: sortBy);
  }

  @override
  Future<void> configure({List<ModelSchema> modelSchemas}) async {
    List<ModelSchema> schemas =
        modelSchemas == null ? this.modelSchemas : modelSchemas;
    if (schemas == null || schemas.isEmpty) {
      throw ArgumentError("Need to provide at least one modelSchema");
    }
    return _instance.configure(modelSchemas: schemas);
  }
}
