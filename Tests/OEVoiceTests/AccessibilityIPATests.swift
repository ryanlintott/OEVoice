//
//  AccessibilityIPATests.swift
//  OEVoice
//
//  Created by Ryan Lintott on 2026-09-04.
//

import Foundation
import Testing
@testable import OEVoice

private extension AttributedString {
    /// Text of each run carrying a phonetic notation.
    var phoneticRuns: [String] {
        runs.compactMap { run in
            run.accessibilitySpeechPhoneticNotation == nil ? nil : String(self[run.range].characters)
        }
    }
    
    /// Phonetic notation of each run that has one, in run order.
    var phoneticValues: [String] {
        runs.compactMap(\.accessibilitySpeechPhoneticNotation)
    }
    
    /// Number of characters carrying a phonetic notation.
    ///
    /// Adjacent runs with matching attributes coalesce into a single run, so counting
    /// characters rather than runs shows how much of the string was tagged.
    var phoneticCharacterCount: Int {
        runs.reduce(0) { count, run in
            run.accessibilitySpeechPhoneticNotation == nil ? count : count + self[run.range].characters.count
        }
    }
}

@Suite("setPhoneticNotation")
struct SetPhoneticNotationTests {
    static let wordhord = "ˈwɔrd.hɔrd"
    
    @Test("Tags every occurrence", arguments: [
        ("Wordhord", 1),
        ("Wordhord and Wordhord", 2),
        ("Wordhord, Wordhord and Wordhord", 3)
    ])
    func tagsEveryOccurrence(text: String, occurrences: Int) {
        var attributedString = AttributedString(text)
        attributedString.setPhoneticNotation(Self.wordhord, forOccurrencesOf: "Wordhord")
        
        #expect(attributedString.phoneticRuns == Array(repeating: "Wordhord", count: occurrences))
    }
    
    @Test func `Every occurrence gets the same pronunciation`() {
        var attributedString = AttributedString("Wordhord and Wordhord")
        attributedString.setPhoneticNotation(Self.wordhord, forOccurrencesOf: "Wordhord")
        
        #expect(attributedString.phoneticValues == [Self.wordhord, Self.wordhord])
    }
    
    @Test func `Only the phrase is tagged`() {
        var attributedString = AttributedString("say Wordhord now")
        attributedString.setPhoneticNotation(Self.wordhord, forOccurrencesOf: "Wordhord")
        
        #expect(attributedString.phoneticRuns == ["Wordhord"])
        #expect(attributedString.phoneticCharacterCount == 8)
    }
    
    @Test func `Adjacent occurrences tag every character`() {
        var attributedString = AttributedString("abab")
        attributedString.setPhoneticNotation("x", forOccurrencesOf: "ab")
        
        // Both occurrences coalesce into one run because their attributes match
        #expect(attributedString.phoneticRuns == ["abab"])
        #expect(attributedString.phoneticCharacterCount == 4)
    }
    
    @Test func `Occurrences do not overlap`() {
        var attributedString = AttributedString("aaa")
        attributedString.setPhoneticNotation("x", forOccurrencesOf: "aa")
        
        #expect(attributedString.phoneticCharacterCount == 2)
    }
    
    @Test func `Multi scalar graphemes do not shift the search`() {
        var attributedString = AttributedString("🇬🇧 Wordhord 🇬🇧 Wordhord")
        attributedString.setPhoneticNotation(Self.wordhord, forOccurrencesOf: "Wordhord")
        
        #expect(attributedString.phoneticRuns == ["Wordhord", "Wordhord"])
    }
    
    @Test("Nothing is tagged and the text is unchanged", arguments: [
        ("", "Wordhord"),
        ("Wordhord", ""),
        ("Wordhord", "Beowulf")
    ])
    func nothingIsTagged(text: String, phrase: String) {
        var attributedString = AttributedString(text)
        attributedString.setPhoneticNotation(Self.wordhord, forOccurrencesOf: phrase)
        
        #expect(attributedString.phoneticRuns.isEmpty)
        #expect(String(attributedString.characters) == text)
    }
}

@Suite("accessibilityIPA")
struct AccessibilityIPATests {
    @Test func `Tags every occurrence of every phrase`() {
        let attributedString = AttributedString("Hwæt we Hwæt")
            .accessibilityIPA(["Hwæt": "ˈhwæt", "we": "ˈweː"])
        
        #expect(attributedString.phoneticRuns == ["Hwæt", "we", "Hwæt"])
        #expect(attributedString.phoneticValues == ["ˈhwæt", "ˈweː", "ˈhwæt"])
    }
    
    @Test func `Pronunciations are used exactly as supplied`() {
        // Unlike accessibilityOldEnglishIPA, no voice adjustments are applied
        let ipa = "ˈwɔrd-ˌhɔrd"
        let attributedString = AttributedString("Wordhord").accessibilityIPA(["Wordhord": ipa])
        
        #expect(attributedString.phoneticValues == [ipa])
        #expect(ipa != OEVoice.default.adjustIPAString(ipa))
    }
    
    @Test func `An empty dictionary leaves the string untagged`() {
        let attributedString = AttributedString("Wordhord").accessibilityIPA([:])
        
        #expect(attributedString.phoneticRuns.isEmpty)
    }
    
    @Test func `The original string is not modified`() {
        let original = AttributedString("Wordhord")
        let tagged = original.accessibilityIPA(["Wordhord": "ˈwɔrd.hɔrd"])
        
        #expect(original.phoneticRuns.isEmpty)
        #expect(tagged.phoneticRuns == ["Wordhord"])
    }
    
    @Test func `String gains the same pronunciations`() {
        let attributedString = "Hwæt we Hwæt".accessibilityIPA(["Hwæt": "ˈhwæt", "we": "ˈweː"])
        
        #expect(attributedString.phoneticRuns == ["Hwæt", "we", "Hwæt"])
        #expect(attributedString.phoneticValues == ["ˈhwæt", "ˈweː", "ˈhwæt"])
    }
}
