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
            .alert(errorTitle, isPresented: $showingError) {
                Button("Ok", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                Spacer()
                Button("New Word") {
                    startGame()
                }
                .tint(.pink)
            }
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
    
    func isWordNotRootWord(word: String) -> Bool {
        !word.elementsEqual(rootWord)
    }
    
    func isWordLongEnough(word: String) -> Bool {
        word.count >= 3
    }
 
    /** Core functions */
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                
                rootWord = allWords.randomElement()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "silkworm"
                
                resetGame()
                
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard canWordBeMade(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isWordReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isWordNotRootWord(word: answer) else {
            wordError(title: "Word is the same as main word", message: "Come up with your own words")
            return
        }
        
        guard isWordLongEnough(word: answer) else {
            wordError(title: "Word is too short", message: "Come up with some stuff longer than 2 letters")
            return
        }
        
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
    
    func resetGame() {
        usedWords.removeAll()
        newWord = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
