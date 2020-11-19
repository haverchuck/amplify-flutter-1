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

public class DataStoreHubEventStreamHandler: NSObject, FlutterStreamHandler {

    private var eventSink: FlutterEventSink?
    private var token: UnsubscribeToken?

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        let castingError = "Error Casting Payload Values"
        self.token = Amplify.Hub.listen(to: .dataStore) { (payload) in
                switch payload.eventName {
                    case HubPayload.EventName.DataStore.networkStatus :
                        do {
                            let networkStatus =  try FlutterNetworkStatus (payload: payload)
                            self.sendEvent(flutterEvent: networkStatus.toValueMap())
                        } catch {
                            self.sendError(description: castingError, eventName: "networkStatus")
                        }
                    case HubPayload.EventName.DataStore.subscriptionsEstablished :
                        do {
                            let subscriptionsEstablished =  try FlutterSubscriptionsEstablished (payload: payload)
                            self.sendEvent(flutterEvent: subscriptionsEstablished.toValueMap())
                        } catch {
                            self.sendError(description: castingError, eventName: "subscriptionsEstablished")
                        }
                    case HubPayload.EventName.DataStore.syncQueriesStarted :
                        do {
                            let syncQueriesStarted =  try FlutterSubscriptionsEstablished (payload: payload)
                            self.sendEvent(flutterEvent: syncQueriesStarted.toValueMap())
                        } catch {
                            self.sendError(description: castingError, eventName: "syncQueriesStarted")
                        }
                    case HubPayload.EventName.DataStore.modelSynced :
                        do {
                            let modelSynced =  try FlutterModelSynced(payload: payload)
                            self.sendEvent(flutterEvent: modelSynced.toValueMap())
                        } catch {
                            self.sendError(description: castingError, eventName: "modelSynced")
                        }
                    case HubPayload.EventName.DataStore.syncQueriesReady :
                        do {
                            let syncQueriesReady =  try FlutterSyncQueriesReady(payload: payload)
                            self.sendEvent(flutterEvent: syncQueriesReady.toValueMap())
                        } catch {
                            self.sendError(description: castingError, eventName: "syncQueriesReady")
                        }
                    case HubPayload.EventName.DataStore.ready :
                        do {
                            let ready =  try FlutterReady(payload: payload)
                            self.sendEvent(flutterEvent: ready.toValueMap())
                        } catch {
                            self.sendError(description: castingError, eventName: "ready")
                        }
                    default:
                        print("d")
                    }
                }
        return nil
    }

    func sendEvent(flutterEvent: [String : Any]) {
        eventSink?(flutterEvent)
    }

    func sendError(description: String, eventName: String) {
        let errorMap: Dictionary<String, Any> = [
            "eventName": eventName,
            "error": description
        ]
        eventSink?(errorMap)
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        if (self.token != nil) {
            Amplify.Hub.removeListener(self.token!)
        }
        return nil
    }
}
