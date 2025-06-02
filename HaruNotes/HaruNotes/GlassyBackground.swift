import SwiftUI

// MARK: - Color Schemes for Different Pages
struct PageColorScheme {
    static func colors(for page: DatePage) -> [Color] {
        switch page {
        case .yesterday:
            return [.orange, .red, .blue, .indigo]
        case .today:
            return [.blue, .cyan, .green, .teal]
        case .tomorrow:
            return [.pink, .red, .orange, .yellow]
        }
    }
    
    static func calendarColors() -> [Color] {
        return [.cyan, .blue, .purple, .indigo]
    }
}

// MARK: - Glassy Background Components
struct GlassyBackground: View {
    let colors: [Color]
    let intensity: Double
    @State private var animateGradient = false
    @State private var colorPhase: Double = 0
    
    init(colors: [Color] = [.purple, .blue, .cyan, .teal], intensity: Double = 0.6) {
        self.colors = colors
        self.intensity = intensity
    }
    
    // Convenience initializer for pages
    init(page: DatePage, intensity: Double = 0.6) {
        self.colors = PageColorScheme.colors(for: page)
        self.intensity = intensity
    }
    
    // Convenience initializer for calendar
    init(forCalendar: Bool, intensity: Double = 0.6) {
        self.colors = PageColorScheme.calendarColors()
        self.intensity = intensity
    }
    
    var body: some View {
        ZStack {
            // Pure black background
            Color.black
                .ignoresSafeArea()
            
            // Simple ambient shifting gradient
            AmbientGradientBackground(colors: colors, intensity: intensity, animateGradient: animateGradient, colorPhase: colorPhase)
                .onAppear {
                    // Slow gradient position animation
                    withAnimation(.easeInOut(duration: 20).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                    
                    // Slow color shifting animation
                    withAnimation(.easeInOut(duration: 25).repeatForever(autoreverses: true)) {
                        colorPhase = 1.0
                    }
                }
        }
    }
}

struct AmbientGradientBackground: View {
    let colors: [Color]
    let intensity: Double
    let animateGradient: Bool
    let colorPhase: Double
    
    var body: some View {
        ZStack {
            // Primary shifting gradient
            RadialGradient(
                colors: [
                    interpolateColor(colors[0], colors[1], phase: colorPhase).opacity(intensity * 0.8),
                    interpolateColor(colors[1], colors[2], phase: colorPhase).opacity(intensity * 0.6),
                    interpolateColor(colors[2], colors[0], phase: colorPhase).opacity(intensity * 0.4),
                    Color.clear
                ],
                center: animateGradient ? .topLeading : .bottomTrailing,
                startRadius: 100,
                endRadius: 800
            )
            
            // Secondary gradient for depth
            RadialGradient(
                colors: [
                    interpolateColor(colors[2], colors[3], phase: colorPhase).opacity(intensity * 0.5),
                    interpolateColor(colors[3], colors[1], phase: colorPhase).opacity(intensity * 0.3),
                    Color.clear
                ],
                center: animateGradient ? .bottomTrailing : .topLeading,
                startRadius: 150,
                endRadius: 600
            )
            
            // Subtle overlay gradient
            LinearGradient(
                colors: [
                    interpolateColor(colors[1], colors[3], phase: colorPhase).opacity(intensity * 0.3),
                    Color.clear,
                    interpolateColor(colors[0], colors[2], phase: colorPhase).opacity(intensity * 0.2)
                ],
                startPoint: animateGradient ? .topTrailing : .bottomLeading,
                endPoint: animateGradient ? .bottomLeading : .topTrailing
            )
        }
        .ignoresSafeArea()
    }
    
    // Helper function to interpolate between colors
    private func interpolateColor(_ color1: Color, _ color2: Color, phase: Double) -> Color {
        // Simple color interpolation - in a real app you'd want more sophisticated color mixing
        let t = (sin(phase * .pi * 2) + 1) / 2 // Convert to 0-1 range
        return Color(
            red: Double(color1.components.red * (1 - t) + color2.components.red * t),
            green: Double(color1.components.green * (1 - t) + color2.components.green * t),
            blue: Double(color1.components.blue * (1 - t) + color2.components.blue * t)
        )
    }
}

// Extension to get color components (simplified)
extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
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