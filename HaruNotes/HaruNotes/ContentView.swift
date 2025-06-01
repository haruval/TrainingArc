//
//  ContentView.swift
//  TrainingArc
//
//  Created by Ari Gladstone on 5/31/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var store = DataStore()
    @State private var showingNewNoteView = false
    @State private var showingNewTaskView = false
    @State private var showingCalendarView = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Page indicator and date display
                    VStack(spacing: 6) {
                        // Page indicator dots
                        HStack(spacing: 12) {
                            ForEach(DatePage.allCases, id: \.self) { page in
                                Circle()
                                    .fill(store.currentPage == page ? Color.white : Color.gray.opacity(0.4))
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(store.currentPage == page ? 1.2 : 1.0)
                                    .animation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0), value: store.currentPage)
                            }
                        }
                        
                        // Current page name and date
                        VStack(spacing: 2) {
                            Text(store.currentPage.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                                .animation(.easeInOut(duration: 0.3), value: store.currentPage)
                            Text(store.getCurrentDateString())
                                .font(.caption)
                                .foregroundColor(.gray.opacity(0.8))
                                .animation(.easeInOut(duration: 0.3), value: store.currentPage)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 2)
                    
                    // Main content in a TabView for swipe navigation
                    TabView(selection: $store.currentPage) {
                        ForEach(DatePage.allCases, id: \.self) { page in
                            DayContentView()
                                .environmentObject(store)
                                .tag(page)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.3), value: store.currentPage)
                    .onChange(of: store.currentPage) { oldValue, newValue in
                        // Smooth transition when page changes
                        withAnimation(.easeInOut(duration: 0.3)) {
                            store.switchToPage(newValue)
                        }
                    }
                }

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
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .navigationBarBackButtonHidden(false)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Training Arc")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            showingCalendarView = true
                        }) {
                            Image(systemName: "calendar")
                                .foregroundColor(.yellow)
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 0)
                }
            }
            .onAppear {
                // Ensure we start at Today page
                store.switchToPage(.today)
                
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
        .sheet(isPresented: $showingCalendarView) {
            CalendarView()
                .environmentObject(store)
        }
    }
}

struct DayContentView: View {
    @EnvironmentObject var store: DataStore

    var body: some View {
        List {
            // Progress Section
            ProgressSectionView()
                .environmentObject(store)
            
            // Tasks Section
            if !store.tasks.isEmpty {
                Section {
                    ForEach(store.tasks) { task in
                        NavigationLink(destination: TaskDetailView(task: task).environmentObject(store)) {
                            HStack {
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        store.toggleTask(task)
                                    }
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
                                        .animation(.easeInOut(duration: 0.2), value: task.isCompleted)
                                    Text(task.content)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                        .foregroundColor(task.isCompleted ? .gray.opacity(0.7) : .gray)
                                        .strikethrough(task.isCompleted)
                                        .animation(.easeInOut(duration: 0.2), value: task.isCompleted)
                                    
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
        .scrollContentBackground(.hidden)
        .background(Color.black)
        .transition(.opacity.combined(with: .slide))
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
                
                Button("Delete Note") {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        store.deleteNote(note)
                    }
                    dismiss()
                }
                .foregroundColor(.red)
                .padding()
            }
        }
        .navigationTitle(note.title)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}

struct TaskDetailView: View {
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    var task: Task

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(task.content)
                        .foregroundColor(.gray)
                }
                
                if let scheduledTime = task.scheduledTime {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Scheduled Time")
                            .font(.headline)
                            .foregroundColor(.white)
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.orange)
                            Text(scheduledTime, style: .time)
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Status")
                        .font(.headline)
                        .foregroundColor(.white)
                    HStack {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(task.isCompleted ? .green : .gray)
                        Text(task.isCompleted ? "Completed" : "Pending")
                            .foregroundColor(task.isCompleted ? .green : .gray)
                    }
                }
                
                Spacer()
            }
            .padding()
            
            // Floating completion toggle button
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            store.toggleTask(task)
                        }
                    }) {
                        Image(systemName: task.isCompleted ? "arrow.uturn.backward" : "checkmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(.ultraThinMaterial, in: Circle())
                            .overlay(
                                Circle()
                                    .stroke(task.isCompleted ? Color.orange.opacity(0.3) : Color.green.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle(task.title)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        store.deleteTask(task)
                    }
                    dismiss()
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.yellow)
                        .font(.title3)
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
