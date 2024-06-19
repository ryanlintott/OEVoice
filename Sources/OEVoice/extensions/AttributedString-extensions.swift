//
//  File.swift
//  
//
//  Created by Ryan Lintott on 2021-12-17.
//

import Foundation

@available(iOS 15, watchOS 8, tvOS 15, *)
public extension AttributedString {
    /// Adds accessible phonetic pronunciation for specified phrases.
    /// - Parameter phrases: Dictionary of phrases and ipa pronunciations for those phrases
    /// - Returns: `AttributedString` with accessible phonetic pronunciations for specified phrases
    func accessibilityIPA(_ phrases: [String: String]) -> Self {
        var attributedString = self
        
        phrases.forEach { phrase in
            if let range = attributedString.range(of: phrase.key) {
                let phonetic = phrase.value
                // apply ipa pronunciation
                attributedString[range].accessibilitySpeechPhoneticNotation = phonetic
            }
        }
        return attributedString
    }
    
    /// Adds accessible Old English IPA pronunciation for specified phrases.
    /// WARNING: User voice may not match supported OEVoice so pronunciations may be incorrect
    /// WARNING: Does not work with these characters in the source: Ā Ǣǣ Ē Ī Ō Ū Ȳȳ Æ Ð Þ Ƿƿ
    /// - Parameter phrases: Dictionary of phrases and ipa pronunciations for those phrases
    /// - Returns: `AttributedString` with accessible Old Egnlish IPA pronunciations for specified phrases
    func accessibilityOldEnglishIPA(_ phrases: [String: String], voice: OEVoice = .default) -> Self {
        var attributedString = self
        
        phrases.forEach { phrase in
            if let range = attributedString.range(of: phrase.key) {
                let phonetic = voice.adjustIPAString(phrase.value)
                // this doesn't seem to do anything
//                attributedString[range].languageIdentifier = "en-US"
                // apply ipa pronunciation
                attributedString[range].accessibilitySpeechPhoneticNotation = phonetic
                
                // This should add "Old English" as a VoiceOver announced attribute but it doesn't anounce anything with voice over
//                attributedString[range].accessibilityTextCustom = ["Old English"]
            }
        }
        return attributedString
    }
    
    /// Adds an accessible Old English IPA pronunciation.
    /// WARNING: User voice may not match supported OEVoice so pronunciations may be incorrect
    /// WARNING: Does not work with these characters in the source: Ā Ǣǣ Ē Ī Ō Ū Ȳȳ Æ Ð Þ Ƿƿ
    /// - Parameter phrases: Dictionary of phrases and ipa pronunciations for those phrases
    /// - Returns: `AttributedString` with accessible Old Egnlish IPA pronunciations for specified phrases
    func accessibilityOldEnglishIPA(_ ipa: String?, voice: OEVoice = .default) -> Self {
        var attributedString = self
        
        if let ipa = ipa {
            let phonetic = voice.adjustIPAString(ipa)
            // this doesn't seem to do anything
//            attributedString.languageIdentifier = "en-US"
            // apply ipa pronunciation
            attributedString.accessibilitySpeechPhoneticNotation = phonetic
        }
        
        // This should add "Old English" as a VoiceOver announced attribute but it doesn't anounce anything with voice over
//        attributedString.accessibilityTextCustom = ["Old English"]
        
        return attributedString
    }
}
