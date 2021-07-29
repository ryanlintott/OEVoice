//
//  String-extensions.swift
//  Wordhord
//
//  Created by Ryan Lintott on 2020-11-06.
//

import SwiftUI

internal extension String {
    func droppingSuffix<S: StringProtocol>(_ string: S) -> String {
        guard self.hasSuffix(string) else { return String(self) }
        return String(self.dropLast(string.count))
    }
    
    func droppingPrefix<S: StringProtocol>(_ string: S) -> String {
        guard self.hasPrefix(string) else { return String(self) }
        return String(self.dropFirst(string.count))
    }
    
    func replacingSuffixOccurrence(of string: String, with replacement: String) -> String {
        guard self.hasSuffix(string) else { return self }
        return self.droppingSuffix(string).appending(replacement)
    }
    
    func replacingPrefixOccurrence(of string: String, with replacement: String) -> String {
        guard self.hasPrefix(string) else { return self }
        return replacement.appending(self.droppingPrefix(string))
    }
}
