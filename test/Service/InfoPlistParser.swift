//
//  InfoPlistParser.swift
//  test
//
//  Created by Aleksy Nikolaishvili on 10/13/20.
//

import Foundation

struct InfoPlistParser {
    static func getStringValue(forKey key:String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String else {
            fatalError("Could not find value in Plist")
        }
        return value
    }
}
