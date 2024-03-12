import ComposableArchitecture
import SwiftUI

@main
struct GameCounterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: AppFeature.State()) {
                AppFeature()._printChanges()
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
    @Reducer
    enum Destination {
        case settings(SettingsFeature)
    }
    
    @ObservableState
    struct State {
        @Presents var destination: Destination.State?

        @Shared(.appStorage("player1Score")) var player1Score: Int = 0
        @Shared(.appStorage("player2Score")) var player2Score: Int = 0
        @Shared(.appStorage("startingScore")) var startingScore: String = "0"
        
        var startingScoreInt: Int {
            Int(startingScore) ?? 0
        }
    }
    
    enum Action {
        case destination(PresentationAction<Destination.Action>)

        case resetButtonTapped
        case settingsButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .destination:
                return .none
            case .resetButtonTapped:
                state.player1Score = state.startingScoreInt
                state.player2Score = state.startingScoreInt
                return .run { _ in
                    let impactFeedback = await UIImpactFeedbackGenerator(style: .medium)
                    await impactFeedback.impactOccurred()
                }
            case .settingsButtonTapped:
                state.destination = .settings(SettingsFeature.State(startingScore: state.$startingScore))
                return .run { _ in
                    let impactFeedback = await UIImpactFeedbackGenerator(style: .medium)
                    await impactFeedback.impactOccurred()
                }
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}


struct ContentView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        ZStack {
            GradientBackgroundView()
            VStack {
                CounterView(
                    colorMode: .light,
                    buttonColor: Color("LightBlue"),
                    store: Store(initialState: CounterFeature.State(score: store.$player2Score)) {
                        CounterFeature()
                    }
                )
                .rotationEffect(.degrees(-180))
                
                CounterView(
                    colorMode: .dark,
                    buttonColor: Color("DarkBlue"),
                    store: Store(initialState: CounterFeature.State(score: store.$player1Score)) {
                        CounterFeature()
                    }
                )
                
                HStack {
                    Button {
                        store.send(.resetButtonTapped)
                    } label: {
                        Image(systemName: "arrow.circlepath")
                            .foregroundColor(.white)
                            .imageScale(.large)
                            .accessibilityLabel("Reset")
                    }
                    
                    Spacer()
                    
                    Button {
                        store.send(.settingsButtonTapped)
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(.white)
                            .imageScale(.large)
                            .accessibilityLabel("Settings")
                    }
                }
            }
            .padding()
            .sheet(
                item: $store.scope(
                    state: \.destination?.settings,
                    action: \.destination.settings
                )
            ) { store in
                SettingsView(store: store)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    ContentView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}
