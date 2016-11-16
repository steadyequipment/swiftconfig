//
//  Value.swift
//  swiftconfig
//
//  Created by Ian Grossberg on 10/25/16.
//
//

import Foundation

import SwiftyJSON

extension Type : CustomStringConvertible {

    public var description : String {
        switch self {
        case .number: return "number"
        case .bool: return "bool"
        case .string: return "string"
        default: return ""
        }
    }
}

// Generic doesn't work here (in `Values` Collection) yet Swift :(
public struct Value {

    let type : Type
    let name : String
    let shorthand : Character?
    let usageDescription : String

    let defaultValue : JSON

    var hasAValue : Bool = false
    var currentValue : JSON? = nil

    public init(name : String, shorthand : Character, usageDescription : String, defaultValue : Int) {

        self.type = .number
        self.name = name
        self.shorthand = shorthand
        self.usageDescription = usageDescription
        self.defaultValue = JSON(defaultValue)
    }

    public init(name : String, usageDescription : String, defaultValue : Int) {

        self.type = .number
        self.name = name
        self.shorthand = nil
        self.usageDescription = usageDescription
        self.defaultValue = JSON(defaultValue)
    }
    
    public init(name : String, shorthand : Character, usageDescription : String, defaultValue : String) {

        self.type = .string
        self.name = name
        self.shorthand = shorthand
        self.usageDescription = usageDescription
        self.defaultValue = JSON(defaultValue)
    }

    public init(name : String, usageDescription : String, defaultValue : String) {

        self.type = .string
        self.name = name
        self.shorthand = nil
        self.usageDescription = usageDescription
        self.defaultValue = JSON(defaultValue)
    }

    public init(name : String, shorthand : Character, usageDescription : String, defaultValue : Bool) {

        self.type = .bool
        self.name = name
        self.shorthand = shorthand
        self.usageDescription = usageDescription
        self.defaultValue = JSON(defaultValue)
    }

    public init(name : String, usageDescription : String, defaultValue : Bool) {

        self.type = .bool
        self.name = name
        self.shorthand = nil
        self.usageDescription = usageDescription
        self.defaultValue = JSON(defaultValue)
    }

    mutating func setValueFromString(valueAsString : String) {

        self.currentValue = JSON(valueAsString)
    }

    func valueAsString() -> String {

        guard let currentValue = self.currentValue else {

            return self.defaultValue.stringValue
        }

        return currentValue.stringValue
    }

    func invalidTypeError(invalidType : Type) -> NSError {
        return NSError(localizedDescription: "Value \(self.name) of type \(self.type) cannot be retrieved as value \(invalidType)")
    }

    func valueAsBool() throws -> Bool {

        guard self.type == .bool else {
            throw self.invalidTypeError(invalidType: .bool)
        }

        guard let currentValue = self.currentValue,
                let bool = currentValue.bool else {

            return self.defaultValue.boolValue
        }

        return bool
    }

    func valueAsDouble() throws -> Double {

        guard self.type == .number else {
            throw self.invalidTypeError(invalidType: .number)
        }

        guard let currentValue = self.currentValue,
            let double = currentValue.double else {

            return self.defaultValue.doubleValue
        }

        return double
    }

    func valueAsFloat() throws -> Float {

        guard self.type == .number else {
            throw self.invalidTypeError(invalidType: .number)
        }

        guard let currentValue = self.currentValue,
            let float = currentValue.float else {

            return self.defaultValue.floatValue
        }

        return float
    }

    func valueAsInt() throws -> Int {

        guard self.type == .number else {
            throw self.invalidTypeError(invalidType: .number)
        }

        guard let currentValue = self.currentValue,
            let int = currentValue.int else {

            return self.defaultValue.intValue
        }

        return int
    }
}
