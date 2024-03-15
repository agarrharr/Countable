import ComposableArchitecture
import SwiftUI

public enum ColorMode {
    case light
    case dark
}

public struct CounterView: View {
    var colorMode: ColorMode
    var playerName: String
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
    
    public init(colorMode: ColorMode, playerName: String, buttonColor: Color, store: StoreOf<CounterFeature>) {
        self.colorMode = colorMode
        self.playerName = playerName
        self.buttonColor = buttonColor
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Text("\(store.score)")
                .padding()
                .font(Font.custom("Bitter-Regular", size: 90))
                .minimumScaleFactor(0.3)
                .foregroundStyle(primaryColor)
                .accessibilityLabel("\(playerName): \(store.score)")
            
            Spacer()

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
                    .accessibilityLabel("Subtract 1 from \(playerName)")
                    
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
                    .accessibilityLabel("Subtract 5 from \(playerName)")
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
                    .accessibilityLabel("Add 1 to \(playerName)")

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
                    .accessibilityLabel("Add 5 to \(playerName)")

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
            playerName: "Player 1",
            buttonColor: .blue,
            store: Store(initialState: CounterFeature.State(score: Shared(10))) {
                CounterFeature()
            }
        )
    }
}
