//
//  SpellCheck.swift
//  WordScramble
//
//  Created by Shihab Chowdhury on 4/11/23.
//

import SwiftUI

func spellCheck(for word: String) -> [String] {
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    let allGood = misspelledRange.location == NSNotFound
    
    if !allGood {
        guard let guesses = checker.guesses(forWordRange: range, in: word, language: "en") else {
            return [String]()
        }
        
        return guesses
    }
    
    return [String]()
}

struct WordResult: View {
    var word: String
    var wordGuesses: [String]
    
    var body: some View {
        if (wordGuesses.count > 0) {
            Section("Spell check for: \(word)") {
                ForEach(0..<wordGuesses.count, id: \.self) { index in
                    Text(wordGuesses[index])
                }
            }
        } else {
            Section("Spell check for: \(word)") {
                Text("No guesses found")
            }
        }
    }
    
    init(_ word: String) {
        self.word = word
        self.wordGuesses = spellCheck(for: word)
    }
}

struct SpellCheck: View {
    let words = ["swift", "personla", "candy", "phnoe"]
    
    var body: some View {
        List(0..<words.count, id: \.self) { wordIndex in
            WordResult(words[wordIndex])
        }
    }
}

struct SpellCheck_Previews: PreviewProvider {
    static var previews: some View {
        SpellCheck()
    }
}
