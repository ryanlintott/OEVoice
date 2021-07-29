//
//  SpecialCharacter.swift
//  TextToSpeech
//
//  Created by Ryan Lintott on 2021-06-23.
//

import Foundation

internal struct SpecialCharacter {
    static let nonBreakingSpace = "\u{00A0}"
    
    static let hyphenMinus = "\u{002D}"
    static let hyphen = "\u{2010}"
    static let nonBreakingHyphen = "\u{2011}"
    static let figureDash = "\u{2012}"
    static let enDash = "\u{2013}"
    static let emDash = "\u{2014}"
    static let minusSign = "\u{2212}"
    
    static let openingSingleQuote = "\u{2018}"
    static let closingSingleQuote = "\u{2019}"
    static let singleQuotes = [openingSingleQuote, closingSingleQuote]
    
    static let openingDoubleQuote = "\u{201C}"
    static let closingDoubleQuote = "\u{201D}"
    static let doubleQuotes = [openingDoubleQuote, closingDoubleQuote]
    
    static let hyphens = [
        Self.hyphen,
        Self.hyphenMinus,
        Self.hyphen,
        Self.nonBreakingHyphen,
        Self.figureDash,
        Self.enDash,
        Self.emDash,
        Self.minusSign
    ]
}

internal extension Character {
    var isHyphenFamily: Bool {
        SpecialCharacter.hyphens.first(where: { $0 == String(self) }) != nil
    }
}
