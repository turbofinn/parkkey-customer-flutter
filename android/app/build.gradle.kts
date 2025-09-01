plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.parkey.customer"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        create("prod") {
            keyAlias = "parkkey-customer-app"
            keyPassword = "Parkkey@123"
            storeFile = file("C:/Users/ASUS/Documents/GitHub/parkkey-customer-flutter/android/app/parkey-customer-app.jks")
            storePassword = "Parkkey@123"
        }
    }

    defaultConfig {
        applicationId = "com.parkey.customer"
        minSdk = 21
        targetSdk = 36
        versionCode = 12
        versionName = "1.0.8"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("prod")

            // ✅ Enable R8 / ProGuard
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
