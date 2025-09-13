plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.rfid.rfid_flutter_android_example"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.rfid.rfid_flutter_android_example"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        // Keep the debug signing config but point it to the user's default debug keystore if it exists.
        // If the user's debug keystore isn't present, we intentionally leave the config unset so
        // Gradle uses its internal default debug keystore.
        getByName("debug") {
            val debugKeystore = File(System.getProperty("user.home"), ".android/debug.keystore")
            if (debugKeystore.exists()) {
                storeFile = debugKeystore
                storePassword = "android"
                keyPassword = "android"
                keyAlias = "androiddebugkey"
            } else {
                // No storeFile set -> Gradle will fall back to its internal debug keystore
            }
        }

        // Release signing remains explicit. If you prefer a relative path inside the project,
        // change the File("/release.jks") to File("zsguang/release.jks") or another relative path.
        create("release") {
            val strFile = File("/release.jks")
            storeFile = file(strFile)
            storePassword = "123456"
            keyPassword = "123456"
            keyAlias = "uhf-serial-key"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }

        debug {
            // Use the debug signing config defined above (which will point to the user's
            // default debug keystore if present). This avoids requiring /release.jks for debug builds.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
    }

    // 自定义apk名称
    applicationVariants.all {
        outputs.all {
            val output = this as? com.android.build.gradle.internal.api.BaseVariantOutputImpl
            output?.outputFileName = "Flutter_RFID_v${defaultConfig.versionName}_${buildType.name}.apk"
        }
    }
}

flutter {
    source = "../.."
}
