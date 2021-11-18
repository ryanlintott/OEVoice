//
//  File.swift
//  
//
//  Created by Ryan Lintott on 2021-11-17.
//

import Foundation
import AVFoundation

public class AVSpeechSynthesizerIPA: AVSpeechSynthesizer {
    let language: String
    
    public init(language: String) {
        self.language = language
        let preferredLanguages = Locale.preferredLanguages
        
        super.init()
        if language != preferredLanguages.first {
            // Set first preferred language to one that is compatible before ContentView has been created
            let preferredLanguagesKey = "AppleLanguages"
            // Changing preferred language
            UserDefaults.standard.set([language], forKey: preferredLanguagesKey)
            // Force AVSpeechSynthesizer to speak.
            // This most likely initializes some internal language setting that references the first preferredLanguage in UserDefaults.
            speak(AVSpeechUtterance(string: ""))
            stopSpeaking(at: .immediate)
            
            // change preferred languages back to previous backup
            UserDefaults.standard.set(preferredLanguages, forKey: preferredLanguagesKey)
        }
    }
    
    public convenience init?(preferredLanguages: [String]) {
        guard let language = preferredLanguages.first(where: { $0 == Locale.preferredLanguages.first }) ?? preferredLanguages.first else {
            print("no preferred languages")
            return nil
        }
        self.init(language: language)
    }
    
    /// Speaks an IPA string out loud
    /// - Parameters:
    ///   - ipaString: String using IPA notation
    ///   - voiceIdentifier: Voice to use
    ///   - willSpeak: Runs just before speech and includes exact string to be spoken.
    public func speakIPA(_ ipaString: String, voice: AVSpeechSynthesisVoice, willSpeak: ((String) -> Void)? = nil) {
        let mutableAttributedString = NSMutableAttributedString(string: ipaString)
        
        let range = NSString(string: ipaString).range(of: ipaString)
        let pronunciationKey = NSAttributedString.Key(rawValue: AVSpeechSynthesisIPANotationAttribute)
        mutableAttributedString.setAttributes([pronunciationKey: ipaString], range: range)
        print(mutableAttributedString.attributes(at: 0, longestEffectiveRange: nil, in: range))
        
        let utterance = AVSpeechUtterance(attributedString: mutableAttributedString)
        print(utterance.attributedSpeechString.attributes(at: 0, longestEffectiveRange: nil, in: range))
        utterance.voice = voice
        
        // Pausing first is safer and may prevent bugs
        pauseSpeaking(at: .immediate)
        // Stop speaking otherwise utterances with queue
        stopSpeaking(at: .immediate)
        
        willSpeak?(utterance.speechString)
        print("speakIPA: \(ipaString), voice: \(voice.identifier), language: \(voice.language), AVLanguage: \(language), preferredLanguages: \(Locale.preferredLanguages)")
        speak(utterance)
    }
}
