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

package com.amazonaws.amplify.amplify_datastore.types

enum class FlutterDataStoreFailureMessage {
    CASTING {
        override fun toString(): String {
            return "ERROR_CASTING_INPUT_IN_PLATFORM_CODE"
        }
    },
    MALFORMED {
        override fun toString(): String {
            return "AMPLIFY_REQUEST_MALFORMED"
        }
    },
    QUERY {
        override fun toString(): String {
            return "AMPLIFY_DATASTORE_QUERY_FAILED"
        }
    },
    DELETE {
        override fun toString(): String {
            return "AMPLIFY_DATASTORE_DELETE_FAILED"
        }
    }
}
