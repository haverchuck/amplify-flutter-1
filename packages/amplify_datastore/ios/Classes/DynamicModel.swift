//
//  DynamicModel.swift
//  DataStoreTest
//
//  Created by Roy, Jithin on 7/20/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//
import Amplify

struct DynamicModel: Model, JSONValueHolder {
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
        let typeName = json["__typename"]
        let modified = DynamicModel.removeReservedNames(json)
        
        if case .object(var v) = modified {
            v["__typename"] = typeName
            values = v
        } else {
            values = [:]
        }
    }

    private static func removeReservedNames(_ jsonValue: JSONValue) -> JSONValue {
        
        if case .object(let jsonObject) = jsonValue {
            var modifiedJsonValue: [String: JSONValue] = [:]
            
            for key in jsonObject.keys {
                if key != "__typename" {
                    let modifiedItem = removeReservedNames(jsonObject[key]!)
                    modifiedJsonValue[key] = modifiedItem
                }
            }
            return .object(modifiedJsonValue)
        }
        if case .array(let jsonArray) = jsonValue {
            var modifiedArray:[JSONValue] = []
            for item in jsonArray {
                let modifiedItem = removeReservedNames(item)
                modifiedArray.append(modifiedItem)
            }
            return .array(modifiedArray)
        }
        return jsonValue
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
    
    public func jsonValue(for key: String, modelSchema: ModelSchema) -> Any?? {
        let field = modelSchema.field(withName: key)
        if case .int = field?.type,
           case .some(.number(let deserializedValue)) = values[key] {
            return Int(deserializedValue)
            
        } else if case .dateTime = field?.type,
                  case .some(.string(let deserializedValue)) = values[key] {
            
            return try? Temporal.DateTime(iso8601String: deserializedValue)
            
        } else if case .date = field?.type,
                  case .some(.string(let deserializedValue)) = values[key] {
            return try? Temporal.Date(iso8601String: deserializedValue)
            
        } else if case .time = field?.type,
                  case .some(.string(let deserializedValue)) = values[key] {
            return try? Temporal.Time(iso8601String: deserializedValue)
            
        }
        return jsonValue(for: key)
    }
}

extension DynamicModel {

    public enum CodingKeys: String, ModelKey {
        case id
        case values
    }

    public static let keys = CodingKeys.self
}
