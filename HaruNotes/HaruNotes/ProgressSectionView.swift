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
                    withAnimation {
                        store.rrButtonStruck.toggle()
                    }
                }) {
                    Text("+20rr")
                        .font(.headline)
                        .foregroundColor(store.rrButtonStruck ? .black : .white)
                        .strikethrough(store.rrButtonStruck)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(
                            store.rrButtonStruck ? Color.yellow : Color.clear,
                            in: RoundedRectangle(cornerRadius: 12)
                        )
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                
                // worked out button
                Button(action: {
                    withAnimation {
                        store.workoutButtonStruck.toggle()
                    }
                }) {
                    Text("worked out")
                        .font(.headline)
                        .foregroundColor(.white)
                        .strikethrough(store.workoutButtonStruck)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(
                            store.workoutButtonStruck ? Color.blue : Color.clear,
                            in: RoundedRectangle(cornerRadius: 12)
                        )
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        )
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