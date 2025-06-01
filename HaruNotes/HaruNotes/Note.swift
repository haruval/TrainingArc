import SwiftUI
import Foundation

struct Note: Identifiable, Codable {
    let id = UUID()
    let title: String
    let content: String
    let dateCreated = Date()
}

struct Task: Identifiable, Codable {
    let id = UUID()
    let title: String
    let content: String
    let dateCreated = Date()
    var isCompleted: Bool = false
    var scheduledTime: Date? = nil
} 