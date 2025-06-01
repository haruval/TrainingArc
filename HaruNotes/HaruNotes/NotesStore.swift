import SwiftUI
import Foundation

enum DatePage: CaseIterable {
    case yesterday, today, tomorrow
    
    var title: String {
        switch self {
        case .yesterday: return "Yesterday"
        case .today: return "Today"
        case .tomorrow: return "Tomorrow"
        }
    }
    
    func date(from baseDate: Date = Date()) -> Date {
        let calendar = Calendar.current
        switch self {
        case .yesterday: return calendar.date(byAdding: .day, value: -1, to: baseDate) ?? baseDate
        case .today: return baseDate
        case .tomorrow: return calendar.date(byAdding: .day, value: 1, to: baseDate) ?? baseDate
        }
    }
}

struct DayData {
    var notes: [Note] = []
    var tasks: [Task] = []
    var rrButtonStruck: Bool = false
    var workoutButtonStruck: Bool = false
}

class DataStore: ObservableObject {
    @Published var dayDataStore: [String: DayData] = [:]
    @Published var currentPage: DatePage = .today
    
    init() {
        // Initialize all three days with sample data
        setupSampleData()
        // Ensure we start at today
        currentPage = .today
    }
    
    private func setupSampleData() {
        let calendar = Calendar.current
        let baseDate = Date()
        
        // Today's data
        let todayKey = dateKey(for: .today)
        var todayData = DayData()
        todayData.notes = [
            Note(title: "Welcome to Training Arc", content: "This is your new notes and task management app. Stay organized and productive!"),
            Note(title: "Today's Goals", content: "Focus on completing the project timeline and reviewing quarterly reports.")
        ]
        todayData.tasks = [
            Task(title: "Review quarterly reports", content: "Go through Q3 financial reports and prepare summary", isCompleted: false, scheduledTime: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: baseDate)),
            Task(title: "Call dentist", content: "Schedule cleaning appointment", isCompleted: false, scheduledTime: calendar.date(bySettingHour: 10, minute: 30, second: 0, of: baseDate))
        ]
        dayDataStore[todayKey] = todayData
        
        // Yesterday's data
        let yesterdayKey = dateKey(for: .yesterday)
        var yesterdayData = DayData()
        yesterdayData.notes = [
            Note(title: "Meeting Notes", content: "Discussed project timeline and deliverables. Next steps: review mockups and finalize requirements."),
            Note(title: "Ideas", content: "App features to consider: dark mode, cloud sync, reminders, categories.")
        ]
        yesterdayData.tasks = [
            Task(title: "Buy groceries", content: "Milk, eggs, bread, apples", isCompleted: true, scheduledTime: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: DatePage.yesterday.date())),
            Task(title: "Finish presentation", content: "Complete slides for Monday's client meeting", isCompleted: true, scheduledTime: nil)
        ]
        yesterdayData.rrButtonStruck = true
        yesterdayData.workoutButtonStruck = true
        dayDataStore[yesterdayKey] = yesterdayData
        
        // Tomorrow's data (empty initially)
        let tomorrowKey = dateKey(for: .tomorrow)
        var tomorrowData = DayData()
        tomorrowData.notes = [
            Note(title: "Tomorrow's Planning", content: "Prepare for the upcoming client presentation and team meeting.")
        ]
        tomorrowData.tasks = [
            Task(title: "Team meeting", content: "Weekly standup at 9 AM", isCompleted: false, scheduledTime: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: DatePage.tomorrow.date()))
        ]
        dayDataStore[tomorrowKey] = tomorrowData
    }
    
    private func dateKey(for page: DatePage) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: page.date())
    }
    
    // Public method to get date key for any date
    func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // Public method to get day data for any date
    func dayData(for date: Date) -> DayData {
        let key = dateKey(for: date)
        return dayDataStore[key] ?? DayData()
    }
    
    private func getCurrentDayData() -> DayData {
        let key = dateKey(for: currentPage)
        return dayDataStore[key] ?? DayData()
    }
    
    private func setCurrentDayData(_ data: DayData) {
        let key = dateKey(for: currentPage)
        dayDataStore[key] = data
    }
    
    // MARK: - Public Properties
    var notes: [Note] {
        getCurrentDayData().notes
    }
    
    var tasks: [Task] {
        getCurrentDayData().tasks
    }
    
    var rrButtonStruck: Bool {
        get { getCurrentDayData().rrButtonStruck }
        set {
            var data = getCurrentDayData()
            data.rrButtonStruck = newValue
            setCurrentDayData(data)
        }
    }
    
    var workoutButtonStruck: Bool {
        get { getCurrentDayData().workoutButtonStruck }
        set {
            var data = getCurrentDayData()
            data.workoutButtonStruck = newValue
            setCurrentDayData(data)
        }
    }
    
    // MARK: - Public Methods
    func addNote(title: String, content: String) {
        var data = getCurrentDayData()
        let newNote = Note(title: title, content: content)
        data.notes.insert(newNote, at: 0)
        setCurrentDayData(data)
    }
    
    func addTask(title: String, content: String, scheduledTime: Date? = nil) {
        var data = getCurrentDayData()
        let newTask = Task(title: title, content: content, scheduledTime: scheduledTime)
        data.tasks.insert(newTask, at: 0)
        setCurrentDayData(data)
    }
    
    func toggleTask(_ task: Task) {
        var data = getCurrentDayData()
        if let index = data.tasks.firstIndex(where: { $0.id == task.id }) {
            data.tasks[index].isCompleted.toggle()
            setCurrentDayData(data)
        }
    }
    
    func deleteNote(_ note: Note) {
        var data = getCurrentDayData()
        data.notes.removeAll { $0.id == note.id }
        setCurrentDayData(data)
    }
    
    func deleteTask(_ task: Task) {
        var data = getCurrentDayData()
        data.tasks.removeAll { $0.id == task.id }
        setCurrentDayData(data)
    }
    
    func switchToPage(_ page: DatePage) {
        // Only update if it's actually a different page to avoid unnecessary updates
        if currentPage != page {
            currentPage = page
        }
    }
    
    func getCurrentDate() -> Date {
        currentPage.date()
    }
    
    func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: getCurrentDate())
    }
} 