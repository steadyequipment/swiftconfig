//
//  CommandLine+Utility.swift
//  swiftconfig
//
//  Created by Ian Grossberg on 10/17/16.
//
//

import Foundation

import Rainbow

extension CommandLine {

    internal static func testArgument(shortOption: Character? = nil, option: String, argument : String) -> Bool {
        if argument == "--" + option {
            return true
        }

        if let shortOption = shortOption,
            argument == "-" + String(shortOption) {
            return true
        }

        return false
    }
    
    public static func contains(shortOption: Character? = nil, option: String) -> Bool {
        return self.arguments.filter({ (argument) -> Bool in

            return self.testArgument(shortOption: shortOption, option: option, argument: argument)
        }).count > 0
    }

    internal static func errorExpectedValue(forOption option : String) -> NSError {
        return NSError(localizedDescription: "Expected a value for option '\(option)'.")
    }

    internal static func errorExpected(typeName type : String, forOption option : String) -> NSError {
        return NSError(localizedDescription: "Expected a value of type '\(type)' for option '\(option)'.")
    }

    public static func value(startAtIndex: Int = 0, shortOption: Character? = nil, option: String) throws -> String? {

        var index = startAtIndex;
        while index < self.arguments.count {

            let argument = self.arguments[index]

            if self.testArgument(shortOption: shortOption, option: option, argument: argument) {

                if self.arguments.count > index + 1 {

                    let value = self.arguments[index + 1]
                    if String(value.characters.prefix(1)) == "-" {
                        throw self.errorExpectedValue(forOption: option)
                    }

                    return value

                } else {
                    //TODO:
                    throw self.errorExpectedValue(forOption: option)
                }
            }
            index += 1
        }
        
        return nil
    }

    public static func value(startAtIndex: Int = 0, shortOption: Character? = nil, option: String, defaultValue : String) throws -> String {

        let optionalStringValue = try self.value(startAtIndex: startAtIndex, shortOption: shortOption, option: option)

        guard let stringValue = optionalStringValue else {
            return defaultValue
        }

        return stringValue
    }

    public static func value(startAtIndex: Int = 0, shortOption: Character? = nil, option: String, defaultValue : Int) throws -> Int {

        let optionalStringValue = try self.value(startAtIndex: startAtIndex, shortOption: shortOption, option: option)

        guard let stringValue = optionalStringValue else {
            return defaultValue
        }

        guard let result = Int(stringValue) else {
            throw self.errorExpected(typeName: "\(Int.self)", forOption: option)
        }
        
        return result
    }

    public static func value(startAtIndex: Int = 0, shortOption: Character? = nil, option: String, defaultValue : Bool) throws -> Bool {

        let optionalStringValue = try self.value(startAtIndex: startAtIndex, shortOption: shortOption, option: option)

        guard let stringValue = optionalStringValue else {
            return defaultValue
        }

        guard let result = Bool(stringValue) else {
            throw self.errorExpected(typeName: "\(Bool.self)", forOption: option)
        }
        
        return result
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

    static func formatArgumentStrings(shorthand : Character? = nil, name : String, type : String? = nil, withAnsiFormatting : Bool = true) -> String {

        let shorthandOutput : String
        if let shorthand = shorthand {

            if withAnsiFormatting {
                shorthandOutput = ("-" + String(shorthand)).lightWhite.bold + ","
            } else {
                shorthandOutput = "-" + String(shorthand) + ","
            }
        } else {
            shorthandOutput = "   "
        }

        let nameOutput : String
        if withAnsiFormatting {
            nameOutput = ("--" + name).lightWhite.bold
        } else {
            nameOutput = "--" + name
        }

        let typeOutput : String
        if let type = type {
            if withAnsiFormatting {
                typeOutput = type.underline
            } else {
                typeOutput = type
            }
        } else {
            typeOutput = ""
        }

        return shorthandOutput + " " + nameOutput + " " + typeOutput
    }

    public static func printOption(shorthand : Character? = nil, name : String, type : String? = nil, descriptionPadding : String = "\t\t\t", required : Bool = false, usageDescription : String) {

        let argumentStrings = self.formatArgumentStrings(shorthand: shorthand, name: name, type: type)

        let requiredOption : String
        if required {
            requiredOption = "Required".lightWhite.bold + ": "
        } else {
            requiredOption = ""
        }

        print("  " + argumentStrings + descriptionPadding + requiredOption + usageDescription)
    }
}
