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

struct GradientBackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color("LightBlue"), Color("DarkBlue")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}


struct ContentView: View {
    var body: some View {
        ZStack {
            GradientBackgroundView()
            VStack {
                CounterView(
                    colorMode: .light,
                    store: Store(initialState: CounterFeature.State(score: 20)) {
                        CounterFeature()
                    }
                )
                .rotationEffect(.degrees(-180))
                
                CounterView(
                    colorMode: .dark,
                    store: Store(initialState: CounterFeature.State(score: 20)) {
                        CounterFeature()
                    }
                )
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
