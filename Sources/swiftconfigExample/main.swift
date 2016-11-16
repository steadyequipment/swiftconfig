//
//  Config.swift
//  swiftconfigExample
//
//  Created by Ian Grossberg on 10/19/16.
//
//

import Rainbow

import swiftconfig

import Foundation

struct Config {

    class Values : swiftconfig.Values {
        let headerName = "swiftconfigExample"
        var headerDescription : String? = "swiftconfig's companion example application"

        var footerName : String? = nil
        var footerDescription : String? = nil

        var allValues = [String : Value]()
        var valueOrder = NSMutableOrderedSet()
        var requiredValues = [String]()

        init() {
            self.add(value: Value(name: "help", shorthand: "h", usageDescription: "Display this usage guide.", defaultValue: false))

            self.add(value: Value(name: "string", shorthand: "s", usageDescription: "String option.", defaultValue: "defaultString"))

            self.add(value: Value(name: "number", shorthand: "n", usageDescription: "Number option.", defaultValue: 999))

            self.add(value: Value(name: "bool", shorthand: "b", usageDescription: "Boolean option.", defaultValue: false))

            self.add(value: Value(name: "noShorthand", usageDescription: "No shorthand option.", defaultValue: 12345))
        }
    }

    let values = Values()

    func parse() throws {
        try self.values.parse()
    }

    func shouldShowHelp() throws -> Bool {
        return try values.boolValue(forName: "help")
    }
}

func handleOptions(config : Config) throws {
    if try config.shouldShowHelp() {
        config.values.printUsage()
    } else {

        let stringValue = try config.values.stringValue(forName: "string")
        NSLog("String value: \(stringValue)")

        let numberValue = try config.values.doubleValue(forName: "number")
        NSLog("Number value: \(numberValue)")

        let boolValue = try config.values.boolValue(forName: "bool")
        NSLog("Bool value: \(boolValue)")

        let noShorthandValue = try config.values.intValue(forName: "noShorthand")
        NSLog("No Shorthand value: \(noShorthandValue)")
    }
}

let config = Config()
do {
    try config.parse()
    try handleOptions(config: config)

} catch let error as NSError {

    config.values.printUsage(message: error.localizedDescription)
}
