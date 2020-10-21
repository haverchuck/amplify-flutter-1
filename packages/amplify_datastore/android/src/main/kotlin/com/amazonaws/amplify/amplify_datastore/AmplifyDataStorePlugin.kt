package com.amazonaws.amplify.amplify_datastore

import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.VisibleForTesting
import com.amazonaws.amplify.amplify_datastore.types.FlutterDataStoreFailureMessage
import com.amazonaws.amplify.amplify_datastore.types.model.FlutterModelSchema
import com.amazonaws.amplify.amplify_datastore.types.model.FlutterSerializedModel
import com.amazonaws.amplify.amplify_datastore.types.query.QueryOptionsBuilder
import com.amplifyframework.core.Amplify
import com.amplifyframework.core.Consumer
import com.amplifyframework.core.model.Model
import com.amplifyframework.core.model.query.QueryOptions
import com.amplifyframework.core.model.query.predicate.QueryPredicates
import com.amplifyframework.core.model.temporal.Temporal
import com.amplifyframework.datastore.AWSDataStorePlugin
import com.amplifyframework.datastore.DataStoreException
import com.amplifyframework.datastore.DataStoreItemChange
import com.amplifyframework.datastore.appsync.SerializedModel
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*
import kotlin.collections.HashMap

/** AmplifyDataStorePlugin */
class AmplifyDataStorePlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private val LOG = Amplify.Logging.forNamespace("amplify:flutter:datastore")

    override fun onAttachedToEngine(
            @NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger,
                                "com.amazonaws.amplify/datastore")
        channel.setMethodCallHandler(this)
        Amplify.addPlugin(AWSDataStorePlugin())
        LOG.info("Added DataStore plugin")
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        var data: HashMap<String, Any> = HashMap()
        try {
            data = checkArguments(call.arguments)
        } catch (e: Exception) {
            prepareError(result, e, FlutterDataStoreFailureMessage.CASTING.toString())
        }
        when (call.method) {
            "query" -> onQuery(result, data)
            "configure" -> onConfigure(result, data)
            "deleteInstance" -> onDeleteInstance(result, data)
            "deleteWhen" -> onDeleteWhen(result, data)
        }
    }

    private fun onConfigure(flutterResult: Result, request: HashMap<String, Any>) {
        var modelSchemasMap: List<Map<String, Any>>? = null
        if (request.containsKey("modelSchemas")) {
            if (request["modelSchemas"] is List<*>) {
                modelSchemasMap = request["modelSchemas"] as List<Map<String, Any>>
            } else {
                prepareError(flutterResult, java.lang.Exception(
                        FlutterDataStoreFailureMessage.MALFORMED.toString()),
                             FlutterDataStoreFailureMessage.CASTING.toString())
            }
        } else {
            prepareError(flutterResult,
                         java.lang.Exception(FlutterDataStoreFailureMessage.MALFORMED.toString()),
                         FlutterDataStoreFailureMessage.CASTING.toString())
        }

        val modelProvider = FlutterModelProvider.instance
        val flutterModelSchemaList =
                modelSchemasMap!!.map { modelSchemaMap -> FlutterModelSchema(modelSchemaMap) }
        flutterModelSchemaList.forEach { flutterModelSchema ->
            modelProvider?.addModelSchema(
                    flutterModelSchema.name,
                    flutterModelSchema.convertToNativeModelSchema()
            )
        }
        Amplify.addPlugin(AWSDataStorePlugin(modelProvider!!))
        flutterResult.success(null)
    }

    @VisibleForTesting
    fun onQuery(flutterResult: Result, request: HashMap<String, Any>) {
        // Create new posts temporary
       createTempPosts()

        var modelName = request["modelName"] as String
        var queryOptions: QueryOptions = QueryOptionsBuilder.fromSerializedMap(request)
        val plugin = Amplify.DataStore.getPlugin("awsDataStorePlugin") as AWSDataStorePlugin
        plugin.query(
                modelName,
                queryOptions,
                {
                    var results: List<Map<String, Any>> =
                            it.asSequence().toList().map { model: Model? ->
                                FlutterSerializedModel(model as SerializedModel).toMap()
                            }
                    LOG.info("Number of items received " + results.size)
                    Handler(Looper.getMainLooper()).post {
                        flutterResult.success(results)
                    }
                },
                {
                    LOG.info("MyAmplifyApp + Query failed.$it")
                    prepareError(flutterResult, it, FlutterDataStoreFailureMessage.QUERY.toString())
                }
        )
    }


    @VisibleForTesting
    fun onDeleteInstance(flutterResult: Result, request: HashMap<String, Any>) {
        // Create new posts temporary
        createTempPosts()

        var modelName = request["modelName"] as String
        var modelData = request["model"] as HashMap<String, Any>
        var queryOptions: QueryOptions = QueryOptionsBuilder.fromSerializedMap(request)
        val plugin = Amplify.DataStore.getPlugin("awsDataStorePlugin") as AWSDataStorePlugin

        var instance = SerializedModel.builder()
            .serializedData(modelData)
            .id(modelData["id"] as String)
            .modelName(modelName)
            .build()

        plugin.delete(
            instance,
            queryOptions.queryPredicate,
            Consumer {
                LOG.info("Deleted item: " + it.item().toString())
                Handler(Looper.getMainLooper()).post {
                    flutterResult.success(FlutterSerializedModel(it.item()).toMap())
                }
            },
            Consumer {
                LOG.error("Deletion Failed: " + it)
                prepareError(flutterResult, it, FlutterDataStoreFailureMessage.DELETE.toString())
            }
        )
    }

    @VisibleForTesting
    fun onDeleteWhen(flutterResult: Result, request: HashMap<String, Any>) {
        // Create new posts temporary
        createTempPosts()

        var modelName = request["modelName"] as String
        var queryOptions: QueryOptions = QueryOptionsBuilder.fromSerializedMap(request)
        val plugin = Amplify.DataStore.getPlugin("awsDataStorePlugin") as AWSDataStorePlugin


        plugin.query(
            modelName,
            queryOptions,
            {
//                var results: List<Map<String, Any>> =
//                        it.asSequence().toList().map { model: Model? ->
//                            FlutterSerializedModel(model as SerializedModel).toMap()
//                        }
//                LOG.info("Number of items received " + results.size)
//                Handler(Looper.getMainLooper()).post {
//                    flutterResult.success(results)
//                }
                it.asSequence()
            },
            {
                LOG.error("Deletion Failed: " + it)
                prepareError(flutterResult, it, FlutterDataStoreFailureMessage.DELETE.toString())
            }
        )
    }

    private fun createTempPosts() {
        val postSerializedData: List<Map<String, Any>> = listOf(
                mapOf(
                        "id" to UUID.randomUUID().toString(),
                        "title" to "Title 1 " + Date().toString(),
                        "rating" to 5,
                        "created" to Temporal.DateTime(
                                "2020-02-20T20:20:20-08:00")), // ISO8601 representation that would come from dart
                mapOf(
                        "id" to UUID.randomUUID().toString(),
                        "title" to "Title 2 " + Date().toString(),
                        "rating" to 3),
                mapOf(
                        "id" to UUID.randomUUID().toString(),
                        "title" to "Title 3 " + Date().toString(),
                        "rating" to 2,
                        "created" to Temporal.DateTime("2020-02-02T20:20:20-08:00")),
                mapOf(
                        "id" to UUID.randomUUID().toString(),
                        "title" to "Title 4 " + Date().toString(),
                        "created" to Temporal.DateTime("2020-02-22T20:20:20-08:00"))
        )
        val plugin = Amplify.DataStore.getPlugin("awsDataStorePlugin") as AWSDataStorePlugin
        postSerializedData.forEach { data ->
            plugin.save(SerializedModel.builder()
                                .serializedData(data)
                                .modelName("Post")
                                .build(),
                        QueryPredicates.all(),
                        Consumer { response: DataStoreItemChange<SerializedModel?> ->
                            Log.i("Result", response.toString())
                        },
                        Consumer { failure: DataStoreException? ->
                            Log.e("Result", "Failed", failure)
                        }
            ) // Save call end
        } // for each end
    } // method end

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun checkArguments(@NonNull args: Any): HashMap<String, Any> {
        if (args !is HashMap<*, *>) {
            throw java.lang.Exception("Flutter method call arguments are not a map.")
        }
        return args as HashMap<String, Any>
    }

    private fun prepareError(@NonNull flutterResult: Result, @NonNull error: Exception,
                             @NonNull msg: String) {
        LOG.error(msg, error)
        var errorMap: HashMap<String, Any> = HashMap()

        var localizedError = ""
        var recoverySuggestion = ""
        if (error is DataStoreException) {
            recoverySuggestion = error.recoverySuggestion
        }
        if (error.localizedMessage != null) {
            localizedError = error.localizedMessage
        }
        errorMap.put("PLATFORM_EXCEPTIONS", mapOf(
                "platform" to "Android",
                "localizedErrorMessage" to localizedError,
                "recoverySuggestion" to recoverySuggestion,
                "errorString" to error.toString()
        ))
        Handler(Looper.getMainLooper()).post {
            flutterResult.error("AmplifyException", msg, errorMap)
        }
    }
}