//
//  ProgressSectionView.swift
//  TrainingArc
//
//  Created by Ari Gladstone on 5/31/25.
//

import SwiftUI

struct ProgressSectionView: View {
    @EnvironmentObject var store: DataStore

    var body: some View {
        Section {
            HStack(spacing: 15) {
                // +20rr button
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.1)) {
                        store.rrButtonStruck.toggle()
                    }
                }) {
                    Text("+20rr")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(store.rrButtonStruck ? .black : .white)
                        .strikethrough(store.rrButtonStruck)
                        .scaleEffect(store.rrButtonStruck ? 0.95 : 1.0)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(
                            store.rrButtonStruck ? Color.yellow : Color.clear,
                            in: RoundedRectangle(cornerRadius: 12)
                        )
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.yellow.opacity(store.rrButtonStruck ? 0.8 : 0.3), lineWidth: store.rrButtonStruck ? 2 : 1)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: store.rrButtonStruck)
                        )
                        .shadow(color: store.rrButtonStruck ? .yellow.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.1), value: store.rrButtonStruck)
                }
                .buttonStyle(PlainButtonStyle())
                
                // worked out button
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.1)) {
                        store.workoutButtonStruck.toggle()
                    }
                }) {
                    Text("worked out")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(store.workoutButtonStruck ? .white : .white)
                        .strikethrough(store.workoutButtonStruck)
                        .scaleEffect(store.workoutButtonStruck ? 0.95 : 1.0)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(
                            store.workoutButtonStruck ? Color.blue : Color.clear,
                            in: RoundedRectangle(cornerRadius: 12)
                        )
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue.opacity(store.workoutButtonStruck ? 0.8 : 0.3), lineWidth: store.workoutButtonStruck ? 2 : 1)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: store.workoutButtonStruck)
                        )
                        .shadow(color: store.workoutButtonStruck ? .blue.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.1), value: store.workoutButtonStruck)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.vertical, 8)
            .listRowBackground(Color.black)
        } header: {
            HStack {
                Text("🌱 Progress")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
} 