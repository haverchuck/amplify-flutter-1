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

import Flutter
import Foundation
import Amplify

struct SerializedModel: Model, JSONValueHolder {
    public let id: String

    public var values: [String: JSONValue]

    public init(id: String = UUID().uuidString, map: [String: JSONValue]) {
        self.id = id
        self.values = map
    }

    public init(from decoder: Decoder) throws {

        print("Decoder \(decoder)")
        let y = try decoder.container(keyedBy: CodingKeys.self)
        id = try y.decode(String.self, forKey: .id)
        let json = try JSONValue(from: decoder)
        if case .object(let v) = json {
            values = v
        } else {
            values = [:]
        }
    }

    public func encode(to encoder: Encoder) throws {
        print("Encoder \(encoder)")
        var x = encoder.unkeyedContainer()
        try x.encode(values)
    }

    public func jsonValue(for key: String) -> Any?? {
        if key == "id" {
            return id
        }
        switch values[key] {
        case .some(.array(let deserializedValue)):
            return deserializedValue
        case .some(.boolean(let deserializedValue)):
            return deserializedValue
        case .some(.number(let deserializedValue)):
            return deserializedValue
        case .some(.object(let deserializedValue)):
            return deserializedValue
        case .some(.string(let deserializedValue)):
            return deserializedValue
        case .some(.null):
            return nil
        case .none:
            return nil
        }
    }

    public func toJSON() -> [String: Any] {
        return [
            "id": self.id,
            "serializedData": Dictionary(uniqueKeysWithValues:
                                            values.map{ (key: String, value: JSONValue) in
                                                return (key, jsonValue(for: key) ?? nil) })
        ]
    }
}

extension SerializedModel {

    public enum CodingKeys: String, ModelKey {
        case id
        case values
    }

    public static let keys = CodingKeys.self
}
