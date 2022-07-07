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
    
    var body: some View {
        NavigationView {
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
            
        }
        .navigationTitle(rootWord)
        .onSubmit {
            addWord()
        }
    }
    
    private func addWord() {
        let clearWord = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard clearWord.count > 1 else { return }
        
        // more validation
        
        withAnimation {
            usedWords.insert(clearWord, at: 0)
        }
        newWord = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
