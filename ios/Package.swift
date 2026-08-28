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
                .process("assets/brebis.png"),
                .process("assets/copro.png"),
                .process("assets/lamb.png"),
                .process("assets/etat_corporel.png"),
                .process("assets/syringe.png"),
                .process("assets/boucle.png"),
                .process("assets/bouclage.png"),
                .process("assets/gismo.png"),
                .process("assets/Truck.png"),
                .process("assets/Control-Panel-icon.png"),
                .process("assets/home.png"),
                .process("assets/tomb.png"),
                .process("assets/ram.png"),
                .process("assets/ewe.png"),
                .process("assets/ram_actif.png"),
                .process("assets/ewe_actif.png"),
                .process("assets/ram_inactif.png"),
                .process("assets/ewe_inactif.png"),
                .process("assets/parcelles.png"),
                .process("assets/gismo-64.png"),
                .process("assets/peseur.png"),
                .process("assets/ultrasound.png"),
                .process("assets/male.png"),
                .process("assets/female.png"),
                .process("assets/jumping_lambs.png"),
                .process("assets/sheep_lamb.png"),
                .process("assets/saillie.png"),
                .process("assets/belier.png"),
                .process("assets/memo.png"),
                .process("assets/adn.png"),
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