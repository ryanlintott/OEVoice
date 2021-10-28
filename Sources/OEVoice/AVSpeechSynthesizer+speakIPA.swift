//
//  AVSpeechSynthesizer+speakIPA.swift
//  OEVoice
//
//  Created by Ryan Lintott on 2020-07-28.
//

import AVFoundation

public extension AVSpeechSynthesizer {
    /// Speaks an IPA string out loud
    /// - Parameters:
    ///   - ipaString: String using IPA notation
    ///   - voiceIdentifier: Voice to use
    ///   - willSpeak: Runs just before speech and includes exact string to be spoken.
    func speakIPA(_ ipaString: String, voice: AVSpeechSynthesisVoice, willSpeak: ((String) -> Void)? = nil) {
        let mutableAttributedString = NSMutableAttributedString(string: ipaString)
        
        let range = NSString(string: ipaString).range(of: ipaString)
        let pronunciationKey = NSAttributedString.Key(rawValue: AVSpeechSynthesisIPANotationAttribute)
        mutableAttributedString.setAttributes([pronunciationKey: ipaString], range: range)
        print(mutableAttributedString.attributes(at: 0, longestEffectiveRange: nil, in: range))

        let utterance = AVSpeechUtterance(attributedString: mutableAttributedString)

        utterance.voice = voice
        
        // Pausing first is safer and may prevent bugs
        self.pauseSpeaking(at: .immediate)
        // Stop speaking otherwise utterances with queue
        self.stopSpeaking(at: .immediate)
        
        willSpeak?(utterance.speechString)
        print("speakIPA: \(ipaString) voice: \(voice.identifier)")
        
        self.speak(utterance)
    }
    
    func simplifiedTestSpeakIPA() {
        // This should sound like "wath"
        speakIPA("waːθ", voice: .init(identifier: "com.apple.ttsbundle.siri_Nicky_en-US_compact")!)
    }
}
