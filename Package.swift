// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DateTimePicker",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "DateTimePicker",
            targets: ["DateTimePicker"]
        )
    ],
    targets: [
        .target(
            name: "DateTimePicker",
            path: "Sources"
        )
    ]
)
