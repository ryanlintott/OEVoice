//
//  NSAttributedString-extensions.swift
//  OEVoice
//
//  Created by Ryan Lintott on 2021-12-17.
//

import AVFoundation
import Foundation

internal extension NSMutableAttributedString {
    /// Ranges of every occurrence of a phrase.
    /// - Parameter phrase: Phrase to find. An empty phrase returns no ranges.
    /// - Returns: Range of each occurrence, in order.
    func ranges(of phrase: String) -> [NSRange] {
        guard !phrase.isEmpty else { return [] }
        
        var ranges: [NSRange] = []
        var searchStart = 0
        
        while searchStart < length {
            let searchRange = NSRange(location: searchStart, length: length - searchStart)
            let range = mutableString.range(of: phrase, options: [], range: searchRange)
            
            guard range.location != NSNotFound else { break }
            
            ranges.append(range)
            searchStart = range.location + range.length
        }
        
        return ranges
    }
}

public extension NSMutableAttributedString {
    func accessibilityOldEnglishIPA(_ phrases: [String: String], voice: OEVoice = .default) -> Self {
        guard self.length > 0 else {
            return self
        }
        
        let attributedString = self
        
        let ipaKey = NSAttributedString.Key.accessibilitySpeechIPANotation
        
        phrases.forEach { (phrase, ipa) in
            let ranges = attributedString.ranges(of: phrase)
            
            guard !ranges.isEmpty else { return }
            
            let phonetic = voice.adjustIPAString(ipa)
            
            ranges.forEach { range in
                // Added rather than set so any existing attributes are kept
                attributedString.addAttributes([
                    ipaKey: phonetic,
                    .accessibilityTextCustom: ["Old English"],
                    .accessibilitySpeechLanguage: OEVoice.preferredLanguage
                ], range: range)
            }
        }
        
        return attributedString
    }
    
    func accessibilityOldEnglishIPA(_ ipa: String?, voice: OEVoice = .default) -> NSMutableAttributedString {
        guard let ipa = ipa else {
            return self
        }
        
        return accessibilityOldEnglishIPA([self.string: ipa], voice: voice)
    }
    
    func setSpeechIPAMatchingAccessibilityIPA() {
        let range = NSMakeRange(0, length)
        let accessibilityIPAKey = NSAttributedString.Key.accessibilitySpeechIPANotation
        let pronunciationIPAKey = NSAttributedString.Key(rawValue: AVSpeechSynthesisIPANotationAttribute)
        
        // Ranges are collected first so the string is not modified while it's being enumerated
        var pronunciations: [(value: Any, range: NSRange)] = []
        
        enumerateAttributes(in: range) { values, range, stop in
            if let value = values[accessibilityIPAKey] {
                pronunciations.append((value, range))
            }
        }
        
        pronunciations.forEach { pronunciation in
            // Added rather than set so any existing attributes are kept
            addAttributes([pronunciationIPAKey: pronunciation.value], range: pronunciation.range)
        }
    }
}
