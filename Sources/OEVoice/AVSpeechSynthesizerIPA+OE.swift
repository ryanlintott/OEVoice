//
//  AVSpeechSynthesizer+speakIPA.swift
//  OEVoice
//
//  Created by Ryan Lintott on 2020-07-28.
//

import AVFoundation

public extension AVSpeechSynthesizerIPA {
    static var oeVoiceSupported: AVSpeechSynthesizerIPA {
        AVSpeechSynthesizerIPA(preferredLanguages: OEVoice.supportedLanguages) ?? AVSpeechSynthesizerIPA(language: OEVoice.preferredLanguage)
    }
    
    func simplifiedTestSpeakOE() {
        // This should sound like "wath"
        speakIPA("waːθ", voice: .init(identifier: "com.apple.ttsbundle.siri_Nicky_en-US_compact")!)
    }
}
