import ComposableArchitecture
import SwiftUI

@main
struct GameCounterApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


struct ContentView: View {
    var body: some View {
        VStack {
            CounterView(store: Store(initialState: CounterFeature.State(score: 20)) {
                CounterFeature()
            })
                .rotationEffect(.degrees(-180))
            CounterView(store: Store(initialState: CounterFeature.State(score: 20)) {
                CounterFeature()
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
