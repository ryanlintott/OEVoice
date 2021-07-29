//
//  String-extensions.swift
//  Wordhord
//
//  Created by Ryan Lintott on 2020-11-06.
//

import SwiftUI

internal extension StringProtocol {
    func size(using font: UIFont) -> CGSize {
        return String(self).size(using: font)
    }
}

internal extension String {
    var addingSingleQuotes: String {
        SpecialCharacter.singleQuotes.joined(separator: self)
    }
    
    var addingDoubleQuotes: String {
        SpecialCharacter.doubleQuotes.joined(separator: self)
    }
    
    func size(using font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    var usingNonLineBreakingHyphens: String {
        self.replacingOccurrences(of: "-", with: "\u{2011}")
    }
    
    var usingNonLineBreakingSpaces: String {
        self.replacingOccurrences(of: " ", with: "\u{00a0}")
    }
    
    func splittingClosestToMidpoint(by separator: Character = " ") -> [String] {
        var parts = self.split(separator: separator)
        var firstHalf = [Substring]()
        var secondHalf = [Substring]()
        while !parts.isEmpty {
            if firstHalf.joined(separator: String(separator)).count <= secondHalf.joined(separator: String(separator)).count {
                firstHalf.append(parts.removeFirst())
            } else {
                secondHalf.append(parts.removeLast())
            }
        }
        return [firstHalf.joined(separator: String(separator)), secondHalf.reversed().joined(separator: String(separator))].filter({ !$0.isEmpty })
    }
    
    func splitMultiline(by separator: Character = " ", font: UIFont, maxWidth: CGFloat) -> [String] {
        guard self.size(using: font).width > maxWidth else {
            return [self]
        }
        
        var parts = self.split(separator: separator)
        
        var multiline = [String]()
        
        while !parts.isEmpty {
            let part = String(parts.removeFirst())
            
            let line = [multiline.last, part].compactMap({$0}).joined(separator: String(separator))
            
            if !line.isEmpty && line.size(using: font).width <= maxWidth {
                if !multiline.isEmpty {
                    multiline[multiline.endIndex - 1] = line
                } else {
                    multiline.append(line)
                }
            } else {
                let wordParts = String(part).splitMultilineByCharacter(font: font, maxWidth: maxWidth)
                multiline += wordParts
            }
        }
        return multiline.map({String($0)})
    }
    
    func splitMultilineByCharacter(font: UIFont, maxWidth: CGFloat) -> [String] {
        guard self.size(using: font).width > maxWidth else {
            return [self]
        }
        
        var characters = Array(self).map({String($0)})
        var multiline = [characters.removeFirst()]
        var index = 0
        
        while !characters.isEmpty {
            let character = characters.removeFirst()
            
            let line = multiline[index] + character
            
            if line.size(using: font).width <= maxWidth {
                multiline[index] = line
            } else {
                multiline.append(character)
                index += 1
            }
        }
        return multiline
    }
    
    func changingBlankToNil() -> String? {
        self == "" ? nil : self
    }

    func droppingSuffix<S: StringProtocol>(_ string: S) -> String {
        guard self.hasSuffix(string) else { return String(self) }
        return String(self.dropLast(string.count))
    }
    
    func droppingPrefix<S: StringProtocol>(_ string: S) -> String {
        guard self.hasPrefix(string) else { return String(self) }
        return String(self.dropFirst(string.count))
    }
    
    func replacingSuffixOccurrence(of string: String, with replacement: String) -> String {
        guard self.hasSuffix(string) else { return self }
        return self.droppingSuffix(string).appending(replacement)
    }
    
    func replacingPrefixOccurrence(of string: String, with replacement: String) -> String {
        guard self.hasPrefix(string) else { return self }
        return replacement.appending(self.droppingPrefix(string))
    }
}
