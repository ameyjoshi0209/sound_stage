plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")  // Firebase plugin
}

android {
    namespace = "com.example.sound_stage"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.sound_stage"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
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

dependencies {
    implementation("com.google.android.material:material:1.12.0")

    // Firebase BoM for version management
    implementation(platform("com.google.firebase:firebase-bom:33.9.0"))

    // Firebase Analytics (if you're using it)
    implementation("com.google.firebase:firebase-analytics")

    // Firebase Authentication (add this if using FirebaseAuth)
    implementation("com.google.firebase:firebase-auth")

    // Other Firebase services if you're using them
    // implementation("com.google.firebase:firebase-firestore")
    // implementation("com.google.firebase:firebase-storage")
    // Add any other Firebase libraries you need

    // For example, if using Firebase Firestore
    implementation("com.google.firebase:firebase-firestore")
}