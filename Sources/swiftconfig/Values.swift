//
//  Values.swift
//  swiftconfig
//
//  Created by Ian Grossberg on 10/25/16.
//
//

import Foundation

import SwiftyJSON

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

        self.allValues[value.name] = value
        self.valueOrder.add(value.name)
        if isRequired {
            self.requiredValues.append(value.name)
        }
    }

    public func parse(startAtIndex: Int = 0) throws {
        for entry in self.allValues {
            var value = entry.value
            try value.parse(startAtIndex: startAtIndex)
            self.allValues[entry.key] = value
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

    func getLongestValueNameLength() -> Int {
        var result = 0

        for valueElement in self.allValues {

            let value = valueElement.value
            let argumentString = value.formatArgumentStrings(withAnsiFormatting: false)

            if argumentString.characters.count > result {
                result = argumentString.characters.count
            }
        }
        return result
    }

    func printOptions() {

        let longestValueNameLength = self.getLongestValueNameLength()

        for valueName in self.valueOrder.array {

            guard let valueName = valueName as? String else {
                continue
            }
            guard let value = self.allValues[valueName] else {
                continue
            }

            let formattedArgumentsLength = value.formatArgumentStrings(withAnsiFormatting: false).characters.count

            let paddingCount = (longestValueNameLength - formattedArgumentsLength) + 2  // + 2 to guarantee spacing

            guard paddingCount > 0 else {
                value.printOption(
                    descriptionPadding: "\t\t\t",
                    required: self.isValueRequired(name: value.name)
                )
                continue
            }

            let descriptionPadding = String(repeating: " ", count: paddingCount)

            value.printOption(
                descriptionPadding: descriptionPadding,
                required: self.isValueRequired(name: value.name)
            )
        }
    }
}
