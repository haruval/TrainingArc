import SwiftUI

struct NewNoteView: View {
    @EnvironmentObject var store: NotesStore
    @Environment(\.dismiss) var dismiss

    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                // Black background to match the app theme
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Title input with green styling
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        TextField("Enter note title...", text: $title)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color.green.opacity(0.8))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .font(.body)
                    }
                    .padding(.horizontal)
                    
                    // Content input with green styling
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Content")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        TextEditor(text: $content)
                            .scrollContentBackground(.hidden)
                            .padding()
                            .background(Color.green.opacity(0.8))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .font(.body)
                            .frame(minHeight: 200)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !title.isEmpty || !content.isEmpty {
                            store.addNote(title: title.isEmpty ? "Untitled" : title, content: content)
                            dismiss()
                        }
                    }
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
                    .disabled(title.isEmpty && content.isEmpty)
                }
            }
        }
    }
}

struct NewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteView()
            .environmentObject(NotesStore())
    }
} 