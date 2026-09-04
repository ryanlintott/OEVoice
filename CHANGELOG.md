# Changelog

## 2.0.0 - 2026-09-04

### Breaking Changes

- Updated the package to Swift tools 6.0, which builds the package in the Swift 6 language mode.
- Raised the minimum supported platforms to iOS 15, watchOS 9, and tvOS 15. visionOS remains at version 1.
- `AVAudioSession.setSpeechSession()` now throws instead of printing and discarding the error. Existing calls need `try`.

### Added

- DocC documentation catalog with a landing page introducing the package and curating the public API into topic groups.
- Swift Package Index configuration for building and hosting the package's DocC documentation.
- GitHub Actions workflow checking Swift 6.0 compatibility, running the tests, and building for iOS, tvOS, watchOS, and visionOS.
- Shared `OEVoice` scheme for the package, and a shared `OEVoice.xcworkspace` with an `OEVoice Development` scheme for package and example-app development.
- Swift Testing tests covering the phonetic notation applied by `accessibilityIPA(_:)` on `AttributedString` and `String`, including multiple occurrences of a phrase.
- Changelog.
- Link and badge in the readme pointing to the documentation on the Swift Package Index.

### Changed

- Replaced the empty placeholder XCTest with Swift Testing suites.
- Rewrote the readme to cover voices, the synthesizer, accessibility pronunciations, and the audio session helper.
- Replaced the Twitter badge in the readme with Bluesky.
- The example app now references the package at `..` rather than `../../OEVoice`, so it resolves from the workspace, and its deployment targets were raised to iOS 15 and tvOS 15.

### Fixed

- Speaking an `NSMutableAttributedString` no longer alters the string that was passed in. `AVSpeechSynthesizerIPA.speak(_:voice:willSpeak:)` now works on a copy.
- `setSpeechSession()` no longer silently swallows a failure to set the audio session category.
- `setSpeechIPAMatchingAccessibilityIPA()` and `accessibilityOldEnglishIPA(_:voice:)` on `NSMutableAttributedString` now add their attributes rather than replacing every attribute in the range, so fonts, colours, and the accessibility IPA attributes are kept.
- Phrase dictionaries now apply a pronunciation to every occurrence of a phrase rather than only the first. Affects `accessibilityIPA(_:)` and `accessibilityOldEnglishIPA(_:voice:)` on `AttributedString` and `String`, and `accessibilityOldEnglishIPA(_:voice:)` on `NSMutableAttributedString`.
- `adjustIPAWord(_:)` now turns every dash character into a syllable dot. Previously only the en dash, hyphen-minus, and hyphen were converted, so a non-breaking hyphen, figure dash, em dash, or minus sign was left in the string and spoken as a character name.
- Removed a duplicate entry from the internal list of dash characters.
- Corrected the doc comments on `speakIPA(_:voice:willSpeak:)`, `accessibilityOldEnglishIPA(_:voice:)`, `oldEnglishIPAAttributed(_:voice:)`, and `accessibilityIPA(_:voice:)`, which named parameters those methods don't have and omitted others. The documentation now builds without warnings.
- The readme described `AVSpeechSynthesizerIPA.oeSupported` and a failable `init?(languages:)`, neither of which exist. The API is `oeVoiceSupported` and `init(preferredLanguages:)`.

### Performance

- `OEVoice.voice` calls the expensive `AVSpeechSynthesisVoice.speechVoices()` once instead of twice, and `OEVoice.init?(from:)` for an `AVSpeechSynthesisVoice` matches on the voice identifier instead of resolving every case, which called `speechVoices()` up to ten times.

## 1.4.2 - 2025-05-23

### Fixed

- Voice identifiers changed in iOS 18.5. `OEVoice` now looks for the current identifier first and falls back to the previous identifiers, so both old and new systems resolve to the same voice.

## 1.4.1 - 2024-10-04

### Changed

- Moved the example app from a separate repository into the `Example` folder in this package.

## 1.4 - 2024-09-26

### Added

- Swift 6 support and `Sendable` conformance on `OEVoice`.
- Basic support for watchOS, tvOS, and visionOS. These platforms have not been tested.

### Changed

- Updated the package to Swift tools 5.9 and removed the empty dependencies from the package file.

## 1.3.1 - 2024-02-22

### Fixed

- Fixed a bug where `æj` was not pronounced correctly.

## 1.3.0 - 2022-09-20

Also tagged `1.3`.

### Added

- `accessibilityIPA` on `AttributedString` and `String` for non-Old English phonetic pronunciations.
- `accessibilityOldEnglishIPA` on `String`.

### Changed

- `accessibilitySpeechLanguage` now uses `OEVoice.preferredLanguage`.
- Renamed `addAccessibilitySpeechPhoneticNotation` to `accessibilityIPA`.

## 1.2.3 - 2022-01-25

### Fixed

- Fixed a build error for an example test.

## 1.2.2 - 2022-01-20

### Added

- Creating Old English IPA `AttributedString` and `NSAttributedString` so VoiceOver reads attributed strings with the right pronunciation.

### Changed

- Updates to the readme, license, and gitignore.

### Fixed

- IPA adjustments now work correctly on strings with multiple words.

## 1.2.1 - 2021-12-17

### Fixed

- Added a missing `public` scope.

## 1.2.0 - 2021-12-17

### Added

- Support for Old English phrases. `AVSpeechSynthesizerIPA` can now speak `AttributedString` and `NSAttributedString`, copying their accessibility IPA attributes as the AVFoundation IPA attributes.

## 1.1.3 - 2021-12-17

### Changed

- Renamed `adjustIPAString` to `adjustIPAWord` and made `adjustIPAString` split a string by spaces and apply changes to each word individually, so prefix and suffix edits work correctly on phrases.

## 1.1.2 - 2021-12-16

### Added

- `String` extensions for creating Old English IPA attributed strings.

### Changed

- `AVSpeechSynthesizerIPA.init` is no longer failable. Initializing with a blank string sets up no locale settings.

## 1.1.1 - 2021-11-18

### Fixed

- Support for devices with a first preferred language other than en-CA, en-US, en-GB, en-AU, en-NZ, or en-SG. `AVSpeechSynthesizerIPA` now sets the preferred language after `super.init()`, runs an empty `speak()`, then changes it back.

## 1.1.0 - 2021-11-17

### Added

- `AVSpeechSynthesizerIPA`, which pins a language so IPA pronunciations work correctly.
- List of IPA supported languages on `OEVoice`.
- `languageNotSupported` error.

### Breaking Changes

- Raised the minimum supported platform to iOS 14.

## 1.0.3 - 2021-09-06

### Added

- `OEVoice` init from an identifier or an `AVSpeechSynthesisVoice`.
- `applyAdjustments`, defaulting to true, on the speak functions, so speech can come from either the adjusted `OEVoice` or the base voice.

## 1.0.2 - 2021-09-06

### Added

- `OEVoice.speak` using the default voice.
- `OEVoiceError`.

### Changed

- Voice identifiers are no longer picked by iOS version, which was unreliable on iPad. Legacy identifiers are used for all cases instead.
- `speakIPA` now requires a voice parameter instead of an identifier.
- Moved the audio session adjustments to an extension on `AVAudioSession`.

## 1.0.1 - 2021-07-29

### Fixed

- Removed a duplicate `String-extensions` file.

## 1.0 - 2021-07-29

Initial release.
