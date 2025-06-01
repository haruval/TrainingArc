import SwiftUI

struct NewNoteView: View {
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTextFieldFocused: Bool

    @State private var noteText: String = ""
    @State private var dragOffset: CGFloat = 0
    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Completely transparent background
                Color.clear
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    Spacer() // Push glassy interface to bottom
                    
                    // Glassy note entry interface
                    ZStack {
                        // Glassy frosted background for the text entry area
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        VStack(spacing: 0) {
                            // Draggable top bar - always visible
                            VStack(spacing: 8) {
                                // Drag handle
                                Capsule()
                                    .fill(Color.white.opacity(0.7))
                                    .frame(width: 40, height: 4)
                                    .padding(.top, 12)
                                
                                Spacer()
                            }
                            .frame(height: 30)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        if gesture.translation.height > 0 {
                                            dragOffset = gesture.translation.height
                                        }
                                    }
                                    .onEnded { gesture in
                                        if gesture.translation.height > 100 {
                                            // If dragged down more than 100 points, dismiss
                                            saveNoteIfNotEmpty()
                                            dismiss()
                                        } else {
                                            // Snap back
                                            withAnimation(.spring()) {
                                                dragOffset = 0
                                            }
                                        }
                                    }
                            )
                            
                            // Note type indicator
                            HStack {
                                Image(systemName: "note.text")
                                    .foregroundColor(.orange)
                                    .font(.title3)
                                Text("New Note")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                            
                            // Main text input area
                            TextEditor(text: $noteText)
                                .focused($isTextFieldFocused)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .foregroundColor(.white)
                                .font(.body)
                                .padding(.horizontal, 20)
                                .padding(.top, 10)
                                .onTapGesture {
                                    // Ensure focus when tapped
                                    isTextFieldFocused = true
                                }
                                .onChange(of: isTextFieldFocused) { oldValue, newValue in
                                    // When TextEditor loses focus (Done button pressed), save and close
                                    if !newValue && !noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                        saveNoteIfNotEmpty()
                                        dismiss()
                                    }
                                }
                                .onSubmit {
                                    // Fallback for enter key (though TextEditor typically doesn't use this)
                                    saveNoteIfNotEmpty()
                                    dismiss()
                                }
                                .submitLabel(.done)
                            
                            // Bottom spacer to accommodate keyboard
                            Spacer()
                                .frame(height: keyboardHeight > 0 ? 10 : 0)
                        }
                    }
                    .frame(height: keyboardHeight > 0 ? max(300, geometry.size.height - keyboardHeight - 100) : geometry.size.height * 0.85) // Better height calculation
                    .cornerRadius(20)
                    .offset(y: dragOffset)
                    // Position the interface above the keyboard while keeping drag bar visible
                    .offset(y: keyboardHeight > 0 ? -keyboardHeight + geometry.safeAreaInsets.bottom : 0)
                }
            }
        }
        .background(Color.clear) // Ensure no background at all
        .presentationBackground(.clear) // Make sheet background transparent
        .presentationBackgroundInteraction(.enabled) // Allow interaction with background
        .onAppear {
            // Automatically focus text field to open keyboard with longer delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
            
            // Listen for keyboard notifications
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
        .onDisappear {
            // Clean up keyboard observers
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    private func saveNoteIfNotEmpty() {
        if !noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            store.addNote(title: "Quick Note", content: noteText)
        }
    }
}

struct NewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteView()
            .environmentObject(DataStore())
    }
} 