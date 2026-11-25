// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// Native artifact pin: the url/checksum below must match `../dgis_artifact.json`,
// which the podspec reads for the CocoaPods integration.
let package = Package(
    name: "dgis_mobile_sdk_map",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .library(name: "dgis-mobile-sdk-map", targets: ["dgis_mobile_sdk_map"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        // PlatformCDart is shipped as a dynamic xcframework, so its headers
        // (MetalDrawablePresenter.h, Util.h) are visible as <PlatformCDart/...>
        // and its symbols are present in the loaded process, which is what
        // DynamicLibrary.process() on the Dart side resolves against.
        //
        // The zip is the very artifact the retired `DGisFlutterMapSDK` pod
        // vendored; SwiftPM accepts it unmodified. It is downloaded into
        // build/ios/SourcePackages/artifacts, never into the source tree.
        .binaryTarget(
            name: "PlatformCDart",
            url: "https://artifactory.2gis.dev/sdk-ios-release/14.3.0/Release/DGisFlutterMapSDK.zip",
            checksum: "e0be0103f0bb4f082a4d0c98faf488235acd171405e65f1bba0c831424f00a96"
        ),
        .target(
            name: "dgis_mobile_sdk_map",
            dependencies: [
                .target(name: "PlatformCDart"),
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            linkerSettings: [
                .linkedFramework("CoreVideo"),
                .linkedFramework("Foundation"),
                .linkedFramework("Metal"),
                .linkedFramework("UIKit")
            ]
        )
    ],
    // PlatformCDart's Util.h uses nested namespaces (C++17), and the plugin
    // sources are Objective-C++ that import it.
    cxxLanguageStandard: .cxx17
)
