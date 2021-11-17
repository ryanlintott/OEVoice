//
//  OEVoiceError.swift
//  OEVoice
//
//  Created by Ryan Lintott on 2021-09-05.
//

import Foundation

public enum OEVoiceError: String, LocalizedError, Identifiable {
    case voiceNotFound
    case languageNotSupported
    
    public var id: String {
        self.rawValue
    }

    public var errorDescription: String? {
        switch self {
        case .voiceNotFound:
            return NSLocalizedString("Voice matching the supplied identifier could not be found.", comment: "")
        case .languageNotSupported:
            return NSLocalizedString("First preferred language is not supported by IPA pronunciations.", comment: "Initialize AVSpeechSynthesizerIPA with .oePreferredLanguage or one of OEVoice.supportedLanguages")
        }
    }
}
