//
//  ContentView.swift
//  HaruNotes
//
//  Created by Ari Gladstone on 5/31/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var store = DataStore()
    @State private var showingNewNoteView = false
    @State private var showingNewTaskView = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all) // Black background

                List {
                    // Tasks Section
                    if !store.tasks.isEmpty {
                        Section {
                            ForEach(store.tasks) { task in
                                NavigationLink(destination: TaskDetailView(task: task).environmentObject(store)) {
                                    HStack {
                                        Button(action: {
                                            store.toggleTask(task)
                                        }) {
                                            Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                                                .foregroundColor(task.isCompleted ? .green : .gray)
                                                .font(.title3)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(task.title)
                                                .font(.headline)
                                                .foregroundColor(task.isCompleted ? .gray : .white)
                                                .strikethrough(task.isCompleted)
                                            Text(task.content)
                                                .font(.subheadline)
                                                .lineLimit(2)
                                                .foregroundColor(task.isCompleted ? .gray.opacity(0.7) : .gray)
                                                .strikethrough(task.isCompleted)
                                            
                                            // Display scheduled time if available
                                            if let scheduledTime = task.scheduledTime {
                                                HStack {
                                                    Image(systemName: "clock")
                                                        .foregroundColor(.orange)
                                                        .font(.caption)
                                                    Text(scheduledTime, style: .time)
                                                        .font(.caption)
                                                        .foregroundColor(.orange)
                                                }
                                                .padding(.top, 2)
                                            }
                                        }
                                        Spacer()
                                    }
                                }
                                .listRowBackground(Color.black)
                            }
                        } header: {
                            HStack {
                                Image(systemName: "checkmark.square")
                                    .foregroundColor(.blue)
                                Text("Tasks")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    // Notes Section
                    if !store.notes.isEmpty {
                        Section {
                            ForEach(store.notes) { note in
                                NavigationLink(destination: NoteDetailView(note: note).environmentObject(store)) {
                                    HStack {
                                        Image(systemName: "note.text")
                                            .foregroundColor(.orange)
                                            .font(.title3)
                                            .frame(width: 30)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(note.title)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            Text(note.content)
                                                .font(.subheadline)
                                                .lineLimit(2)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                    }
                                }
                                .listRowBackground(Color.black)
                            }
                        } header: {
                            HStack {
                                Image(systemName: "note.text")
                                    .foregroundColor(.orange)
                                Text("Notes")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .navigationTitle("Moss")
                .navigationBarTitleDisplayMode(.large)
                .preferredColorScheme(.dark)

                // Two floating buttons positioned slightly above the home bar
                VStack {
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Spacer()
                        
                        // Task button (blue-tinted)
                        Button(action: {
                            showingNewTaskView = true
                        }) {
                            Image(systemName: "checkmark.square")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(.ultraThinMaterial, in: Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        
                        // Note button (orange-tinted)
                        Button(action: {
                            showingNewNoteView = true
                        }) {
                            Image(systemName: "note.text")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(.ultraThinMaterial, in: Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 100)
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
        .sheet(isPresented: $showingNewTaskView) {
            NewTaskView()
                .environmentObject(store)
        }
    }
}

struct NoteDetailView: View {
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    var note: Note

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text(note.content)
                    .padding()
                    .foregroundColor(.white)
                Spacer()
            }
            .navigationTitle(note.title)
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        store.deleteNote(note)
                        dismiss()
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

struct TaskDetailView: View {
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    var task: Task

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        store.toggleTask(task)
                    }) {
                        Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                            .foregroundColor(task.isCompleted ? .green : .gray)
                            .font(.title)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text(task.isCompleted ? "Completed" : "Pending")
                        .font(.subheadline)
                        .foregroundColor(task.isCompleted ? .green : .gray)
                }
                .padding()
                
                // Display scheduled time if available
                if let scheduledTime = task.scheduledTime {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.orange)
                            .font(.title3)
                        VStack(alignment: .leading) {
                            Text("Scheduled Time")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(scheduledTime, style: .time)
                                .font(.headline)
                                .foregroundColor(.orange)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
                
                Text(task.content)
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .strikethrough(task.isCompleted)
                
                Spacer()
            }
            .navigationTitle(task.title)
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        store.deleteTask(task)
                        dismiss()
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
