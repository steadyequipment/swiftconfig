import PackageDescription

let package = Package(
    name: "swiftconfig",
    targets: [
        Target(
            name: "swiftconfig"
        ),
        Target(
            name: "swiftconfigExample",
            dependencies: [.Target(name: "swiftconfig")]
        )
    ],
    dependencies: [
        .Package(url: "https://github.com/onevcat/Rainbow.git", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", majorVersion: 15)
    ]
)

