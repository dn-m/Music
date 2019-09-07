// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Music",
    products: [
        .library(name: "Articulations", targets: ["Articulations"]),
        .library(name: "Dynamics", targets: ["Dynamics"]),
        .library(name: "Pitch", targets: ["Pitch"]),
        .library(name: "Duration", targets: ["Duration"]),
        .library(name: "MusicModel", targets: ["MusicModel"])
    ],
    dependencies: [
        .package(url: "https://github.com/dn-m/Structure", from: "0.24.0"),
        .package(url: "https://github.com/dn-m/Math", from: "0.7.0")
    ],
    targets: [

        // Sources
        .target(name: "Articulations", dependencies: []),
        .target(name: "Dynamics", dependencies: ["Destructure", "DataStructures"]),
        .target(name: "Pitch", dependencies: ["Math", "DataStructures"]),
        .target(name: "Duration", dependencies: ["Math", "DataStructures"]),
        .target(
            name: "MusicModel", 
            dependencies: [
                "Algebra",
                "DataStructures",
                "Articulations",
                "Pitch",
                "Duration"
            ]
        ),

        // Tests
        .testTarget(name: "ArticulationsTests", dependencies: ["Articulations"]),
        .testTarget(name: "DynamicsTests", dependencies: ["Dynamics"]),
        .testTarget(name: "PitchTests", dependencies: ["Pitch"]),
        .testTarget(name: "DurationTests", dependencies: ["Duration"]),
        .testTarget(name: "MusicModelTests", dependencies: ["MusicModel"])
    ]
)
