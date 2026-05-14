import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.transportation_app"

    compileSdk = 36

    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Kotlin DSL uses isCoreLibraryDesugaringEnabled (not coreLibraryDesugaringEnabled)
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    // New way — replaces the deprecated kotlinOptions block
    kotlin {
        compilerOptions {
            jvmTarget = JvmTarget.JVM_11
        }
    }

    defaultConfig {
        applicationId = "com.example.transportation_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Required for coreLibraryDesugaring to work
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    implementation("androidx.window:window:1.3.0")
    implementation("androidx.window:window-java:1.3.0")
}

flutter {
    source = "../.."
}