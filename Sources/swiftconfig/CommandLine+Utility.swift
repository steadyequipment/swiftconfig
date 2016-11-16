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

    public static func value(shortOption: Character? = nil, option: String) throws -> String? {

        var index = 0;
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

    public static func value(shortOption: Character? = nil, option: String, defaultValue : String) throws -> String {

        let optionalStringValue = try self.value(shortOption: shortOption, option: option)

        guard let stringValue = optionalStringValue else {
            return defaultValue
        }

        return stringValue
    }

    public static func value(shortOption: Character? = nil, option: String, defaultValue : Int) throws -> Int {

        let optionalStringValue = try self.value(shortOption: shortOption, option: option)

        guard let stringValue = optionalStringValue else {
            return defaultValue
        }

        guard let result = Int(stringValue) else {
            throw self.errorExpected(typeName: "\(Int.self)", forOption: option)
        }
        
        return result
    }

    public static func value(shortOption: Character? = nil, option: String, defaultValue : Bool) throws -> Bool {

        let optionalStringValue = try self.value(shortOption: shortOption, option: option)

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
