# ``OEVoice``

AVSpeechSynthesis for Old English with IPA pronunciations.

## Overview

OEVoice speaks Old English out loud by handing IPA notation to `AVSpeechSynthesizer` and correcting the quirks of each supported system voice.

Speech goes through ``AVSpeechSynthesizerIPA``, a synthesizer that pins a compatible language at initialization, and ``OEVoice``, which names a system voice and adjusts an IPA string so it pronounces correctly in that voice:

```swift
let synthesizer = AVSpeechSynthesizerIPA.oeVoiceSupported

// The string is IPA notation, not Old English spelling
try OEVoice.default.speak("hwæt", synthesizer: synthesizer)
```

A language must be supplied to ``AVSpeechSynthesizerIPA`` because `AVSpeechSynthesizer` reads the user's preferred languages instead of the language of the voice it was given. Initializing with ``OEVoice/supportedLanguages`` keeps pronunciations accurate even when the user's first preferred language is incompatible.

Pronunciations can also be attached to text for VoiceOver rather than spoken directly. `String`, `AttributedString`, and `NSMutableAttributedString` each gain `accessibilityOldEnglishIPA` methods that apply an adjusted IPA pronunciation to a phrase.

Requires iOS 15+, watchOS 9+, tvOS 15+, or visionOS 1+. macOS is not supported.

For a feature-by-feature guide with examples, see the [README](https://github.com/ryanlintott/OEVoice), and the `Example` folder in the [repository](https://github.com/ryanlintott/OEVoice) for a demo app.

## Topics

### Voices

- ``OEVoice``

### Speaking

- ``AVSpeechSynthesizerIPA``

### Errors

- ``OEVoiceError``
