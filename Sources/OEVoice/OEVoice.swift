//
//  OEVoice.swift
//  OEVoice
//
//  Created by Ryan Lintott on 2021-02-05.
//

import Foundation

public enum OEVoice: CaseIterable {
    
    // Default UK voice
    case danielGBcompact
    
    // Default UK Siri voices (not available on macOS or simulator)
    case siriMarthaGBcompact
    case siriArthurGBcompact
    
    // Premium UK Siri voices (not on device by default and not available on macOS or simulator)
//    case siriMarthaGBpremium
//    case siriArthurGBpremium
    
    // Extra UK voices - Kate, Oliver, Serena (not on device by default)
    
    // Default US voices - Fred, Samantha
    
    // Default US Siri voices (not available on macOS or simulator)
    case siriNickyUScompact
    case siriAaronUScompact
    
    // Premium US Siri voices (not on device by default and not available on macOS or simulator)
//    case siriNickyUSpremium
//    case siriAaronUSpremium
    
    // Extra US voices - Alex, Allison, Ava, Nicky, Susan, Tom, Victoria (not on device by default)
    
    #if targetEnvironment(simulator)
    public static let `default` = OEVoice.danielGBcompact
    #else
    public static let `default` = OEVoice.siriNickyUScompact
    #endif
    
    public func adjustIPAString(_ string: String) -> String {
        string
            .replacingOccurrences(of: SpecialCharacter.nonBreakingSpace, with: " ")
            .split(separator: " ", omittingEmptySubsequences: true)
            .map({ adjustIPAWord(String($0)) })
            .joined(separator: " ")
    }
    
    public func adjustIPAWord(_ string: String) -> String {
        let sharedChanges = string
            // Change all dash types into dots
            .replacingOccurrences(of: SpecialCharacter.enDash, with: ".")
            .replacingOccurrences(of: SpecialCharacter.hyphenMinus, with: ".")
            .replacingOccurrences(of: SpecialCharacter.hyphen, with: ".")
            
            // Change all secondary emphasis to primary emphasis (secondary not supported)
            .replacingOccurrences(of: "ˌ", with: "ˈ")
        
            // Adjust old style pronunciations to new style (which also fixes a couple bugs)
            .replacingOccurrences(of: "ɝ", with: "y")  // matching new style
            .replacingOccurrences(of: "ɹ", with: "r")  // matching new style and fixing bug
            .replacingOccurrences(of: "h", with: "x")  // matching new style and fixing bug: sounded like hh
            .replacingOccurrences(of: "eːx", with: "eːh")  // changing back any x's that should be h
            .replacingPrefixOccurrence(of: "x", with: "h")  // changing back any x's that should be h
            .replacingOccurrences(of: "ˈx", with: "ˈh")  // changing back any x's that should be h
            .replacingOccurrences(of: ".x", with: ".h")  // changing back any x's that should be h
            .replacingOccurrences(of: " x", with: " h")  // changing back any x's that should be h
        
        switch self {
        case .siriMarthaGBcompact:
            // Mostly working with a few errors
            return sharedChanges
                .replacingOccurrences(of: "ɔ", with: "ɑ")
                .replacingOccurrences(of: "æj", with: "æ͡ɪ")
                .replacingOccurrences(of: "rh", with: "ɹx")
                .replacingSuffixOccurrence(of: "ːr", with: "ːɹ")
                .replacingOccurrences(of: "yl", with: "ɜ͡l")
                .replacingOccurrences(of: "y", with: "ɜ")
                .replacingOccurrences(of: "sm", with: "s͡m")
                .replacingOccurrences(of: "gn", with: "gən")
                .replacingOccurrences(of: "xθ", with: "θ")
                .replacingOccurrences(of: "eː", with: "e͡ɪ")
                .replacingSuffixOccurrence(of: "ɪj", with: "iː")
                .replacingSuffixOccurrence(of: "ːw", with: "")
                .replacingSuffixOccurrence(of: "x", with: "h")
        case .siriArthurGBcompact:
            // No customizations have been done yet
            return sharedChanges
        case .siriNickyUScompact:
            // Fully working (with some slight compromises where necessary)
            return sharedChanges
                .replacingOccurrences(of: "sm", with: "s͡m")  // fixing bug: sounded like sh
                
                .replacingOccurrences(of: "æj", with: "æiː")  // fixing bug: extra "ja" syllable
                .replacingOccurrences(of: "aj", with: "a")  // fixing bug: extra "ja" syllable
                .replacingSuffixOccurrence(of: "ɪj", with: "iː")  // fixing bug: sounded like a "ye" at the end
                .replacingOccurrences(of: "ɪj.", with: "iː.")  // fixing bug: sounded like a "ye" at the end
                .replacingOccurrences(of: "ɪj ", with: "iː ")  // fixing bug: sounded like a "ye" at the end
                .replacingOccurrences(of: "hyj", with: "hy")  // fixing bug: sounded like a "ye" at the end
                
                .replacingOccurrences(of: "hy", with: "hu")  // fixing bug: hu sounds like "ku"
                .replacingOccurrences(of: "ky", with: "ku")  // fixing bug: ku sounds like "thu"
                
                // START of y fixes
                
                // Working
                // ym yθ yːθ yː ymb
                // by byː byːk blyw byl bry brydʒ bryx byz
                // dy dryxt dryn dryntʃ dryː
                // fyl fy fyːst fyːr frymθ fylk
                // gryr
                // hy hyj hlyː hlyːp hyxt hyl hyːθ hyjd hyj
                // jy jyl jylp jys jyst jyː
                // kly klyː ky kyn kynd klyp kny kys
                // lyb lyft lut
                // my mydʒ mynd
                // ny nys nyt
                // py pyn pyt
                // ry ryld ryː ryːz ryʃ
                // swy sy syn sym sny snyː
                // ʃy ʃyl ʃryn
                // ty tʃyː tʃyːz tyː
                // θy θyld θrym θryːθ
                // wylm wyn wynd wyrd
                // zyː
                
                // Close to working
                // byr byrd
                // fyr fyrd fyrx fyrn
                // hwyrft hwyrv hyr
                // jyr
                // kwyl
                // myrθ
                // styrk swylt sty
                // tyr
                // θyrs θyrz
                // wyr wyrt wyrm wyrx wyrd(suffix) wyrm(suffix)
                
                .replacingOccurrences(of: "ryr", with: "rʊr")  // fixing bug: y sounds like "oy"
                
                .replacingOccurrences(of: "byr", with: "bur")
                .replacingOccurrences(of: "fyr", with: "fur")
                .replacingOccurrences(of: "jyr", with: "jur")
                .replacingOccurrences(of: "myr", with: "mur")
                .replacingOccurrences(of: "θyr", with: "θur")
                
                .replacingOccurrences(of: "tyr", with: "tər")  // still not perfect
                .replacingSuffixOccurrence(of: "wyrd", with: "wərd") // still not perfect
                .replacingSuffixOccurrence(of: "wyrm", with: "wərm") // still not perfect
                
                .replacingOccurrences(of: "yrt", with: "ərt")
                .replacingOccurrences(of: "yrf", with: "ərf")
                .replacingOccurrences(of: "yrk", with: "ərk")
                
                .replacingOccurrences(of: "wyn", with: "wɪ͡un")  // fixing bug: y sounds like "oy"
                .replacingOccurrences(of: "wy", with: "wʊ")  // fixing bug: y sounds like "oy"
                .replacingOccurrences(of: "yw", with: "ɪ͡u")  // fixing bug: y sounds like "oy"
                .replacingOccurrences(of: "yr", with: "i͡ʉr")  // fixing bug: y sounds like "oy"
                .replacingOccurrences(of: "y", with: "ɪ͡u")  // fixing bug: y sounds like "oy"
                
                // END of y fixes
                
                .replacingOccurrences(of: "eː", with: "e͡ɪ")  // fixing bug: add an "r" sound
                
                .replacingOccurrences(of: "oːw", with: "o͡ʊ")  // fixing bug: oːw sounds too short but adds a weird "wu"
                .replacingOccurrences(of: "oː", with: "o͡ʊ")  // fixing bug: oː sounds too short
                
                .replacingOccurrences(of: "ær", with: "ar")  // fixing bug: sounds like "air"
                
                .replacingOccurrences(of: "ɪrk", with: "ərk")  // fixing bug: sounds like 2 syllables
                
                .replacingOccurrences(of: "ɔrx", with: "ɔrhk")  // fixing bug: not making the "och" in "loch" sound
                
                .replacingSuffixOccurrence(of: "w", with: "u")  // fixing bug: overpronouncing the "w"
                .replacingOccurrences(of: "w.", with: "u.")  // fixing bug: overpronouncing the "w"
                .replacingOccurrences(of: "w ", with: "u ")  // fixing bug: overpronouncing the "w"
                .replacingOccurrences(of: "wr", with: "r")  // fixing bug: overpronouncing the "w"
        case .siriAaronUScompact:
            // No customizations have been done yet
            return sharedChanges
        case .danielGBcompact:
            // This set of phonetic rules is out of date
            return sharedChanges
                .replacingOccurrences(of: "aː", with: "a")
                .replacingOccurrences(of: "ɔ", with: "ɑ")
                .replacingOccurrences(of: "eː", with: "e͡ɪ")
                .replacingOccurrences(of: "yː", with: "jʊ")
                .replacingOccurrences(of: "y", with: "ɜ")
                .replacingOccurrences(of: "iː", with: "i")
                .replacingOccurrences(of: "oː", with: "o͡ʊ")
                .replacingOccurrences(of: "ɪr", with: "ɜɻ")
                .replacingOccurrences(of: "ˈhr", with: "hə.ˈɻ")
                .replacingOccurrences(of: "hr", with: "həɻ")
                .replacingOccurrences(of: "r", with: "ɻ")
                .replacingOccurrences(of: "uː", with: "u")
                .replacingOccurrences(of: "dʒ", with: "d͡ʒ")
                .replacingOccurrences(of: "tʃ", with: "t͡ʃ")
                .replacingOccurrences(of: "gn", with: "gɛn")
                .replacingOccurrences(of: "æj", with: "æ͡ɪ")
                .replacingOccurrences(of: "æː", with: "æ")
                .replacingOccurrences(of: "uːɻ", with: "uəɻ")
        }
    }
}

