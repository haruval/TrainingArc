import SwiftUI

class DataStore: ObservableObject {
    @Published var notes: [Note] = []
    @Published var tasks: [Task] = []
    
    init() {
        // Sample notes
        notes = [
            Note(title: "Welcome to Moss", content: "This is your new notes and task management app. Stay organized and productive!"),
            Note(title: "Meeting Notes", content: "Discussed project timeline and deliverables. Next steps: review mockups and finalize requirements."),
            Note(title: "Ideas", content: "App features to consider: dark mode, cloud sync, reminders, categories.")
        ]
        
        // Sample tasks with scheduled times
        let calendar = Calendar.current
        let now = Date()
        
        tasks = [
            Task(title: "Review quarterly reports", content: "Go through Q3 financial reports and prepare summary", isCompleted: false, scheduledTime: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: now)),
            Task(title: "Call dentist", content: "Schedule cleaning appointment", isCompleted: false, scheduledTime: calendar.date(bySettingHour: 10, minute: 30, second: 0, of: now)),
            Task(title: "Buy groceries", content: "Milk, eggs, bread, apples", isCompleted: true, scheduledTime: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now)),
            Task(title: "Finish presentation", content: "Complete slides for Monday's client meeting", isCompleted: false, scheduledTime: nil)
        ]
    }
    
    func addNote(title: String, content: String) {
        let newNote = Note(title: title, content: content)
        notes.insert(newNote, at: 0) // Add to the beginning
    }
    
    func addTask(title: String, content: String, scheduledTime: Date? = nil) {
        let newTask = Task(title: title, content: content, scheduledTime: scheduledTime)
        tasks.insert(newTask, at: 0) // Add to the beginning
    }
    
    func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func deleteNote(_ note: Note) {
        tasks.removeAll { $0.id == note.id }
        notes.removeAll { $0.id == note.id }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
    }
} 