import SwiftUI

struct NewNoteView: View {
    @EnvironmentObject var store: NotesStore
    // @Environment(\.dismiss) var dismiss // No longer using explicit dismiss, controlled by offset

    @Binding var isPresented: Bool
    @Binding var offset: CGFloat

    @State private var title: String = ""
    @State private var content: String = ""
    
    // Computed property to determine if we're in compact mode (partially visible)
    private var isCompactMode: Bool {
        !isPresented && offset > 0
    }

    var body: some View {
        VStack(spacing: 0) {
            if isCompactMode {
                // Compact preview header when partially visible
                VStack(spacing: 8) {
                    // Visual handle indicator
                    Capsule()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 50, height: 6)
                        .padding(.top, 8)
                    
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("New Note")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Text("Swipe up")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
                }
                .frame(height: UIScreen.main.bounds.height * 0.2) // Takes up the 20% visible area
                
            } else {
                // Full interface when expanded
                // Top Bar with Save/Cancel
                HStack {
                    Button("Cancel") {
                        withAnimation(.spring()) {
                            offset = UIScreen.main.bounds.height * 0.8
                            isPresented = false
                        }
                        // Clear fields when cancelled
                        title = ""
                        content = ""
                    }
                    .padding()
                    .foregroundColor(.white)

                    Spacer()
                    
                    // Visual handle indicator
                    VStack(spacing: 4) {
                        Capsule()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 50, height: 6)
                        Text("New Note").font(.headline).foregroundColor(.white)
                    }
                    
                    Spacer()

                    Button("Save") {
                        if !title.isEmpty || !content.isEmpty {
                            store.addNote(title: title, content: content)
                            title = "" // Clear fields after saving
                            content = ""
                            withAnimation(.spring()) {
                                offset = UIScreen.main.bounds.height * 0.8
                                isPresented = false
                            }
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    .disabled(title.isEmpty && content.isEmpty)
                }
                .padding(.top, 20) // Add padding for status bar area if needed, or rely on safe area
                .background(Color.black.opacity(0.5)) // Slightly darker/more opaque top bar for controls

                // Form content
                Form {
                    TextField("Title", text: $title)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    
                    TextEditor(text: $content)
                        .scrollContentBackground(.hidden) // Needed for TextEditor background
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .frame(minHeight: 200, idealHeight: 300, maxHeight: .infinity)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .background(Color.clear) // Form background should be clear to let the main background through
            }
        }
        .background(
            // Glassy translucent effect
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .edgesIgnoringSafeArea(.all)
        )
        .cornerRadius(20, corners: [.topLeft, .topRight]) // Rounded top corners
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Helper for UIBlurEffect
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

// Extension for rounding specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


// Preview might need adjustment due to Bindings
struct NewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        // Create mock bindings for preview
        @State var isPresentedMock = true
        @State var offsetMock: CGFloat = 0

        NewNoteView(isPresented: $isPresentedMock, offset: $offsetMock)
            .environmentObject(NotesStore())
            .background(Color.blue) // To see the glassy effect against a color
    }
} 