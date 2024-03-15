import ComposableArchitecture
import SwiftUI

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
                    playerName: "Player 2",
                    buttonColor: Color("LightBlue"),
                    store: Store(initialState: CounterFeature.State(score: store.$player2Score)) {
                        CounterFeature()
                    }
                )
                .rotationEffect(.degrees(-180))
                
                Spacer()
                
                CounterView(
                    colorMode: .dark,
                    playerName: "Player 1",
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
        .onChange(of: store.player1Score) { _, _ in
            announcer.announce(score1: store.player1Score, score2: store.player2Score)
        }
        .onChange(of: store.player2Score) { _, _ in
            announcer.announce(score1: store.player1Score, score2: store.player2Score)
        }
    }
}

var announcer = ScoreAnnouncer()

struct ScoreAnnouncer {
    var previousScore1: Int? = nil
    var previousScore2: Int? = nil

    mutating func announce(score1: Int, score2: Int) {
        // Don't announce it if it's the same as last time
        // because when the score is reset, both scores change
        // and can end up calling this function twice in a row
        if previousScore1 != score1 || previousScore2 != score2 {
            previousScore1 = score1
            previousScore2 = score2
            var announcement = AttributedString("\(score1) to \(score2)")
            announcement.accessibilitySpeechAnnouncementPriority = .high
            AccessibilityNotification.Announcement(announcement).post()
        }
    }
}

#Preview {
    ContentView(store: Store(initialState: AppFeature.State()) {
        AppFeature()
    })
}
