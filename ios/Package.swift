// ios/Package.swift
// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Runner",
    platforms: [.iOS(.v14)], // Correspond à votre configuration iOS
    products: [
        .library(
            name: "Runner",
            targets: ["Runner"])
    ],
    dependencies: [
        // Mapbox (nécessaire pour mapbox_maps_flutter)
        .package(url: "https://github.com/mapbox/mapbox-maps-ios.git", from: "10.16.0"),
        // Sentry (pour sentry_flutter)
        .package(url: "https://github.com/getsentry/sentry-cocoa.git", from: "8.0.0"),
        // Google Mobile Ads (pour google_mobile_ads)
        .package(url: "https://github.com/googleads/googleads-mobile-flutter.git", from: "9.0.0"),
        // Plugins Flutter (path_provider, permission_handler, etc.)
        .package(url: "https://github.com/flutter/plugins.git", from: "0.10.0"),
    ],
    targets: [
        .target(
            name: "Runner",
            dependencies: [
                // Mapbox
                .product(name: "MapboxMaps", package: "mapbox-maps-ios"),
                // Sentry
                .product(name: "Sentry", package: "sentry-cocoa"),
                // Google Mobile Ads
                .product(name: "GoogleMobileAds", package: "googleads-mobile-flutter"),
                // Plugins Flutter
                .product(name: "PathProvider", package: "plugins"),
                .product(name: "PermissionHandler", package: "plugins"),
                .product(name: "FlutterSecureStorage", package: "plugins"),
                .product(name: "PackageInfoPlus", package: "plugins"),
            ],
            path: "Runner",
            exclude: ["Info.plist"],
            resources: [
                // Inclure vos ressources (images, fichiers JSON, etc.)
                .process("Assets.xcassets"),
                .process("assets/Lot.png"),
                .process("assets/Lot_entree.png"),
                .process("assets/Lot_sortie.png"),
                // Ajoutez toutes vos ressources ici
                .process("resource_test/data.json"),
            ],
            settings: [
                // Répertoires d'en-têtes pour Flutter
                .headerSearchPath("Flutter"),
                .headerSearchPath("Flutter/Generated.xcconfig"),
            ]
        ),
    ]
)