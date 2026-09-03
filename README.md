<img width="456" alt="OEVoice Logo" src="https://user-images.githubusercontent.com/2143656/150425538-49cbe98a-75de-4f23-8969-90d5b0784fb2.png">

[![Swift Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fryanlintott%2FOEVoice%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ryanlintott/OEVoice)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fryanlintott%2FOEVoice%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ryanlintott/OEVoice)
![License - MIT](https://img.shields.io/github/license/ryanlintott/OEVoice)
![Version](https://img.shields.io/github/v/tag/ryanlintott/OEVoice?label=version)
![GitHub last commit](https://img.shields.io/github/last-commit/ryanlintott/OEVoice)
[![Documentation](https://img.shields.io/badge/documentation-Swift%20Package%20Index-blue)](https://swiftpackageindex.com/ryanlintott/OEVoice/documentation/oevoice)
[![Mastodon](https://img.shields.io/badge/mastodon-@ryanlintott-5c4ee4.svg?style=flat)](http://mastodon.social/@ryanlintott)
[![Bluesky](https://img.shields.io/badge/bluesky-@ryanlintott-0285FF.svg?style=flat)](https://bsky.app/profile/ryanlintott.bsky.social)

# Overview
AVSpeechSynthesis for Old English with IPA pronunciations.

# Demo App
The `Example` folder has an app that demonstrates the features of this package.

# Installation and Usage
This package is compatible with iOS 15+, watchOS 9+, tvOS 15+, and visionOS 1+.

1. In Xcode go to `File -> Add Packages`
2. Paste in the repo's url: `https://github.com/ryanlintott/OEVoice` and select by version.
3. Import the package using `import OEVoice`

# Documentation
Full API documentation is hosted on the [Swift Package Index](https://swiftpackageindex.com/ryanlintott/OEVoice/documentation/oevoice).

# Is this Production-Ready?
Really it's up to you. I currently use this package in my own [Old English Wordhord app](https://oldenglishwordhord.com/app).

Additionally, if you find a bug or want a new feature add an issue and I will get back to you about it.

# Support
OEVoice is open source and free but if you like using it, please consider supporting my work.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/X7X04PU6T)

- - -
# Features

Old English text-to-speech uses `AVSpeechSynthesizerIPA`, a subclass of `AVSpeechSynthesizer` and an `OEVoice` that pairs a system voice with custom IPA formatting tweaks to get the best results.

```swift
let synthesizer = AVSpeechSynthesizerIPA.oeVoiceSupported

// The string is IPA notation for the Old English word "wordhord".
try OEVoice.default.speak("ˈwɔɹd-ˌhɔɹd", synthesizer: synthesizer)
```

`speak` throws `OEVoiceError.voiceNotFound` if the voice isn't installed on the device, and `OEVoiceError.languageNotSupported` if the synthesizer was created without support for English.

## Voices
`OEVoice` lists the system voices that have been at least partially tuned for Old English pronunciations:

```swift
OEVoice.danielGBcompact      // Default UK voice
OEVoice.siriMarthaGBcompact  // UK Siri voices, not available on macOS or simulator
OEVoice.siriArthurGBcompact
OEVoice.siriNickyUScompact   // US Siri voices, not available on macOS or simulator
OEVoice.siriAaronUScompact
```

`OEVoice.default` is `.siriNickyUScompact`, which is the only one that has the most complete set of adjustments.

Each voice mispronounces IPA in its own way, so `adjustIPAString(_:)` rewrites an IPA string to work around them. `speak` applies these adjustments for you unless you pass `applyAdjustments: false`.

```swift
let adjusted = OEVoice.siriNickyUScompact.adjustIPAString("ˈwɔɹd-ˌhɔɹd")
```

Voice identifiers changed in iOS 18.5. `OEVoice` looks for the current identifier first and falls back to the legacy identifiers, so both old and new systems resolve to the same voice.

## Synthesizer
Use `AVSpeechSynthesizerIPA` instead of `AVSpeechSynthesizer` to get access to:

```swift
func speakIPA(_ ipaString: String, voice: AVSpeechSynthesisVoice, willSpeak: ((String) -> Void)? = nil)
```

There are 3 options for initializing `AVSpeechSynthesizerIPA`
1. `AVSpeechSynthesizerIPA.oeVoiceSupported` - Use this to ensure an OEVoice supported language is set.
2. `AVSpeechSynthesizerIPA.init(language: String)` - Force a language of your choice.
3. `AVSpeechSynthesizerIPA.init(preferredLanguages: [String])` - Provide a list of language options.

## Accessibility
Pronunciations can be attached to text for VoiceOver instead of being spoken directly. `String`, `AttributedString`, and `NSMutableAttributedString` all gain `accessibilityOldEnglishIPA` methods that apply an adjusted IPA pronunciation.

```swift
Text("wordhord".oldEnglishIPAAttributed("ˈwɔɹd-ˌhɔɹd"))

Text("The Old English Wordhord".oldEnglishIPAAttributed(["Wordhord": "ˈwɔɹd-ˌhɔɹd"]))
```

These pronunciations are read by the user's own VoiceOver voice, which may not be one of the supported `OEVoice` values, so the result may not be accurate. They also don't work with these characters in the source text: Ā Ǣǣ Ē Ī Ō Ū Ȳȳ Æ Ð Þ Ƿƿ

## Audio session
`setSpeechSession()` configures an audio session to play on mute, pause other spoken audio, and duck everything else.

```swift
AVAudioSession.sharedInstance().setSpeechSession()
```

## Why must a language be provided?
Somewhere in the internals of `AVSpeechSynthesizer`'s `speak()` function, a language value is set the first time it's run. Instead of using the language supplied by `AVSpeechSynthesisVoice` used in `AVSpeechUtterance`, it accesses the user's preferred languages (probably via the UserDefaults key `AppleLanguages`). If the preferred language does not match the voice language, speech using IPA will not be at all accurate. Sounds will be mispronounced, some characters will be read as their character name instead of their sound, and some characters will be ignored.

I have reported this as a bug (FB9688443). Ideally `speak()` would only use the language of the supplied voice each time it's run and would not need to reference the user's preferred languages.

The init for `AVSpeechSynthesizerIPA` ensures the pronunciations are accurate even on devices with incompatible primary languages. If the user's first preferred language is incompatible, their preferred languages in UserDefaults will temporarily be changed to the desired language, `speak()` is run on an empty string, and the languages are changed back again.
