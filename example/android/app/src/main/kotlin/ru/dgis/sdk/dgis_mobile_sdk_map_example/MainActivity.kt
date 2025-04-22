package ru.dgis.sdk.dgis_mobile_sdk_map_example

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import ru.dgis.sdk.RadarSettingsProviderRegistry
import ru.dgis.sdk.positioning.RadarSettingsProvider
import ru.dgis.sdk.positioning.radar.RadarApiSettings

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        RadarSettingsProviderRegistry.register(MyRadarSettingsProvider())
    }
}

class MyRadarSettingsProvider(): RadarSettingsProvider() {
    override fun provideSettings(): RadarApiSettings {
        return RadarApiSettings.OFF
    }
}

