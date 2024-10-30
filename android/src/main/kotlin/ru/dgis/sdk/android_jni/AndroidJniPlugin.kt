package ru.dgis.sdk.android_jni

import androidx.annotation.NonNull
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.SurfaceTexture
import android.util.LongSparseArray
import android.view.Surface
import android.util.Log

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.view.TextureRegistry

import kotlin.reflect.full.*
import kotlin.reflect.KClass
import kotlin.reflect.KFunction
import kotlin.reflect.KMutableProperty
import kotlin.reflect.KProperty
import kotlin.reflect.KVisibility
import kotlin.reflect.jvm.isAccessible
import kotlin.reflect.jvm.javaType

/** AndroidJniPlugin */
class AndroidJniPlugin: FlutterPlugin, MethodCallHandler {
  private val renders: LongSparseArray<SurfaceTexture> = LongSparseArray()
  private lateinit var textures: TextureRegistry
  private lateinit var channel: MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    setup(flutterPluginBinding.getApplicationContext())
    textures = flutterPluginBinding.getTextureRegistry()
    channel = MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_map_surface_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    val arguments = call.arguments as Map<String, Number>
    if (call.method.equals("setSurface")) {
      val entry: TextureRegistry.SurfaceTextureEntry = textures.createSurfaceTexture()
      val surfaceTexture: SurfaceTexture = entry.surfaceTexture()
      val mapSurfaceId = arguments["mapSurfaceId"]?.toLong() ?: return
      val surface = Surface(surfaceTexture)
      setSurface(mapSurfaceId, surface, 0, 0)
      renders.put(entry.id(), surfaceTexture)
      result.success(entry.id())
      surface.release()
    } else if (call.method.equals("updateSurface")) {
      val textureId = arguments["textureId"]?.toLong() ?: return
      val width = arguments["width"]?.toInt() ?: return
      val height = arguments["height"]?.toInt() ?: return
      val surfaceTexture: SurfaceTexture = renders.get(textureId)
      surfaceTexture.setDefaultBufferSize(width, height)
    } else if (call.method.equals("dispose")) {
      val textureId = arguments["textureId"]?.toLong() ?: return
      renders.delete(textureId)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun setup(context: Context) {

    val packageName = context.packageName
    val packageInfo = context.packageManager.getPackageInfo(packageName, 0)
    val versionName = packageInfo.versionName
    initializeJni(context, this.javaClass.classLoader, packageName, versionName)
    initializeLoggerWithReflection()
  }

  private fun initializeLoggerWithReflection() {
    try {

        val loggerJavaClass = Class.forName("ru.dgis.sdk.Logger")
        val loggerClass = loggerJavaClass.kotlin
        val loggerInstance =  loggerJavaClass.getField("INSTANCE").get(null)

        val logOptionsClass = Class.forName("ru.dgis.sdk.platform.LogOptions").kotlin
        val logLevelClass = Class.forName("ru.dgis.sdk.platform.LogLevel").kotlin

        val initMethod = loggerClass.functions.find { method ->
            method.name == "init" &&
            method.parameters.size == 2 && // 1 for 'this', 1 for the argument
            method.parameters[1].type.javaType == logOptionsClass.java &&
            method.visibility == KVisibility.PUBLIC
        }

        val errorLevel = logLevelClass.java.enumConstants?.find { it.toString() == "ERROR" }

        val logOptions = logOptionsClass.constructors.find { method -> method.parameters.size == 3}!!.call(errorLevel, errorLevel, null)

        if (initMethod != null) {
            initMethod.isAccessible = true
            initMethod.call(loggerInstance, logOptions)
            Log.i("dgis", "Method 'init' called successfully.")
        } else {
            Log.i("dgis", "Method 'init' not found.")
        }
    } catch (e: Exception) {
        e.printStackTrace()
    }
}

  external fun initializeJni(context: Context, classLoader: ClassLoader, packageName: String, version: String)
  external fun setSurface(mapSurfaceId: Long, surface: Surface, width: Int, height: Int)

  companion object {
    init {
      System.loadLibrary("dgis_c_bindings_android")
    }
  }
}
