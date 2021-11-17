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
    
    var shortIdentifier: String {
        switch self {
        case .siriMarthaGBcompact:
            return "siri_Martha_en-GB_compact"
        case .siriArthurGBcompact:
            return "siri_Aurthur_en-GB_compact"
        case .siriNickyUScompact:
            return "siri_Nicky_en-US_compact"
        case .siriAaronUScompact:
            return "siri_Aaron_en-US_compact"
        case .danielGBcompact:
            return "Daniel-compact"
        }
    }
    
    var legacyShortIdentifiers: [String] {
        switch self {
        case .siriMarthaGBcompact:
            return ["siri_female_en-GB_compact"]
        case .siriArthurGBcompact:
            return ["siri_male_en-GB_compact"]
        case .siriNickyUScompact:
            return ["siri_female_en-US_compact"]
        case .siriAaronUScompact:
            return ["siri_male_en-US_compact"]
        default:
            return []
        }
    }
    
    var identifier: String {
        return Self.idPrefix.appending(shortIdentifier)
    }
    
    var legacyIdentifiers: [String] {
        return legacyShortIdentifiers.map { Self.idPrefix.appending($0) }
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
    
    static func speak(_ ipaString: String, oeVoice: OEVoice = Self.default, applyAdjustments: Bool = true, synthesizer: AVSpeechSynthesizerIPA, force: Bool = false, willSpeak: ((String) -> Void)? = nil) throws {
        guard let voice = oeVoice.voice else {
            throw OEVoiceError.voiceNotFound
        }
        guard force || supportedLanguages.contains(where: { $0 == synthesizer.language }) else {
            throw OEVoiceError.languageNotSupported
        }
        
        let stringToSpeak = applyAdjustments ? oeVoice.adjustIPAString(ipaString) : ipaString
        synthesizer.speakIPA(stringToSpeak, voice: voice, willSpeak: willSpeak)
    }
}
