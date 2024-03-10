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

struct CounterView: View {
    var colorMode: ColorMode
    var store: StoreOf<CounterFeature>
    
    private var primaryColor: Color {
        switch colorMode {
        case .light:
            .black
        case .dark:
            .white
        }
    }
    
    private var secondaryColor: Color {
        switch colorMode {
        case .light:
            .white
        case .dark:
            .black
        }
    }
    
    var body: some View {
        VStack {
            Text("\(store.score)")
                .padding(40)
                .font(.system(size: 150))
                .minimumScaleFactor(0.01)
                .foregroundStyle(primaryColor)

            Spacer()
                .frame(height: 20)

            HStack {
                Spacer()
                VStack {
                    Button {
                        store.send(.buttonTapped(-1))
                    } label: {
                        Text("-1")
                            .padding()
                            .foregroundColor(secondaryColor)
                            .background(primaryColor)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Button {
                        store.send(.buttonTapped(-5))
                    } label: {
                        Text("-5")
                            .padding()
                            .foregroundColor(secondaryColor)
                            .background(primaryColor)
                            .clipShape(Circle())
                    }
                }
                Spacer()
                VStack {
                    Button {
                        store.send(.buttonTapped(1))
                    } label: {
                        Text("+1")
                            .padding()
                            .foregroundColor(secondaryColor)
                            .background(primaryColor)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Button {
                        store.send(.buttonTapped(5))
                    } label: {
                        Text("+5")
                            .padding()
                            .foregroundColor(secondaryColor)
                            .background(primaryColor)
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    CounterView(
        colorMode: .light,
        store: Store(initialState: CounterFeature.State(score: Shared(100))) {
            CounterFeature()
        }
    )
}
