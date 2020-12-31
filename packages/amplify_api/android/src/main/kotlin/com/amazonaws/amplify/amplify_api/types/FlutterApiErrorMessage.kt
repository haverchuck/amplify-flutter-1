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

package com.amazonaws.amplify.amplify_api.types;

enum class FlutterApiErrorMessage {
    ERROR_CASTING_INPUT_IN_PLATFORM_CODE,
    AMPLIFY_REQUEST_MALFORMED,
    AMPLIFY_API_QUERY_FAILED,
    AMPLIFY_API_MUTATE_FAILED,
    AMPLIFY_API_SUBSCRIBE_FAILED_TO_CONNECT,
    AMPLIFY_API_SUBSCRIPTION_DOES_NOT_EXIST
}