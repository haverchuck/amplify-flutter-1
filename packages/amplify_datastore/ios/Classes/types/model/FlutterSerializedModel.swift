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

struct FlutterSerializedModel: Model, JSONValueHolder {

    
    public let id: String
    public let values: [String: JSONValue]
    
    public init(id: String = UUID().uuidString, map: [String: JSONValue]) {
        self.id = id
        self.values = map
    }
    
    public init(from decoder: Decoder) throws {
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
    
    public func jsonValue(for key: String, modelSchema: ModelSchema) -> Any?? {
        
        let field = modelSchema.field(withName: key)
        if case .int = field?.type,
           case .some(.number(let deserializedValue)) = values[key] {
            return Int(deserializedValue)
        }
         
        let result = jsonValue(for: key)
        
        if(result is [String: JSONValue]){
            let resultMap = result as! [String: JSONValue]
            
            // HasMany relationship contains elements
            if(resultMap["elements"] == nil){
                return nil;
            }
            // BelongsTo relationship contains name
            if(resultMap["name"] == nil && resultMap["id"] == nil){
                return nil;
            }
            // TODO: haven't successfully generated a HasOne relationship yet
        }
        
        return result 
    }
    
    private func generateSerializedData(modelSchema: ModelSchema) -> [String: Any]{
        
        var result = [String: Any]()
        
        for(key, value) in values {
            if( value != nil ){
                result[key] = jsonValue(for: key, modelSchema: modelSchema)
            }
        }
        
        return result;
    }
    
    public func toJSON(modelSchema: ModelSchema) -> [String: Any] {
        return [
            "id": self.id,
            "modelName": modelSchema.name,
            "serializedData": generateSerializedData(modelSchema: modelSchema)
            
                /*Dictionary(uniqueKeysWithValues:
                                            values.map { (key: String, value: JSONValue) in
                                                return (key, jsonValue(for: key, modelSchema: modelSchema) ?? nil) })
                */
        ]
    }
}

extension FlutterSerializedModel {
    
    public enum CodingKeys: String, ModelKey {
        case id
        case values
    }
    
    public static let keys = CodingKeys.self
}
