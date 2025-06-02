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
    @State private var showingCalendarView = false
    @State private var showingInfoView = false
    @State private var currentPageVisible = true
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        NavigationView {
            ZStack {
                // Beautiful ambient glassy background with page-specific colors
                GlassyBackground(
                    page: store.currentPage,
                    intensity: 0.4  // Subtle ambient gradient
                )
                
                VStack(spacing: 0) {
                    // Elegant header with page indicators
                    VStack(spacing: 16) {
                        // App title with glow effect
                        HStack {
                            Text("Training Arc")
                                .font(.system(size: 28, weight: .light, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, .cyan.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Spacer()
                            
                            // Info button with glassy design
                            Button(action: {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    showingInfoView = true
                                }
                            }) {
                                Image(systemName: "info.circle")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(.ultraThinMaterial, in: Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(.white.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            
                            // Calendar button with glassy design
                            Button(action: {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    showingCalendarView = true
                                }
                            }) {
                                Image(systemName: "calendar")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(.ultraThinMaterial, in: Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(.white.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                        
                        // Elegant page indicators
                        VStack(spacing: 12) {
                            HStack(spacing: 16) {
                                ForEach(DatePage.allCases, id: \.self) { page in
                                    Button(action: {
                                        switchToPage(page)
                                    }) {
                                        VStack(spacing: 6) {
                                            Circle()
                                                .fill(store.currentPage == page ? 
                                                     LinearGradient(colors: [.cyan, .blue], startPoint: .top, endPoint: .bottom) : 
                                                     LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.3)], startPoint: .top, endPoint: .bottom))
                                                .frame(width: store.currentPage == page ? 12 : 8, height: store.currentPage == page ? 12 : 8)
                                                .overlay(
                                                    Circle()
                                                        .stroke(.white.opacity(store.currentPage == page ? 0.8 : 0.3), lineWidth: 1)
                                                )
                                                .shadow(color: store.currentPage == page ? .cyan.opacity(0.5) : .clear, radius: 8)
                                            
                                            Text(page.title)
                                                .font(.caption)
                                                .fontWeight(store.currentPage == page ? .semibold : .regular)
                                                .foregroundColor(store.currentPage == page ? .white : .gray)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: store.currentPage)
                                }
                            }
                            
                            // Current date with elegant styling
                            Text(store.getCurrentDateString())
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(.ultraThinMaterial, in: Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(.white.opacity(0.2), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 20)
                    
                    // Main content with flowing transitions and swipe gestures
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            // Progress Section with glassy card
                            GlassyCard(cornerRadius: 20) {
                                ProgressSectionView()
                                    .environmentObject(store)
                                    .padding(20)
                            }
                            .padding(.horizontal, 20)
                            .flowingTransition(from: .bottom, isVisible: currentPageVisible)
                            
                            // Tasks Section
                            if !store.tasks.isEmpty {
                                GlassyCard(cornerRadius: 20) {
                                    VStack(alignment: .leading, spacing: 16) {
                                        HStack {
                                            Image(systemName: "checkmark.square")
                                                .foregroundColor(.blue)
                                                .font(.title3)
                                            Text("Tasks")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            Spacer()
                                        }
                                        
                                        ForEach(Array(store.tasks.enumerated()), id: \.element.id) { index, task in
                                            TaskRowView(task: task)
                                                .environmentObject(store)
                                                .flowingTransition(from: .bottom, isVisible: currentPageVisible)
                                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: currentPageVisible)
                                        }
                                    }
                                    .padding(20)
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            // Notes Section
                            if !store.notes.isEmpty {
                                GlassyCard(cornerRadius: 20) {
                                    VStack(alignment: .leading, spacing: 16) {
                                        HStack {
                                            Image(systemName: "note.text")
                                                .foregroundColor(.orange)
                                                .font(.title3)
                                            Text("Notes")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            Spacer()
                                        }
                                        
                                        ForEach(Array(store.notes.enumerated()), id: \.element.id) { index, note in
                                            NoteRowView(note: note)
                                                .environmentObject(store)
                                                .flowingTransition(from: .bottom, isVisible: currentPageVisible)
                                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: currentPageVisible)
                                        }
                                    }
                                    .padding(20)
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            // Bottom spacing for floating buttons
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .offset(x: dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                let threshold: CGFloat = 100
                                let horizontalAmount = value.translation.width
                                let horizontalVelocity = value.predictedEndTranslation.width
                                
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    dragOffset = 0
                                }
                                
                                // Determine swipe direction and switch pages
                                if horizontalAmount > threshold || horizontalVelocity > 200 {
                                    // Swiped right - go to previous day
                                    switchToPreviousPage()
                                } else if horizontalAmount < -threshold || horizontalVelocity < -200 {
                                    // Swiped left - go to next day
                                    switchToNextPage()
                                }
                            }
                    )
                }

                // Floating action buttons with glassy design
                VStack {
                    Spacer()
                    
                    HStack(spacing: 24) {
                        Spacer()
                        
                        // Task button
                        FloatingGlassyButton(
                            icon: "checkmark.square",
                            accentColor: .blue
                        ) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                showingNewTaskView = true
                            }
                        }
                        
                        // Note button
                        FloatingGlassyButton(
                            icon: "note.text",
                            accentColor: .orange
                        ) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                showingNewNoteView = true
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
            .preferredColorScheme(.dark)
        }
        .accentColor(.white)
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
        .sheet(isPresented: $showingInfoView) {
            InfoView()
        }
    }
    
    // MARK: - Helper Methods
    private func switchToPage(_ page: DatePage) {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            currentPageVisible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            store.switchToPage(page)
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                currentPageVisible = true
            }
        }
    }
    
    private func switchToPreviousPage() {
        let currentIndex = DatePage.allCases.firstIndex(of: store.currentPage) ?? 1
        if currentIndex > 0 {
            let previousPage = DatePage.allCases[currentIndex - 1]
            switchToPage(previousPage)
        }
    }
    
    private func switchToNextPage() {
        let currentIndex = DatePage.allCases.firstIndex(of: store.currentPage) ?? 1
        if currentIndex < DatePage.allCases.count - 1 {
            let nextPage = DatePage.allCases[currentIndex + 1]
            switchToPage(nextPage)
        }
    }
}

// MARK: - Task Row Component
struct TaskRowView: View {
    let task: Task
    @EnvironmentObject var store: DataStore
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    store.toggleTask(task)
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title3)
                    .scaleEffect(isPressed ? 1.2 : 1.0)
                    .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isPressed)
            }
            .buttonStyle(PlainButtonStyle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title.isEmpty ? "Task" : task.title)
                    .font(.headline)
                    .foregroundColor(task.isCompleted ? .gray : .white)
                    .strikethrough(task.isCompleted)
                
                if !task.content.isEmpty {
                    Text(task.content)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                
                if let scheduledTime = task.scheduledTime {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text(scheduledTime, style: .time)
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

// MARK: - Note Row Component
struct NoteRowView: View {
    let note: Note
    @EnvironmentObject var store: DataStore
    @State private var showingNoteDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note.title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
            
            if !note.content.isEmpty {
                Text(note.content)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
            
            HStack {
                Text(note.dateCreated, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.8))
                Spacer()
                
                // Visual indicator that it's clickable
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.6))
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                showingNoteDetail = true
            }
        }
        .sheet(isPresented: $showingNoteDetail) {
            NoteDetailView(note: note)
                .environmentObject(store)
        }
    }
}

// MARK: - Task Detail View
struct TaskDetailView: View {
    let task: Task
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            GlassyBackground(colors: [.blue, .purple, .indigo], intensity: 0.3)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Task header
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                store.toggleTask(task)
                            }
                        }) {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                                .font(.title)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.title.isEmpty ? "Task" : task.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .strikethrough(task.isCompleted)
                            
                            if let scheduledTime = task.scheduledTime {
                                HStack(spacing: 6) {
                                    Image(systemName: "clock")
                                        .font(.caption)
                                    Text(scheduledTime, style: .time)
                                        .font(.caption)
                                }
                                .foregroundColor(.blue)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    // Task content
                    if !task.content.isEmpty {
                        GlassyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Details")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text(task.content)
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                            .padding(20)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
        }
    }
}

// MARK: - Note Detail View
struct NoteDetailView: View {
    let note: Note
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    @State private var isVisible = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Beautiful ambient glassy background
                GlassyBackground(
                    colors: [.orange, .red, .pink, .purple],
                    intensity: 0.3
                )
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Note header with elegant styling
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                // Note icon with glow
                                ZStack {
                                    Circle()
                                        .fill(.orange.opacity(0.3))
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: "note.text")
                                        .foregroundColor(.orange)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }
                                .scaleEffect(isVisible ? 1.0 : 0.8)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: isVisible)
                                
                                Spacer()
                                
                                // Date badge
                                Text(note.dateCreated, style: .date)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(.ultraThinMaterial, in: Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(.white.opacity(0.2), lineWidth: 1)
                                    )
                                    .opacity(isVisible ? 1.0 : 0.0)
                                    .offset(x: isVisible ? 0 : 20)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: isVisible)
                            }
                            
                            // Note title
                            Text(note.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, .orange.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .opacity(isVisible ? 1.0 : 0.0)
                                .offset(y: isVisible ? 0 : -20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: isVisible)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        
                        // Note content in beautiful glassy card
                        if !note.content.isEmpty {
                            GlassyCard(cornerRadius: 20) {
                                ScrollView {
                                    Text(note.content)
                                        .font(.body)
                                        .foregroundColor(.white.opacity(0.9))
                                        .lineSpacing(6)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(maxHeight: 400)
                                .padding(24)
                            }
                            .padding(.horizontal, 20)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(y: isVisible ? 0 : 30)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: isVisible)
                        }
                        
                        // Simple note metadata at bottom
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Created:")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(note.dateCreated, style: .date)
                                    .foregroundColor(.white)
                            }
                            
                            HStack {
                                Text("Time:")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(note.dateCreated, style: .time)
                                    .foregroundColor(.white)
                            }
                        }
                        .font(.subheadline)
                        .padding(.horizontal, 24)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 30)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: isVisible)
                        
                        // Bottom spacing
                        Spacer()
                            .frame(height: 50)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        dismiss()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text("Back")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial, in: Capsule())
                    .overlay(
                        Capsule()
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                isVisible = true
            }
        }
    }
}

// MARK: - Info View
struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isVisible = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Beautiful ambient glassy background
                GlassyBackground(
                    colors: [.blue, .cyan, .teal, .green],
                    intensity: 0.3
                )
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header with elegant styling
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                // Info icon with glow
                                ZStack {
                                    Circle()
                                        .fill(.blue.opacity(0.3))
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }
                                .scaleEffect(isVisible ? 1.0 : 0.8)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: isVisible)
                                
                                Spacer()
                            }
                            
                            // Title
                            Text("About")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, .blue.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .opacity(isVisible ? 1.0 : 0.0)
                                .offset(y: isVisible ? 0 : -20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: isVisible)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        
                        // Main content in beautiful glassy card
                        GlassyCard(cornerRadius: 20) {
                            VStack(alignment: .leading, spacing: 20) {
                                // Creator info
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Created by Michael Ari Gladstone, or \"haru\" on the internet.")
                                        .font(.body)
                                        .foregroundColor(.white.opacity(0.9))
                                        .lineSpacing(4)
                                    
                                    Text("CS + CTD student at CU Boulder.")
                                        .font(.body)
                                        .foregroundColor(.white.opacity(0.9))
                                        .lineSpacing(4)
                                }
                                
                                Divider()
                                    .background(.white.opacity(0.2))
                                
                                // App story
                                Text("This summer I decided to fix the three main problems with myself: I was a washed radiant, I was fat, and I had no projects on my portfolio. I created this app to keep myself accountable, be something I would actually use daily to help stay organized, and teach myself SwiftUI.")
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineSpacing(6)
                            }
                            .padding(24)
                        }
                        .padding(.horizontal, 20)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 30)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: isVisible)
                        
                        // Social media links section
                        GlassyCard(cornerRadius: 20) {
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Connect")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                // Social media buttons in flowing layout
                                VStack(spacing: 16) {
                                    HStack(spacing: 16) {
                                        SocialMediaButton(
                                            label: "Twitter",
                                            color: .blue,
                                            url: "https://twitter.com/haruval"
                                        )
                                        
                                        SocialMediaButton(
                                            label: "YouTube",
                                            color: .red,
                                            url: "https://youtube.com/@haruval"
                                        )
                                    }
                                    
                                    HStack(spacing: 16) {
                                        SocialMediaButton(
                                            label: "Twitch",
                                            color: .purple,
                                            url: "https://twitch.tv/harumilktea"
                                        )
                                        
                                        SocialMediaButton(
                                            label: "Website",
                                            color: .green,
                                            url: "https://1haru.com"
                                        )
                                    }
                                }
                            }
                            .padding(24)
                        }
                        .padding(.horizontal, 20)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 30)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: isVisible)
                        
                        // Bottom spacing
                        Spacer()
                            .frame(height: 50)
                    }
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            dismiss()
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.caption)
                                .fontWeight(.semibold)
                            Text("Back")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial, in: Capsule())
                        .overlay(
                            Capsule()
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    isVisible = true
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Social Media Button Component
struct SocialMediaButton: View {
    let label: String
    let color: Color
    let url: String
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(color.opacity(0.4), lineWidth: 1.5)
                        )
                        .shadow(color: color.opacity(0.3), radius: isPressed ? 5 : 15, x: 0, y: isPressed ? 2 : 8)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
            // Add haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
