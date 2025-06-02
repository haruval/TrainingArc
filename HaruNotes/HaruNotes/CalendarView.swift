//
//  CalendarView.swift
//  TrainingArc
//
//  Created by Ari Gladstone on 5/31/25.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    @State private var currentDate = Date()
    @State private var isVisible = false
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Beautiful calendar-specific glassy background
                GlassyBackground(forCalendar: true, intensity: 0.5)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Elegant header with calendar icon
                        VStack(spacing: 16) {
                            HStack {
                                // Calendar icon with glow
                                ZStack {
                                    Circle()
                                        .fill(.cyan.opacity(0.3))
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: "calendar")
                                        .foregroundColor(.cyan)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }
                                .scaleEffect(isVisible ? 1.0 : 0.8)
                                .opacity(isVisible ? 1.0 : 0.0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: isVisible)
                                
                                Spacer()
                                
                                // Close button with glassy styling
                                Button(action: {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                        dismiss()
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .frame(width: 32, height: 32)
                                        .background(.ultraThinMaterial, in: Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(.white.opacity(0.3), lineWidth: 1)
                                        )
                                }
                                .opacity(isVisible ? 1.0 : 0.0)
                                .offset(x: isVisible ? 0 : 20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: isVisible)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                        }
                        
                        // Month navigation in glassy card
                        GlassyCard(cornerRadius: 20) {
                            HStack {
                                Button(action: previousMonth) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .frame(width: 44, height: 44)
                                        .background(.ultraThinMaterial, in: Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(.white.opacity(0.2), lineWidth: 1)
                                        )
                                }
                                
                                Spacer()
                                
                                Text(dateFormatter.string(from: currentDate))
                                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.white, .cyan.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Spacer()
                                
                                Button(action: nextMonth) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .frame(width: 44, height: 44)
                                        .background(.ultraThinMaterial, in: Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(.white.opacity(0.2), lineWidth: 1)
                                        )
                                }
                            }
                            .padding(20)
                        }
                        .padding(.horizontal, 20)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 30)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: isVisible)
                        
                        // Calendar content in glassy card
                        GlassyCard(cornerRadius: 20) {
                            VStack(spacing: 20) {
                                // Weekday headers
                                HStack {
                                    ForEach(weekdaySymbols, id: \.self) { weekday in
                                        Text(weekday)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.gray)
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                
                                // Calendar grid
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                                    ForEach(daysInMonth, id: \.self) { date in
                                        if let date = date {
                                            CalendarDayView(date: date, store: store)
                                        } else {
                                            // Empty cell for days not in current month
                                            Rectangle()
                                                .fill(Color.clear)
                                                .frame(height: 50)
                                        }
                                    }
                                }
                            }
                            .padding(24)
                        }
                        .padding(.horizontal, 20)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 30)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: isVisible)
                        
                        // Simple legend at bottom - just dots and labels
                        HStack(spacing: 24) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(.yellow)
                                    .frame(width: 12, height: 12)
                                    .overlay(
                                        Circle()
                                            .stroke(.white.opacity(0.3), lineWidth: 1)
                                    )
                                Text("+20rr")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 12, height: 12)
                                    .overlay(
                                        Circle()
                                            .stroke(.white.opacity(0.3), lineWidth: 1)
                                    )
                                Text("Work out")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 20)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: isVisible)
                        
                        // Bottom spacing
                        Spacer()
                            .frame(height: 50)
                    }
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
            .preferredColorScheme(.dark)
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    isVisible = true
                }
            }
        }
    }
    
    private var weekdaySymbols: [String] {
        let symbols = calendar.shortWeekdaySymbols
        // Rearrange to start with Sunday (if needed based on locale)
        return symbols
    }
    
    private var daysInMonth: [Date?] {
        guard let monthRange = calendar.range(of: .day, in: .month, for: currentDate),
              let monthFirstDay = calendar.dateInterval(of: .month, for: currentDate)?.start else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: monthFirstDay)
        let numberOfDaysInMonth = monthRange.count
        
        var days: [Date?] = []
        
        // Add empty cells for days before the first day of the month
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        // Add all days in the month
        for day in 1...numberOfDaysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthFirstDay) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func previousMonth() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
        }
    }
    
    private func nextMonth() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let store: DataStore
    @State private var isPressed = false
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private var dayData: DayData {
        return store.dayData(for: date)
    }
    
    private var isToday: Bool {
        Calendar.current.isDate(date, inSameDayAs: Date())
    }
    
    var body: some View {
        VStack(spacing: 6) {
            Text(dayFormatter.string(from: date))
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isToday ? .black : .white)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(isToday ? 
                             LinearGradient(colors: [.white, .cyan.opacity(0.8)], startPoint: .top, endPoint: .bottom) : 
                             LinearGradient(colors: [.clear, .clear], startPoint: .top, endPoint: .bottom))
                        .overlay(
                            Circle()
                                .stroke(isToday ? .clear : .white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: isToday ? .cyan.opacity(0.5) : .clear, radius: 8)
                )
                .scaleEffect(isPressed ? 1.1 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPressed)
            
            // Progress indicators with enhanced styling
            HStack(spacing: 3) {
                if dayData.rrButtonStruck {
                    Circle()
                        .fill(.yellow)
                        .frame(width: 8, height: 8)
                        .overlay(
                            Circle()
                                .stroke(.white.opacity(0.3), lineWidth: 0.5)
                        )
                        .shadow(color: .yellow.opacity(0.5), radius: 2)
                }
                
                if dayData.workoutButtonStruck {
                    Circle()
                        .fill(.blue)
                        .frame(width: 8, height: 8)
                        .overlay(
                            Circle()
                                .stroke(.white.opacity(0.3), lineWidth: 0.5)
                        )
                        .shadow(color: .blue.opacity(0.5), radius: 2)
                }
            }
            .frame(height: 10) // Reserve space even when no dots
        }
        .frame(height: 56)
        .contentShape(Rectangle())
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

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(DataStore())
    }
} 