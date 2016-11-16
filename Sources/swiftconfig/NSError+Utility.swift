//
//  NSError+Utility.swift
//  swiftconfig
//
//  Created by Ian Grossberg on 11/15/16.
//
//

import Foundation

public let NSFunctionErrorKey = "FunctionError"
public let NSLineErrorKey = "LineError"

extension NSError {

    // TODO: support NSLocalizedString
    // TODO: support Recovery Attempter
    // TODO: relevant object
    public static func userInfo(localizedDescription : String, underlyingError : NSError? = nil, failureReason : String? = nil, recoverySuggestion : String? = nil, recoveryOptions : [String]? = nil, fileName : String = #file, functionName : String = #function, line : Int = #line) -> [String : Any] {

        var userInfo : [String: Any] = [
            NSFilePathErrorKey : fileName,
            NSFunctionErrorKey : functionName,
            NSLineErrorKey : NSNumber(value: line),

            NSLocalizedDescriptionKey : localizedDescription
        ]

        if let underlyingError = underlyingError {
            userInfo[NSUnderlyingErrorKey] = underlyingError
        }

        if let failureReason = failureReason {
            userInfo[NSLocalizedFailureReasonErrorKey] = failureReason
        }

        if let recoverySuggestion = recoverySuggestion {
            userInfo[NSLocalizedRecoverySuggestionErrorKey] = recoverySuggestion
        }

        if let recoveryOptions = recoveryOptions {
            userInfo[NSLocalizedRecoveryOptionsErrorKey] = recoveryOptions
        }

        return userInfo
    }

    public convenience init(domain : String? = nil, code : Int = 0, localizedDescription : String, underlyingError : NSError? = nil, failureReason : String? = nil, recoverySuggestion : String? = nil, recoveryOptions : [String]? = nil, fileName : String = #file, functionName : String = #function, line : Int = #line) {

        let useDomain : String
        if let domain = domain {
            useDomain = domain
        } else {
            useDomain = localizedDescription
        }

        let userInfo = NSError.userInfo(localizedDescription: localizedDescription, underlyingError: underlyingError, failureReason: failureReason, recoverySuggestion: recoverySuggestion, recoveryOptions: recoveryOptions, fileName: fileName, functionName: functionName, line: line)

        self.init(domain: useDomain, code: 0, userInfo: userInfo)
    }
}
