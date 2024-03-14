import ComposableArchitecture
import SwiftUI

@Reducer
struct CounterFeature {
    @ObservableState
    struct State {
        @Shared var score: Int
    }
    
    enum Action {
        case buttonTapped(Int)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .buttonTapped(amount):
                state.score += amount
                return .run { _ in
                    let impactFeedback = await UIImpactFeedbackGenerator(style: .medium)
                    await impactFeedback.impactOccurred()
                }
            }
        }
    }
}

enum ColorMode {
    case light
    case dark
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

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

struct CounterView: View {
    var colorMode: ColorMode
    var buttonColor: Color
    var store: StoreOf<CounterFeature>
    
    private var primaryColor: Color {
        switch colorMode {
        case .light:
            .black
        case .dark:
            .white
        }
    }
    
    var body: some View {
        VStack {
            Text("\(store.score)")
                .padding(40)
                .font(Font.custom("Bitter-Regular", size: 150))
                .minimumScaleFactor(0.01)
                .foregroundStyle(primaryColor)

            Spacer()
                .frame(height: 10)

            HStack {
                Spacer()
                VStack {
                    Button {
                        store.send(.buttonTapped(-1))
                    } label: {
                        Text("-1")
                            .font(.title2)
                            .foregroundColor(primaryColor)
                    }
                    .buttonStyle(SimpleButtonStyle(buttonColor: buttonColor))
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Button {
                        store.send(.buttonTapped(-5))
                    } label: {
                        Text("-5")
                            .font(.title2)
                            .foregroundColor(primaryColor)
                    }
                    .buttonStyle(SimpleButtonStyle(buttonColor: buttonColor))
                }
                Spacer()
                VStack {
                    Button {
                        store.send(.buttonTapped(1))
                    } label: {
                        Text("+1")
                            .font(.title2)
                            .foregroundColor(primaryColor)
                    }
                    .buttonStyle(SimpleButtonStyle(buttonColor: buttonColor))

                    Spacer()
                        .frame(height: 20)
                    
                    Button {
                        store.send(.buttonTapped(5))
                    } label: {
                        Text("+5")
                            .font(.title2)
                            .foregroundColor(primaryColor)
                    }
                    .buttonStyle(SimpleButtonStyle(buttonColor: buttonColor))

                }
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    ZStack {
        Color.blue
        CounterView(
            colorMode: .light,
            buttonColor: .blue,
            store: Store(initialState: CounterFeature.State(score: Shared(10))) {
                CounterFeature()
            }
        )
    }
}