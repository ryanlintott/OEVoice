# OEVoice

![Version](https://img.shields.io/github/v/tag/ryanlintott/OEVoice?label=version)

AVSpeechSynthesis for Old English with IPA pronunciations.

Used in the [Old English Wordhord app](https://oldenglishwordhord.com/app).

## Example App
Check out [OEVoiceExample](https://github.com/ryanlintott/OEVoiceExample) to see how to use this package in an iOS app.

## Installation

1. In XCode 12 go to `File -> Swift Packages -> Add Package Dependency` or in XCode 13 `File -> Add Packages`
2. Paste in the repo's url: `https://github.com/ryanlintott/OEVoice` and select main branch or select by version.

## Usage

Import the package using `import OEVoice`

Use
`AVSpeechSynthesizerIPA`
instead of
`AVSpeechSynthesizer`
to access
`speakIPA(_ ipaString: String, voice: AVSpeechSynthesisVoice, willSpeak: ((String) -> Void)? = nil)`

There are 3 options for initializing `AVSpeechSynthesizerIPA`
1. `AVSpeechSynthesizerIPA.oeSupported` - Use this to ensure an OEVoice supported language is set.
2. `AVSpeechSynthesizerIPA.init(language: String)` - Force a language of your choice.
3. `AVSpeechSynthesizerIPA.init?(languages: [String])` - Provide a list of language options.

## Why must a language be provided?
Somewhere in the internals of `AVspeechSynthesizer`'s `speak()` function, a language value is set the first time it's run. Instead of using the language supplied by `AVSpeechSynthesisVoice` used in `AVSpeechUtterance`, it accesses the user's preferred languages (probably via the UserDefaults key `AppleLanguages`. If the preferred language does not match the voice language, speech using IPA will not be at all accurate. Sounds will be mispronounced, some chatacters will be read as their character name instead of their sound, and some characters will be ignored.

I have reported this as a bug (FB9688443). Ideally `speak()` would only use the language of the supplied voice each time it's run and would not need to reference the user's preferred langauges.

The init for `AVspeechSynthesizerIPA` ensures the pronunciations are accurate even on devices with incompatible primary languages. If the user's first preferred language is incompatible, their preferred languages in UserDefaults will temporarily be changed to the desired language, `speak()` is run on an empty string, and the languages are changed back again.
