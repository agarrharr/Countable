import ComposableArchitecture
import SwiftUI

@Reducer
struct CounterFeature {
    @ObservableState
    struct State {
        var score: Int
    }
    
    enum Action {
        case buttonTapped(Int)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .buttonTapped(amount):
                state.score += amount
                return .none
            }
        }
    }
}


struct CounterView: View {
    var store: StoreOf<CounterFeature>
    
    var body: some View {
        VStack {
            Text("\(store.score)")
            
            HStack {
                VStack {
                    Button("-1") {
                        store.send(.buttonTapped(-1))
                    }
                    Button("-5") {
                        store.send(.buttonTapped(-5))
                    }
                }
                VStack {
                    Button("+1") {
                        store.send(.buttonTapped(1))
                    }
                    Button("+5") {
                        store.send(.buttonTapped(5))
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    CounterView(store: Store(initialState: CounterFeature.State(score: 20)) {
        CounterFeature()
    })
}
