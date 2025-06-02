import SwiftUI

struct NewNoteView: View {
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFieldFocused: Bool

    @State private var noteTitle: String = ""
    @State private var noteText: String = ""
    @State private var dragOffset: CGFloat = 0
    @State private var keyboardHeight: CGFloat = 0
    @State private var isVisible = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Enhanced glassy note entry interface
                    ZStack {
                        // Main glassy background with enhanced blur
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.white.opacity(0.4), .orange.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                            .shadow(color: .orange.opacity(0.2), radius: 30, x: 0, y: 15)
                            .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                        
                        VStack(spacing: 0) {
                            // Elegant drag handle area
                            VStack(spacing: 12) {
                                // Refined drag handle
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [.white.opacity(0.8), .orange.opacity(0.6)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: 50, height: 5)
                                    .shadow(color: .orange.opacity(0.3), radius: 4)
                                    .padding(.top, 16)
                                
                                // Header with enhanced styling
                                HStack(spacing: 12) {
                                    // Glowing note icon
                                    ZStack {
                                        Circle()
                                            .fill(.orange.opacity(0.2))
                                            .frame(width: 36, height: 36)
                                        
                                        Image(systemName: "note.text")
                                            .foregroundColor(.orange)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                    }
                                    
                                    Text("New Note")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [.white, .orange.opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                    
                                    Spacer()
                                    
                                    // Enhanced save button
                                    Button(action: {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                            saveNoteIfNotEmpty()
                                            dismiss()
                                        }
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(.green.opacity(0.2))
                                                .frame(width: 36, height: 36)
                                                .overlay(
                                                    Circle()
                                                        .stroke(.green.opacity(0.4), lineWidth: 1)
                                                )
                                            
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.green)
                                                .font(.title3)
                                                .fontWeight(.bold)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .scaleEffect(isVisible ? 1.0 : 0.8)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: isVisible)
                                }
                                .padding(.horizontal, 24)
                                .padding(.bottom, 8)
                            }
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        if gesture.translation.height > 0 {
                                            dragOffset = gesture.translation.height
                                        }
                                    }
                                    .onEnded { gesture in
                                        if gesture.translation.height > 100 {
                                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                                dismiss()
                                            }
                                        } else {
                                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                                dragOffset = 0
                                            }
                                        }
                                    }
                            )
                            
                            // Title input field
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "textformat")
                                        .foregroundColor(.cyan)
                                        .font(.caption)
                                    Text("Title")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding(.horizontal, 24)
                                
                                TextField("Enter note title...", text: $noteTitle)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.ultraThinMaterial)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(.white.opacity(0.1), lineWidth: 1)
                                            )
                                    )
                                    .padding(.horizontal, 20)
                            }
                            .opacity(isVisible ? 1 : 0)
                            .offset(y: isVisible ? 0 : 20)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: isVisible)
                            
                            // Content text editor
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "text.alignleft")
                                        .foregroundColor(.cyan)
                                        .font(.caption)
                                    Text("Content")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding(.horizontal, 24)
                                .padding(.top, 16)
                                
                                ZStack(alignment: .topLeading) {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.ultraThinMaterial)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(.white.opacity(0.1), lineWidth: 1)
                                        )
                                        .frame(minHeight: 120)
                                    
                                    TextEditor(text: $noteText)
                                        .focused($isTextFieldFocused)
                                        .scrollContentBackground(.hidden)
                                        .background(Color.clear)
                                        .foregroundColor(.white)
                                        .font(.body)
                                        .padding(16)
                                        .onTapGesture {
                                            isTextFieldFocused = true
                                        }
                                    
                                    if noteText.isEmpty && !isTextFieldFocused {
                                        Text("Write your note here...")
                                            .foregroundColor(.white.opacity(0.5))
                                            .font(.body)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 24)
                                            .allowsHitTesting(false)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            .opacity(isVisible ? 1 : 0)
                            .offset(y: isVisible ? 0 : 30)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: isVisible)
                            
                            // Bottom spacing
                            Spacer()
                                .frame(height: max(20, keyboardHeight > 0 ? 20 : 40))
                        }
                    }
                    .frame(height: keyboardHeight > 0 ? 
                           max(400, geometry.size.height - keyboardHeight - 60) : 
                           geometry.size.height * 0.75)
                    .offset(y: dragOffset)
                    .offset(y: keyboardHeight > 0 ? -keyboardHeight + geometry.safeAreaInsets.bottom : 0)
                    .scaleEffect(isVisible ? 1.0 : 0.95)
                    .opacity(isVisible ? 1.0 : 0.0)
                }
            }
        }
        .background(Color.clear)
        .presentationBackground(.clear)
        .presentationBackgroundInteraction(.enabled)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                isVisible = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                isTextFieldFocused = true
            }
            
            setupKeyboardObservers()
        }
        .onDisappear {
            removeKeyboardObservers()
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation(.easeInOut(duration: 0.3)) {
                    keyboardHeight = keyboardFrame.height
                }
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                keyboardHeight = 0
            }
        }
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func saveNoteIfNotEmpty() {
        let trimmedTitle = noteTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = noteText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedContent.isEmpty || !trimmedTitle.isEmpty {
            let finalTitle = trimmedTitle.isEmpty ? "Quick Note" : trimmedTitle
            let finalContent = trimmedContent.isEmpty ? "No content" : trimmedContent
            store.addNote(title: finalTitle, content: finalContent)
        }
    }
}

struct NewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteView()
            .environmentObject(DataStore())
    }
} 