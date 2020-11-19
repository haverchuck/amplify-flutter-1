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

import Foundation
import Amplify
import AmplifyPlugins

struct FlutterOutboxMutationEnqueued: FlutterHubEvent {
    var eventName: String
    var modelName: [String]
    
    init(payload: HubPayload) throws {
        guard let outboxMutationEnqueued = payload.data as? OutboxMutationEvent else {
                  throw FlutterDataStoreError.hubEventCast
              }
        self.eventName = payload.eventName
        self.modelName = outboxMutationEnqueued.modelName
    }
    
    func toValueMap() -> Dictionary<String, Any> {
        return [
            "eventName": self.eventName,
            "models": self.models.description
        ]
    }
}
