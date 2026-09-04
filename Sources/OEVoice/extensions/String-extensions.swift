//
//  String-extensions.swift
//  OEVoice
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
    
    /// Replaces every dash character with the supplied string.
    ///
    /// Covers all of ``SpecialCharacter/dashes``, not just the hyphen-minus typed on a keyboard.
    /// - Parameter replacement: String used in place of each dash.
    /// - Returns: String with every dash replaced.
    func replacingDashes(with replacement: String) -> String {
        SpecialCharacter.dashes.reduce(self) {
            $0.replacingOccurrences(of: $1, with: replacement)
        }
    }
}

public extension String {
    /// Create an `AttributedString` with accessible Old English IPA pronunciation for specified phrases.
    /// WARNING: User voice may not match supported OEVoice so pronunciations may be incorrect
    /// WARNING: Does not work with these characters in the source: Ā Ǣǣ Ē Ī Ō Ū Ȳȳ Æ Ð Þ Ƿƿ
    /// - Parameters:
    ///   - phrases: Dictionary of phrases and ipa pronunciations for those phrases
    ///   - voice: Voice used to adjust the ipa pronunciations
    /// - Returns: `AttributedString` with accessible Old Egnlish IPA pronunciations for specified phrases
    func oldEnglishIPAAttributed(_ phrases: [String: String], voice: OEVoice = .default) -> AttributedString {
        AttributedString(self).accessibilityOldEnglishIPA(phrases, voice: voice)
    }
    
    /// Create an `AttributedString` with accessible Old English IPA pronunciation.
    /// WARNING: User voice may not match supported OEVoice so pronunciations may be incorrect
    /// WARNING: Does not work with these characters in the source: Ā Ǣǣ Ē Ī Ō Ū Ȳȳ Æ Ð Þ Ƿƿ
    /// - Parameters:
    ///   - ipa: IPA pronunciation
    ///   - voice: Voice used to adjust the ipa pronunciation
    /// - Returns: `AttributedString` with accessible Old Egnlish IPA pronunciations for specified phrases
    func oldEnglishIPAAttributed(_ ipa: String?, voice: OEVoice = .default) -> AttributedString {
        AttributedString(self).accessibilityOldEnglishIPA(ipa, voice: voice)
    }
}

public extension String {
    func oldEnglishIPANSAttributedString(_ phrases: [String: String], voice: OEVoice = .default) -> NSMutableAttributedString {
        NSMutableAttributedString(string: self).accessibilityOldEnglishIPA(phrases, voice: voice)
    }
    
    func oldEnglishIPANSAttributedString(_ ipa: String?, voice: OEVoice = .default) -> NSMutableAttributedString {
        NSMutableAttributedString(string: self).accessibilityOldEnglishIPA(ipa, voice: voice)
    }
}

public extension String {
    /// Adds accessible phonetic pronunciation for specified phrases.
    /// - Parameters:
    ///   - phrases: Dictionary of phrases and ipa pronunciations for those phrases
    ///   - voice: Unused. Pronunciations are applied as supplied, without voice adjustments.
    /// - Returns: `AttributedString` with accessible phonetic pronunciations for specified phrases
    func accessibilityIPA(_ phrases: [String: String], voice: OEVoice = .default) -> AttributedString {
        AttributedString(self).accessibilityIPA(phrases)
    }
    
    /// Adds accessible Old English IPA pronunciation for specified phrases.
    /// WARNING: User voice may not match supported OEVoice so pronunciations may be incorrect
    /// WARNING: Does not work with these characters in the source: Ā Ǣǣ Ē Ī Ō Ū Ȳȳ Æ Ð Þ Ƿƿ
    /// - Parameters:
    ///   - phrases: Dictionary of phrases and ipa pronunciations for those phrases
    ///   - voice: Voice used to adjust the ipa pronunciations
    /// - Returns: `AttributedString` with accessible Old Egnlish IPA pronunciations for specified phrases
    func accessibilityOldEnglishIPA(_ phrases: [String: String], voice: OEVoice = .default) -> AttributedString {
        AttributedString(self).accessibilityOldEnglishIPA(phrases, voice: voice)
    }
}
