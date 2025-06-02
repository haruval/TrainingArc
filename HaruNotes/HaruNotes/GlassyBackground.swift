import SwiftUI

// MARK: - Glassy Background Components
struct GlassyBackground: View {
    let colors: [Color]
    let intensity: Double
    @State private var animateGradient = false
    @State private var fadePhase: Double = 0
    
    init(colors: [Color] = [.purple, .blue, .cyan, .teal], intensity: Double = 0.4) {
        self.colors = colors
        self.intensity = intensity
    }
    
    var body: some View {
        ZStack {
            // Pure black background
            Color.black
                .ignoresSafeArea()
            
            // Simple but beautiful aurora-inspired background
            SimpleAuroraBackground(colors: colors, intensity: intensity, animateGradient: animateGradient, fadePhase: fadePhase)
                .onAppear {
                    // Continuous flowing animation for aurora movement
                    withAnimation(.easeInOut(duration: 15).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                    
                    // Continuous intensity pulsing for aurora brightness
                    withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                        fadePhase = 1.0
                    }
                }
        }
    }
}

struct SimpleAuroraBackground: View {
    let colors: [Color]
    let intensity: Double
    let animateGradient: Bool
    let fadePhase: Double
    
    var body: some View {
        ZStack {
            // Primary aurora flows
            ForEach(0..<4, id: \.self) { index in
                let color1 = colors[index % colors.count]
                let color2 = colors[(index + 1) % colors.count]
                
                SimpleAuroraFlow(
                    color1: color1,
                    color2: color2,
                    intensity: intensity,
                    index: index,
                    animateGradient: animateGradient,
                    fadePhase: fadePhase
                )
            }
            
            // Atmospheric glow
            SimpleAtmosphericGlow(colors: colors, intensity: intensity, fadePhase: fadePhase)
        }
        .blendMode(.screen)
        .ignoresSafeArea()
    }
}

struct SimpleAuroraFlow: View {
    let color1: Color
    let color2: Color
    let intensity: Double
    let index: Int
    let animateGradient: Bool
    let fadePhase: Double
    
    var body: some View {
        let positions: [UnitPoint] = [.topLeading, .topTrailing, .bottomLeading, .bottomTrailing]
        let position = positions[index]
        
        RadialGradient(
            colors: [
                color1.opacity(intensity * (0.8 + fadePhase * 0.6)),
                color2.opacity(intensity * (0.6 + fadePhase * 0.4)),
                color1.opacity(intensity * (0.3 + fadePhase * 0.2)),
                Color.clear
            ],
            center: position,
            startRadius: 50,
            endRadius: 400 + fadePhase * 200
        )
        .scaleEffect(animateGradient ? 1.3 : 0.8)
        .opacity(0.7 + fadePhase * 0.3)
        .offset(
            x: animateGradient ? CGFloat(index * 30 - 45) : CGFloat(index * -30 + 45),
            y: animateGradient ? CGFloat(index * 20 - 30) : CGFloat(index * -20 + 30)
        )
    }
}

struct SimpleAtmosphericGlow: View {
    let colors: [Color]
    let intensity: Double
    let fadePhase: Double
    
    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                let color = colors[index % colors.count]
                let positions: [UnitPoint] = [.center, .top, .bottom]
                let position = positions[index]
                
                RadialGradient(
                    colors: [
                        color.opacity(intensity * (0.4 + fadePhase * 0.3)),
                        color.opacity(intensity * (0.2 + fadePhase * 0.1)),
                        Color.clear
                    ],
                    center: position,
                    startRadius: 100,
                    endRadius: 350 + fadePhase * 100
                )
            }
        }
        .scaleEffect(0.9 + fadePhase * 0.2)
        .opacity(0.6 + fadePhase * 0.4)
    }
}

// MARK: - Glassy Card Component
struct GlassyCard<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat
    let strokeColor: Color
    let shadowRadius: CGFloat
    
    init(
        cornerRadius: CGFloat = 16,
        strokeColor: Color = .white.opacity(0.2),
        shadowRadius: CGFloat = 20,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.strokeColor = strokeColor
        self.shadowRadius = shadowRadius
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(strokeColor, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.3), radius: shadowRadius, x: 0, y: 10)
            )
    }
}

// MARK: - Floating Button Component
struct FloatingGlassyButton: View {
    let icon: String
    let accentColor: Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Circle()
                                .stroke(accentColor.opacity(0.4), lineWidth: 1.5)
                        )
                        .shadow(color: accentColor.opacity(0.3), radius: isPressed ? 5 : 15, x: 0, y: isPressed ? 2 : 8)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                )
        }
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

// MARK: - Page Transition View Modifier
struct PageTransition: ViewModifier {
    let isVisible: Bool
    
    func body(content: Content) -> some View {
        content
            .offset(y: isVisible ? 0 : 50)
            .opacity(isVisible ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0), value: isVisible)
    }
}

extension View {
    func pageTransition(isVisible: Bool) -> some View {
        modifier(PageTransition(isVisible: isVisible))
    }
}

// MARK: - Flowing Content Transition
struct FlowingTransition: ViewModifier {
    let direction: Edge
    let isVisible: Bool
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(
                x: direction == .leading ? (isVisible ? 0 : -100) : (direction == .trailing ? (isVisible ? 0 : 100) : 0),
                y: direction == .top ? (isVisible ? 0 : -100) : (direction == .bottom ? (isVisible ? 0 : 100) : 0)
            )
            .animation(.spring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.2), value: isVisible)
    }
}

extension View {
    func flowingTransition(from direction: Edge, isVisible: Bool) -> some View {
        modifier(FlowingTransition(direction: direction, isVisible: isVisible))
    }
} 