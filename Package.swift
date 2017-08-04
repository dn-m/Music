// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Music",
    products: [
        .library(name: "Articulations", targets: ["Articulations"]),
        .library(name: "Dynamics", targets: ["Dynamics"]),
        .library(name: "Pitch", targets: ["Pitch"]),
        .library(name: "Rhythm", targets: ["Rhythm"]),
        .library(name: "MusicModel", targets: ["MusicModel"])
    ],
    dependencies: [
        .package(url: "https://github.com/dn-m/Structure", .branch("master")),
        .package(url: "https://github.com/dn-m/Math", .branch("master"))
    ],
    targets: [

        // Sources
        .target(name: "Articulations", dependencies: []),
        .target(name: "Dynamics", dependencies: ["Destructure", "Structure"]),
        .target(name: "Pitch", dependencies: ["Math", "StructureWrapping"]),
        .target(name: "Rhythm", dependencies: ["Math", "DataStructures", "Structure"]),
        .target(name: "MusicModel", dependencies: ["Algebra", "StructureWrapping", "DataStructures"]),

        // Tests
        .testTarget(name: "ArticulationsTests", dependencies: ["Articulations"]),
        .testTarget(name: "DynamicsTests", dependencies: ["Dynamics"]),
        .testTarget(name: "PitchTests", dependencies: ["Pitch"]),
        .testTarget(name: "RhythmTests", dependencies: ["Rhythm"]),
        .testTarget(name: "MusicModelTests", dependencies: ["MusicModel"])
    ]
)
