//
//  OEVoice+AVFoundation.swift
//  OEVoice
//
//  Created by Ryan Lintott on 2021-07-29.
//

import AVFoundation

@available(iOS 10.0, *)
public extension OEVoice {
    static let idPrefix = "com.apple.ttsbundle."
    
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
    
    var voice: AVSpeechSynthesisVoice? {
        if AVSpeechSynthesisVoice.speechVoices().contains(where: { $0.identifier == identifier }) {
            return AVSpeechSynthesisVoice(identifier: identifier)
        } else if let legacyIdentifier = AVSpeechSynthesisVoice.speechVoices().map({ $0.identifier }).first(where: { legacyIdentifiers.contains($0) }) {
            return AVSpeechSynthesisVoice(identifier: legacyIdentifier)
        }
        return nil
    }
    
    func speak(_ ipaString: String, synthesizer: AVSpeechSynthesizer) throws {
        guard let voice = voice else {
            throw OEVoiceErrors.voiceNotFound
        }
        synthesizer.speakIPA(adjustIPAString(ipaString), voice: voice)
    }
}
