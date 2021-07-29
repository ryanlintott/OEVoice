//
//  OEVoice+AVFoundation.swift
//  OEVoice
//
//  Created by Ryan Lintott on 2021-07-29.
//

import Foundation
import AVFoundation

@available(iOS 10.0, *)
extension OEVoice {
    public var shortIdentifier: String {
        switch self {
        case .siriMarthaGBcompact:
            if #available(iOS 14.5, *) {
                return "siri_Martha_en-GB_compact"
            } else {
                return "siri_female_en-GB_compact"
            }
        case .siriArthurGBcompact:
            if #available(iOS 14.5, *) {
                return "siri_Aurthur_en-GB_compact"
            } else {
                return "siri_male_en-GB_compact"
            }
        case .siriNickyUScompact:
            if #available(iOS 14.5, *) {
                return "siri_Nicky_en-US_compact"
            } else {
                return "siri_female_en-US_compact"
            }
        case .siriAaronUScompact:
            if #available(iOS 14.5, *) {
                return "siri_Aaron_en-US_compact"
            } else {
                return "siri_male_en-US_compact"
            }
        case .danielGBcompact:
            return "Daniel-compact"
        }
    }
    
    public var identifier: String {
        return "com.apple.ttsbundle.".appending(shortIdentifier)
    }
    
    public var voice: AVSpeechSynthesisVoice? {
        AVSpeechSynthesisVoice(identifier: identifier)
    }
}
