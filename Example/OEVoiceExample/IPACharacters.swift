//
//  IPACharacters.swift
//  OEVoice
//
//  Created by Ryan Lintott on 2021-06-23.
//

import SwiftUI

struct IPACharacters: View {
    static let size: CGFloat = 28
    
    let action: (String) -> Void
    
    let columns = Array(repeating: GridItem(.fixed(size)), count: 8)
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(TestWords.allSpecialCharacters.sorted(), id: \.self) { character in
                Button {
                    action(String(character))
                } label: {
                    Text(String(character))
                        .frame(width: Self.size, height: Self.size)
                        .contentShape(Rectangle())
                }
                #if os(iOS)
                .buttonStyle(BorderlessButtonStyle())
                #endif
            }
        }
    }
}

struct IPACharacters_Previews: PreviewProvider {
    static var previews: some View {
        IPACharacters { character in
            print(character)
        }
    }
}
