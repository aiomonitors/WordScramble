//
//  ContentView.swift
//  WordScramble
//
//  Created by Shihab Chowdhury on 4/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            List {
                Section("Enter your word") {
                    TextField("Enter your word", text: $newWord)
                        .onSubmit(addNewWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section("Guesses") {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onAppear(perform: startGame)
        }
    }
    
    /** Validation functions */
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    func canWordBeMade(word: String) -> Bool {
        var wordCopy = String(rootWord)
        
        for letter in newWord {
            guard let letterIndex = wordCopy.firstIndex(of: letter) else {
                return false
            }
            
            wordCopy.remove(at: letterIndex)
        }
        
        return true
    }
    
    func isWordReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let result = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return result.location == NSNotFound
    }
    
    /** Core functions */
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                
                rootWord = allWords.randomElement()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "silkworm"
                
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        newWord = ""
    }
    
    func wordError(title: String, message: String) {
        errorMessage = message
        errorTitle = title
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
