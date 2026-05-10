//
//  View+Extensions.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import SwiftUI

extension View {
    func cardStyle(
        cornerRadius: CGFloat = Constants.UI.cornerRadius,
        padding: CGFloat = Constants.UI.cardPadding
    ) -> some View {
        self
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(cornerRadius)
    }

    func pressableStyle(isPressed: Bool) -> some View {
        self
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: Constants.Animation.springResponse, dampingFraction: Constants.Animation.springDamping), value: isPressed)
    }

    func shimmerEffect(isActive: Bool) -> some View {
        self.modifier(ShimmerModifier(isActive: isActive))
    }

    func fadeInAnimation(delay: Double = 0) -> some View {
        self.modifier(FadeInModifier(delay: delay))
    }

    func slideInAnimation(from edge: Edge = .trailing, delay: Double = 0) -> some View {
        self.modifier(SlideInModifier(edge: edge, delay: delay))
    }
}

struct ShimmerModifier: ViewModifier {
    let isActive: Bool
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        if isActive {
            content
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(0.3),
                            Color.clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .rotationEffect(.degrees(30))
                    .offset(x: phase)
                )
                .mask(content)
                .onAppear {
                    withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        phase = 400
                    }
                }
        } else {
            content
        }
    }
}

struct FadeInModifier: ViewModifier {
    let delay: Double
    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .onAppear {
                withAnimation(.easeIn(duration: Constants.Animation.defaultDuration).delay(delay)) {
                    isVisible = true
                }
            }
    }
}

struct SlideInModifier: ViewModifier {
    let edge: Edge
    let delay: Double
    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(x: offsetX, y: offsetY)
            .onAppear {
                withAnimation(.spring(response: Constants.Animation.springResponse, dampingFraction: Constants.Animation.springDamping).delay(delay)) {
                    isVisible = true
                }
            }
    }

    private var offsetX: CGFloat {
        if !isVisible {
            switch edge {
            case .leading: return -50
            case .trailing: return 50
            default: return 0
            }
        }
        return 0
    }

    private var offsetY: CGFloat {
        if !isVisible {
            switch edge {
            case .top: return -50
            case .bottom: return 50
            default: return 0
            }
        }
        return 0
    }
}

struct BounceAnimation: ViewModifier {
    @State private var animate = false
    let duration: Double

    func body(content: Content) -> some View {
        content
            .scaleEffect(animate ? 1.05 : 1.0)
            .animation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true),
                value: animate
            )
            .onAppear {
                animate = true
            }
    }
}

extension View {
    func bounceAnimation(duration: Double = 0.6) -> some View {
        self.modifier(BounceAnimation(duration: duration))
    }
}
