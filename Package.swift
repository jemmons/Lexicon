// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Lexicon",
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .library(
      name: "Lexicon",
      targets: ["Lexicon"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "Lexicon",
      dependencies: []),
    .testTarget(
      name: "LexiconTests",
      dependencies: ["Lexicon"]),
  ]
)
