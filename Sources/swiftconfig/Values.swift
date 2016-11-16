//
//  Values.swift
//  swiftconfig
//
//  Created by Ian Grossberg on 10/25/16.
//
//

import Foundation

import SwiftyJSON

// TODO: support flag and bool valuetypes
// TODO: combine options output and parsing
// TODO: support --x=y
// TODO: check for duplicate param names or shorthands
// TODO: store order variables were added
public protocol Values : class {
    var headerName : String { get }
    var headerDescription : String? { get }

    var footerName : String? { get }
    var footerDescription : String? { get }

//    var configFile : String { get }

    var allValues : [String : Value] { get set }
    var valueOrder : NSMutableOrderedSet { get set }
    var requiredValues : [String] { get set }
}

public extension Values {

    public func add(value : Value, isRequired : Bool = false) /*throws*/ {
        // TODO: check for duplicate name
        self.allValues[value.name] = value
        self.valueOrder.add(value.name)
        if isRequired {
            self.requiredValues.append(value.name)
        }
    }

    public func parse() throws {
        for entry in self.allValues {
            var value = entry.value
            switch value.type {
            case .bool:
                let readValue = try CommandLine.value(shortOption: value.shorthand, option: value.name, defaultValue: value.defaultValue.boolValue)
                value.currentValue = JSON(readValue)
                break

            case .number:
                let readValue = try CommandLine.value(shortOption: value.shorthand, option: value.name, defaultValue: value.defaultValue.intValue)
                value.currentValue = JSON(readValue)
                break

            case .string:
                let readValue = try CommandLine.value(shortOption: value.shorthand, option: value.name, defaultValue: value.defaultValue.stringValue)
                value.currentValue = JSON(readValue)
                break

            default:
                throw NSError(localizedDescription: "Invalid type, cannot parse")
            }
        }
    }

    func isValueRequired(name : String) -> Bool {
        return self.requiredValues.index(of: name) != nil
    }

    func value(forName : String) throws -> Value {

        guard let value = self.allValues[forName] else {
            throw NSError(localizedDescription: "No value with name '\(forName) registered'")
        }

        return value
    }

    public func stringValue(forName : String) throws -> String {
        
        return try self.value(forName: forName).valueAsString()
    }

    public func boolValue(forName : String) throws -> Bool {

        return try self.value(forName: forName).valueAsBool()
    }

    // TODO: think over float->int / int->float / number->?
    public func doubleValue(forName : String) throws -> Double {

        return try self.value(forName: forName).valueAsDouble()
    }

    public func floatValue(forName : String) throws -> Float {

        return try self.value(forName: forName).valueAsFloat()
    }

    public func intValue(forName : String) throws -> Int {

        return try self.value(forName: forName).valueAsInt()
    }

    public func printUsage(message : String? = nil) {

        let useMessage : String?
        if let message = message,
            message.characters.count > 0 {

            useMessage = message
        } else {
            useMessage = nil
        }

        CommandLine.printUsage(
            headerName: self.headerName,
            headerDescription: self.headerDescription,
            printOptions: self.printOptions,
            message: useMessage,
            footerName: self.footerName,
            footerDescription: self.footerDescription)
    }

    func printOptions() {

        for valueName in self.valueOrder.array {

            guard let valueName = valueName as? String else {
                continue
            }
            guard let value = self.allValues[valueName] else {
                continue
            }

            CommandLine.printOption(
                shorthand: value.shorthand,
                name: value.name,
                type: value.type.description,
                required: self.isValueRequired(name: value.name),
                usageDescription: value.usageDescription
            )
        }
    }

    public static func printUsage(
        headerName : String,
        headerDescription : String?,
        printOptions : (() -> Void),
        message : String? = nil,
        footerName : String? = "About",
        footerDescription : String? = nil
        ) {

        print("")

        if let message = message {
            print ("")
            print (message)
        }

        print("")
        print(headerName.lightWhite.underline.bold)
        if let headerDescription = headerDescription {
            print("")
            print("  " + headerDescription)
        }
        print("")
        print("Options".lightWhite.underline.bold)
        print("")

        printOptions()

        if let footerDescription = footerDescription {
            print("")
            if let footerName = footerName {
                print(footerName.lightWhite.bold.underline)
            }
            print(footerDescription)
        }
        print("")
    }

    public static func printOption(shorthand : Character? = nil, name : String, type : String? = nil, required : Bool = false, usageDescription : String) {

        let shorthandOutput : String
        if let shorthand = shorthand {
            shorthandOutput = ("-" + String(shorthand)).lightWhite.bold
        } else {
            shorthandOutput = "  "
        }

        let typeOutput : String
        if let type = type {
            typeOutput = type.underline
        } else {
            typeOutput = "\t"
        }

        let nameOutput = ("--" + name).lightWhite.bold

        let requiredOption : String
        if required {
            requiredOption = "Required".lightWhite.bold + ": "
        } else {
            requiredOption = ""
        }

        print("  " + shorthandOutput + ", " + nameOutput + " " + typeOutput + "\t\t\t" + requiredOption + usageDescription)
    }

}
