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

public extension String {
    @available(iOS 15, *)
    /// Create an `AttributedString` with accessible Old English IPA pronunciation for specified phrases.
    /// WARNING: User voice may not match supported OEVoice so pronunciations may be incorrect
    /// WARNING: Does not work with these characters in the source: Āā Ǣǣ Ēē Īī Ōō Ūū Ȳȳ Ææ Ðð Þþ Ƿƿ
    /// - Parameter phrases: Dictionary of phrases and ipa pronunciations for those phrases
    /// - Returns: `AttributedString` with accessible Old Egnlish IPA pronunciations for specified phrases
    func oldEnglishIPAAttributed(_ phrases: [String: String]) -> AttributedString {
        // doesn't work with non-English characters like ǣ. IPA will not be applied (perhaps because it detects another language).
        var attributedString = AttributedString(self)
        
        phrases.forEach { phrase in
            if let range = attributedString.range(of: phrase.key) {
                // Ideally get the current user accessibility voice but for now use the default as its the only one working with Old English
                let voice = OEVoice.default
                //                let phonetic = "ga"
                let phonetic = voice.adjustIPAString(phrase.value)
                // this doesn't seem to do anything
                attributedString[range].languageIdentifier = "en-US"
                // apply ipa pronunciation
                attributedString[range].accessibilitySpeechPhoneticNotation = phonetic
                
                // This should add "Old English" as a VoiceOver announced attribute but it doesn't anounce anything with voice over
                attributedString[range].accessibilityTextCustom = ["Old English"]
            }
        }
        return attributedString
    }
    
    @available(iOS 15, *)
    /// Create an `AttributedString` with accessible Old English IPA pronunciation.
    /// WARNING: User voice may not match supported OEVoice so pronunciations may be incorrect
    /// WARNING: Does not work with these characters in the source: Āā Ǣǣ Ēē Īī Ōō Ūū Ȳȳ Ææ Ðð Þþ Ƿƿ
    /// - Parameter phrases: Dictionary of phrases and ipa pronunciations for those phrases
    /// - Returns: `AttributedString` with accessible Old Egnlish IPA pronunciations for specified phrases
    func oldEnglishIPAAttributed(_ ipa: String?) -> AttributedString {
        // doesn't work with non-English characters like ǣ. IPA will not be applied (perhaps because it detects another language).
        var attributedString = AttributedString(self)
        
        if let ipa = ipa {
            // Ideally get the current user accessibility voice but for now use the default as its the only one working with Old English
            let voice = OEVoice.default
//            let phonetic = "ga"
            let phonetic = voice.adjustIPAString(ipa)
            // this doesn't seem to do anything
            attributedString.languageIdentifier = "en-US"
            // apply ipa pronunciation
            attributedString.accessibilitySpeechPhoneticNotation = phonetic
        }
        
        // This should add "Old English" as a VoiceOver announced attribute but it doesn't anounce anything with voice over
        attributedString.accessibilityTextCustom = ["Old English"]
        
        return attributedString
    }
}
