//
//  ContentView.swift
//  WordScramble
//
//  Created by newbie on 04.07.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var usedWords = [String]()
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    @State private var score = 0
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        TextField("Enter your word", text: $newWord)
                            .textInputAutocapitalization(.never)
                    }
                    Section {
                        ForEach(usedWords, id: \.self) { word in
                            HStack {
                                Image(systemName: "\(word.count).circle.fill")
                                Text(word)
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())

                Spacer()
                Text("Score: \(score)")
                    .font(.largeTitle)
            }
            .navigationTitle(rootWord)
            .onSubmit {
                addWord()
            }
            .onAppear(perform: startGame)
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") {
                    newWord = ""
                    score -= 1
                }
            } message: {
                Text(alertMessage)
            }
            .toolbar {
                Button("Refresh") {
                    startGame()
                }
            }
        }
    }
    
    private func addWord() {
        let clearWord = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard clearWord.count > 1 else { return }
        
        guard isReal(word: clearWord) && isOrigin(word: clearWord) && isPossible(word: clearWord) && differFromRoot(word: clearWord) else { return }
        
        score += clearWord.count
        
        withAnimation {
            usedWords.insert(clearWord, at: 0)
        }
        newWord = ""
    }
    
    private func startGame() {
        if let startWordUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String.init(contentsOf: startWordUrl) {
                let words = startWords.components(separatedBy: "\n")
                rootWord = words.randomElement() ?? "swiftui"
                usedWords = []
                score = 0
                return
            }
        }
        
        fatalError("Application cannot find start.txt file with starting words")
    }
    
    private func isOrigin(word: String) -> Bool {
        if !usedWords.contains(word) {
            return true
        } else {
            alertTitle = "Your word is already used"
            alertMessage = "Be more original!"
            showingAlert = true
            return false
        }
    }
    
    private func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in newWord {
            if let index = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: index)
            } else {
                alertTitle = "Your word is invalid"
                alertMessage = "Cannot create word \(word) from \(rootWord)"
                showingAlert = true
                return false
            }
        }
        
        return true
    }
    
    private func differFromRoot(word: String) -> Bool {
        if rootWord == word {
            alertTitle = "You cannot use root word"
            alertMessage = "You should come up with your own words"
            showingAlert = true
            return false
        }
        return true
    }
    
    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        if mispelledRange.location == NSNotFound {
            return true
        } else {
            alertTitle = "Your word does not exist"
            alertMessage = "You are not allowed to invent new words"
            showingAlert = true
            return false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
