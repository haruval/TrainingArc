//
//  ContentView.swift
//  HaruNotes
//
//  Created by Ari Gladstone on 5/31/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var store = NotesStore()
    @State private var newNoteViewOffset: CGFloat = UIScreen.main.bounds.height * 0.8 // Show bottom 20%
    @State private var isNewNoteViewPresented = false

    private let pullUpThreshold: CGFloat = 50 // How much user needs to swipe up to fully open
    private let partialHeight = UIScreen.main.bounds.height * 0.2 // 20% visible at bottom

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
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
                .padding(.bottom, partialHeight) // Add padding to prevent list items from being hidden behind the partial view

                // Slide-up NewNoteView (always partially visible)
                VStack(spacing: 0) {
                    NewNoteView(isPresented: $isNewNoteViewPresented, offset: $newNoteViewOffset)
                        .environmentObject(store)
                        .frame(height: UIScreen.main.bounds.height * 0.8) // Full height when expanded
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    let newOffset = newNoteViewOffset + gesture.translation.height
                                    // Constrain the offset between 0 (fully open) and 80% (20% visible)
                                    let constrainedOffset = max(0, min(UIScreen.main.bounds.height * 0.8, newOffset))
                                    self.newNoteViewOffset = constrainedOffset
                                }
                                .onEnded { gesture in
                                    withAnimation(.spring()) {
                                        if gesture.translation.height < -pullUpThreshold {
                                            // Swiped up significantly, fully open
                                            self.newNoteViewOffset = 0
                                            isNewNoteViewPresented = true
                                        } else if gesture.translation.height > pullUpThreshold {
                                            // Swiped down significantly, return to partial view
                                            self.newNoteViewOffset = UIScreen.main.bounds.height * 0.8
                                            isNewNoteViewPresented = false
                                        } else {
                                            // Small swipe, snap to nearest position
                                            if newNoteViewOffset < UIScreen.main.bounds.height * 0.4 {
                                                // Closer to fully open
                                                self.newNoteViewOffset = 0
                                                isNewNoteViewPresented = true
                                            } else {
                                                // Closer to partial view
                                                self.newNoteViewOffset = UIScreen.main.bounds.height * 0.8
                                                isNewNoteViewPresented = false
                                            }
                                        }
                                    }
                                }
                        )
                }
                .background(Color.clear) // Ensure the VStack itself doesn't block underlying views
                .offset(y: newNoteViewOffset)
                .edgesIgnoringSafeArea(.bottom) // Allow it to go to the very bottom
                .zIndex(1) // Ensure it's above the list
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
