//
//  OEVoiceErrors.swift
//  OEVoice
//
//  Created by Ryan Lintott on 2021-09-05.
//

import Foundation

public enum OEVoiceErrors: Error {
    case voiceNotFound
}

extension OEVoiceErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .voiceNotFound:
            return NSLocalizedString("Voice matching the supplied identifier could not be found.", comment: "")
        }
    }
}
