//
//  ProgressSectionView.swift
//  HaruNotes
//
//  Created by Ari Gladstone on 5/31/25.
//

import SwiftUI

struct ProgressSectionView: View {
    @EnvironmentObject var store: DataStore
    @State private var isVisible = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Elegant section header
            HStack(spacing: 12) {
                // Glowing progress icon
                ZStack {
                    Circle()
                        .fill(.mint.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Text("🌱")
                        .font(.title3)
                }
                .scaleEffect(isVisible ? 1.0 : 0.8)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: isVisible)
                
                Text("Daily Progress")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .mint.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .opacity(isVisible ? 1 : 0)
                    .offset(x: isVisible ? 0 : -20)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: isVisible)
                
                Spacer()
            }
            
            // Enhanced progress buttons
            HStack(spacing: 16) {
                // +20rr button with enhanced styling
                ProgressButton(
                    title: "+20rr",
                    isCompleted: store.rrButtonStruck,
                    accentColor: .yellow,
                    completedColor: .yellow,
                    icon: "gamecontroller",
                    action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            store.rrButtonStruck.toggle()
                        }
                    }
                )
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 30)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: isVisible)
                
                // Work out button with enhanced styling
                ProgressButton(
                    title: "Work out",
                    isCompleted: store.workoutButtonStruck,
                    accentColor: .blue,
                    completedColor: .cyan,
                    icon: "dumbbell",
                    action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            store.workoutButtonStruck.toggle()
                        }
                    }
                )
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 30)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: isVisible)
            }
            
            // Progress indicator
            if store.rrButtonStruck || store.workoutButtonStruck {
                VStack(spacing: 8) {
                    HStack {
                        Text("Today's Progress")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text("\(progressPercentage)%")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.mint)
                    }
                    
                    ProgressView(value: Double(progressPercentage) / 100.0)
                        .progressViewStyle(GlassyProgressViewStyle())
                }
                .padding(.top, 8)
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 20)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: isVisible)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                isVisible = true
            }
        }
    }
    
    private var progressPercentage: Int {
        let completed = (store.rrButtonStruck ? 1 : 0) + (store.workoutButtonStruck ? 1 : 0)
        return Int((Double(completed) / 2.0) * 100)
    }
}

struct ProgressButton: View {
    let title: String
    let isCompleted: Bool
    let accentColor: Color
    let completedColor: Color
    let icon: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                // Icon with enhanced styling
                ZStack {
                    Circle()
                        .fill(isCompleted ? completedColor.opacity(0.3) : accentColor.opacity(0.2))
                        .frame(width: 28, height: 28)
                    
                    if isCompleted {
                        // Show both original icon and checkmark when completed
                        ZStack {
                            Image(systemName: icon)
                                .foregroundColor(completedColor.opacity(0.7))
                                .font(.caption)
                                .fontWeight(.semibold)
                            
                            Image(systemName: "checkmark")
                                .foregroundColor(completedColor)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .offset(x: 8, y: -8)
                                .background(
                                    Circle()
                                        .fill(.black.opacity(0.3))
                                        .frame(width: 12, height: 12)
                                )
                        }
                    } else {
                        Image(systemName: icon)
                            .foregroundColor(accentColor)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                }
                .scaleEffect(isPressed ? 1.1 : 1.0)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(isCompleted ? .black : .white)
                    .strikethrough(isCompleted)
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isCompleted ? 
                          LinearGradient(colors: [completedColor, completedColor.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing) :
                          LinearGradient(colors: [Color.clear, Color.clear], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: isCompleted ? 
                                        [completedColor.opacity(0.8), completedColor.opacity(0.4)] :
                                        [accentColor.opacity(0.4), accentColor.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: isCompleted ? completedColor.opacity(0.3) : .black.opacity(0.2), radius: isCompleted ? 12 : 8, x: 0, y: isCompleted ? 6 : 4)
            )
            .scaleEffect(isCompleted ? 0.98 : (isPressed ? 0.96 : 1.0))
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isCompleted)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
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
            action()
        }
    }
}

struct GlassyProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
                    .frame(height: 8)
                
                // Progress fill
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [.mint, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0),
                        height: 8
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.mint.opacity(0.4), lineWidth: 1)
                    )
                    .shadow(color: .mint.opacity(0.5), radius: 4, x: 0, y: 2)
            }
        }
        .frame(height: 8)
    }
} 