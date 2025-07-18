plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace   = "com.example.clondeinstagram"
    compileSdk  = 36                         // SDK de compilación
    ndkVersion  = "29.0.13599879"            // NDK instalado

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.clondeinstagram"
        minSdk        = 23                   // minSDK literal
        targetSdk     = 36                   // targetSDK literal
        versionCode   = 1                    // actualízalo según tu versión
        versionName   = "1.0"                // actualízalo según tu versión
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}


flutter {
    source = "../.."
}
