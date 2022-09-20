//
//  File.swift
//  
//
//  Created by Ryan Lintott on 2021-12-17.
//

import AVFoundation
import Foundation

public extension NSMutableAttributedString {
    func accessibilityOldEnglishIPA(_ phrases: [String: String], voice: OEVoice = .default) -> Self {
        guard self.length > 0 else {
            return self
        }
        
        let attributedString = self
        
        let ipaKey = NSAttributedString.Key.accessibilitySpeechIPANotation
        
        phrases.forEach { (phrase, ipa) in
            let range = attributedString.mutableString.range(of: phrase)
            if range.length > 0 {
                let phonetic = voice.adjustIPAString(ipa)
                
                attributedString.setAttributes([
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
        
        enumerateAttributes(in: range) { values, range, stop in
            if let value = values[accessibilityIPAKey] {
                // Modification of the same instance is allowed if it uses the current range
                self.setAttributes([pronunciationIPAKey: value], range: range)
            }
        }
    }
}
