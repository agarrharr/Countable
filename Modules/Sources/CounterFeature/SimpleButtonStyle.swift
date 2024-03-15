import SwiftUI

struct SimpleButtonStyle: ButtonStyle {
    let buttonColor: Color

    init(buttonColor: Color) {
        self.buttonColor = buttonColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                Group {
                    if configuration.isPressed {
                        Circle()
                            .fill(buttonColor)
                            .overlay(
                                Circle()
                                    .stroke(.black.opacity(0.2), lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: 2, y: 2)
                                    .mask(Circle().fill(LinearGradient(.black, .clear)))
                            )
                            .overlay(
                                Circle()
                                    .stroke(.white.opacity(0.2), lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: -1, y: -1)
                                    .mask(Circle().fill(LinearGradient(.clear, .black)))
                            )
                    } else {
                        Circle()
                            .fill(buttonColor)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 4, y: 4)
                            .shadow(color: .white.opacity(0.2), radius: 5, x: 0, y: -1)
                    }
                }
            )
    }
}
