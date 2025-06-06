//
//  OEVoice+AVFoundation.swift
//  OEVoice
//
//  Created by Ryan Lintott on 2021-07-29.
//

import AVFoundation

public extension OEVoice {
    static let idPrefix = "com.apple.ttsbundle."
    static let preferredLanguage = "en-US"
    static let supportedLanguages = [preferredLanguage, "en-CA", "en-GB", "en-AU", "en-NZ", "en-SG"]
    
    var identifier: String {
        switch self {
        case .siriMarthaGBcompact: "com.apple.ttsbundle.siri_Martha_en-GB_compact"
        case .siriArthurGBcompact: "com.apple.ttsbundle.siri_Aurthur_en-GB_compact"
        case .siriNickyUScompact: "com.apple.ttsbundle.siri_Nicky_en-US_compact"
        case .siriAaronUScompact: "com.apple.ttsbundle.siri_Aaron_en-US_compact"
        case .danielGBcompact: "com.apple.ttsbundle.Daniel-compact"
        }
    }
    
    var legacyIdentifiers: [String] {
        switch self {
        case .siriMarthaGBcompact:
            [
                "com.apple.ttsbundle.siri_martha_en-GB_compact",
                "com.apple.ttsbundle.siri_female_en-GB_compact",
            ]
        case .siriArthurGBcompact:
            [
                "com.apple.ttsbundle.siri_aurthur_en-GB_compact",
                "com.apple.ttsbundle.siri_male_en-GB_compact",
            ]
        case .siriNickyUScompact:
            [
                "com.apple.ttsbundle.siri_nicky_en-US_compact",
                "com.apple.ttsbundle.siri_female_en-US_compact",
            ]
        case .siriAaronUScompact:
            [
                "com.apple.ttsbundle.siri_aaron_en-US_compact",
                "com.apple.ttsbundle.siri_male_en-US_compact",
            ]
        case .danielGBcompact:
            [
                "com.apple.voice.compact.en-GB.Daniel"
            ]
        }
    }
    
    /// Init from AVSpeechSynthesisVoice
    /// - Parameter voice: voice
    init? (from voice: AVSpeechSynthesisVoice) {
        guard let oeVoice = Self.allCases.first(where: { $0.voice == voice }) else {
            return nil
        }
        self = oeVoice
    }
    
    init? (from identifier: String) {
        guard let oeVoice = Self.allCases.first(where: { $0.identifier == identifier }) ?? Self.allCases.first(where: { $0.legacyIdentifiers.contains(identifier) }) else {
            return nil
        }
        self = oeVoice
    }
    
    var voice: AVSpeechSynthesisVoice? {
        if AVSpeechSynthesisVoice.speechVoices().contains(where: { $0.identifier == identifier }) {
            return AVSpeechSynthesisVoice(identifier: identifier)
        } else if let legacyIdentifier = AVSpeechSynthesisVoice.speechVoices().map({ $0.identifier }).first(where: { legacyIdentifiers.contains($0) }) {
            return AVSpeechSynthesisVoice(identifier: legacyIdentifier)
        }
        return nil
    }
    
    func speak(_ ipaString: String, applyAdjustments: Bool = true, synthesizer: AVSpeechSynthesizerIPA, willSpeak: ((String) -> Void)? = nil) throws {
        try Self.speak(ipaString, oeVoice: self, applyAdjustments: applyAdjustments, synthesizer: synthesizer, willSpeak: willSpeak)
    }
    
    static func speak(_ ipaString: String, oeVoice: OEVoice = .default, applyAdjustments: Bool = true, synthesizer: AVSpeechSynthesizerIPA, force: Bool = false, willSpeak: ((String) -> Void)? = nil) throws {
        guard let voice = oeVoice.voice else {
            throw OEVoiceError.voiceNotFound
        }
        guard force || supportedLanguages.contains(where: { $0 == synthesizer.language } ) else {
            throw OEVoiceError.languageNotSupported
        }
        
        let stringToSpeak = applyAdjustments ? oeVoice.adjustIPAString(ipaString) : ipaString
        synthesizer.speakIPA(stringToSpeak, voice: voice, willSpeak: willSpeak)
    }
}

@available(iOS 15, watchOS 8, tvOS 15, *)
public extension OEVoice {
    func speak(_ attributedString: AttributedString, synthesizer: AVSpeechSynthesizerIPA, willSpeak: ((String) -> Void)? = nil) throws {
        try Self.speak(attributedString, oeVoice: self, synthesizer: synthesizer, willSpeak: willSpeak)
    }
    
    static func speak(_ attributedString: AttributedString, oeVoice: OEVoice = .default, synthesizer: AVSpeechSynthesizerIPA, force: Bool = false, willSpeak: ((String) -> Void)? = nil) throws {
        guard let voice = oeVoice.voice else {
            throw OEVoiceError.voiceNotFound
        }
        guard force || supportedLanguages.contains(where: { $0 == synthesizer.language } ) else {
            throw OEVoiceError.languageNotSupported
        }
        
        synthesizer.speak(attributedString, voice: voice, willSpeak: willSpeak)
    }
}

public extension OEVoice {
    func speak(_ mutableAttributedString: NSMutableAttributedString, synthesizer: AVSpeechSynthesizerIPA, willSpeak: ((String) -> Void)? = nil) throws {
        try Self.speak(mutableAttributedString, oeVoice: self, synthesizer: synthesizer, willSpeak: willSpeak)
    }
    
    static func speak(_ mutableAttributedString: NSMutableAttributedString, oeVoice: OEVoice = .default, synthesizer: AVSpeechSynthesizerIPA, force: Bool = false, willSpeak: ((String) -> Void)? = nil) throws {
        guard let voice = oeVoice.voice else {
            throw OEVoiceError.voiceNotFound
        }
        guard force || supportedLanguages.contains(where: { $0 == synthesizer.language } ) else {
            throw OEVoiceError.languageNotSupported
        }
        
        synthesizer.speak(mutableAttributedString, voice: voice, willSpeak: willSpeak)
    }
}
