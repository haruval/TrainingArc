import SwiftUI

class NotesStore: ObservableObject {
    @Published var notes: [Note] = []

    init() {
        // Load notes from storage (e.g., UserDefaults or a file)
        // For now, we'll start with some sample data
        notes = [
            Note(title: "First Note", content: "This is the content of the first note."),
            Note(title: "Second Note", content: "This is the content of the second note.")
        ]
    }

    func addNote(title: String, content: String) {
        let newNote = Note(title: title, content: content)
        notes.append(newNote)
        // Save notes to storage
    }
} 