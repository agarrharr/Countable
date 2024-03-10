import ComposableArchitecture
import SwiftUI

@main
struct GameCounterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: AppFeature.State()) {
                AppFeature()
            })
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

@Reducer
struct AppFeature {
    @ObservableState
    struct State {
        @Shared(.appStorage("player1Score")) var player1Score: Int = 0
        @Shared(.appStorage("player2Score")) var player2Score: Int = 0
    }
}


struct ContentView: View {
    var store: StoreOf<AppFeature>
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            VStack {
                CounterView(
                    colorMode: .light,
                    store: Store(initialState: CounterFeature.State(score: store.$player2Score)) {
                        CounterFeature()
                    }
                )
                .rotationEffect(.degrees(-180))
                
                CounterView(
                    colorMode: .dark,
                    store: Store(initialState: CounterFeature.State(score: store.$player1Score)) {
                        CounterFeature()
                    }
                )
                
                HStack {
                    Button {
                        //store.send()
                    } label: {
                        Image(systemName: "arrow.circlepath")
                            //.padding()
                            .foregroundColor(.white)
                            //.background(.white)
                            //.clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button {
                        //store.send()
                    } label: {
                        Image(systemName: "gear")
                        //.padding()
                        .foregroundColor(.white)
                        //.background(.white)
                        //.clipShape(Circle())
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}
