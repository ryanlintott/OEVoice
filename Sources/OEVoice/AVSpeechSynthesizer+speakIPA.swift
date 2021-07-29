//
//  AVSpeechSynthesizer+speakIPA.swift
//  OEVoice
//
//  Created by Ryan Lintott on 2020-07-28.
//

import Foundation
import AVFoundation

@available(iOS 10.0, *)
public extension AVSpeechSynthesizer {
    func speakIPA(_ ipaString: String, voiceIdentifier: String, willSpeak: ((String) -> Void)? = nil) {
        //Set the audio session to playback to ignore mute switch on device
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: [.interruptSpokenAudioAndMixWithOthers, .duckOthers])
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        let mutableAttributedString = NSMutableAttributedString(string: ipaString)
        
        let range = NSString(string: ipaString).range(of: ipaString)
        let pronunciationKey = NSAttributedString.Key(rawValue: AVSpeechSynthesisIPANotationAttribute)
        mutableAttributedString.setAttributes([pronunciationKey: ipaString], range: range)

        let utterance = AVSpeechUtterance(attributedString: mutableAttributedString)

        let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier)
        utterance.voice = voice
        
        // Pausing first is safer and may prevent bugs
        self.pauseSpeaking(at: .immediate)
        self.stopSpeaking(at: .immediate)
        
        willSpeak?(utterance.speechString)
        print("speakIPA: \(ipaString) voice: \(voice?.identifier ?? "?")")
        
        self.speak(utterance)
    }
}
