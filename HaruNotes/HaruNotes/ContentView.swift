//
//  ContentView.swift
//  HaruNotes
//
//  Created by Ari Gladstone on 5/31/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var store = NotesStore()
    @State private var showingNewNoteView = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all) // Black background

                List {
                    ForEach(store.notes) { note in
                        NavigationLink(destination: NoteDetailView(note: note).environmentObject(store)) {
                            VStack(alignment: .leading) {
                                Text(note.title)
                                    .font(.headline)
                                    .foregroundColor(.white) // Ensure text is visible on black
                                Text(note.content)
                                    .font(.subheadline)
                                    .lineLimit(2)
                                    .foregroundColor(.gray) // Ensure text is visible on black
                            }
                        }
                        .listRowBackground(Color.black) // Make list rows blend with background
                    }
                }
                .navigationTitle("HaruNotes")
                .navigationBarTitleDisplayMode(.large)
                .preferredColorScheme(.dark) // Ensures navigation bar elements are light

                // Floating button positioned slightly below center
                VStack {
                    Spacer()
                    Spacer() // This creates the "slightly below center" positioning
                    
                    Button(action: {
                        showingNewNoteView = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(color: .green.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
            .onAppear {
                 // Customize navigation bar appearance
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .black
                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().tintColor = .white // For bar button items
            }
        }
        .accentColor(.white) // For NavigationView controls like back button
        .sheet(isPresented: $showingNewNoteView) {
            NewNoteView()
                .environmentObject(store)
        }
    }
}

struct NoteDetailView: View {
    @EnvironmentObject var store: NotesStore // Ensure store is passed if needed
    var note: Note

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text(note.title)
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.white)
                Text(note.content)
                    .padding()
                    .foregroundColor(.white)
                Spacer()
            }
            .navigationTitle(note.title)
            .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
