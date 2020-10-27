/*
 * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

library model;

abstract class Model {
  final String id;
  final ModelType instanceType;

  const Model({this.id, this.instanceType});

  String getId() {
    return id;
  }

  Map<String, dynamic> toJson();
}

enum ModelOperation { CREATE, UPDATE, DELETE, READ }

// New ModelType superclass
abstract class ModelType<T extends Model> {
  const ModelType();

  T fromJson(Map<String, dynamic> jsonData);

  String modelName() {
    return T.toString();
  }

  /// Perform [action] with [T] as type argument.
  R callWithType<R>(R Function<T>() action) => action<T>();

  // Checks and casts.
  bool isInstance(Object o) => o is T;
  T cast(Object o) => o as T;
  T safeCast(Object o) => o is T ? o : null;

  // Subtyping checks.
  bool operator >=(ModelType other) => other is ModelType<T>;
  bool operator <=(ModelType other) => other >= this;
  bool operator <(ModelType other) => other >= this && !(this >= other);
  bool operator >(ModelType other) => this >= other && !(other >= this);
  bool operator ==(Object other) =>
      other is ModelType && this >= other && other >= this;
  int get hashCode => T.hashCode;
}
