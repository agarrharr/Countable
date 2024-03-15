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

        @Shared var player1Score: Int
        @Shared var player2Score: Int
        @Shared(.appStorage("startingScore")) var startingScore: String = "0"
        
        var player1Counter: CounterFeature.State
        var player2Counter: CounterFeature.State

        var startingScoreInt: Int {
            Int(startingScore) ?? 0
        }
        
        init(player1Score: Int = 1, player2Score: Int = 1) {
            self.destination = nil
            self._player1Score = Shared(wrappedValue: player1Score, .appStorage("player1Score"))
            self._player2Score = Shared(wrappedValue: player2Score, .appStorage("player2Score"))
            self._player1Counter = CounterFeature.State(score: self._player1Score)
            self._player2Counter = CounterFeature.State(score: self._player2Score)
        }
    }
    
    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case player1Counter(CounterFeature.Action)
        case player2Counter(CounterFeature.Action)

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
                return .run { [score1 = state.player1Score, score2 = state.player2Score] _ in
                    let impactFeedback = await UIImpactFeedbackGenerator(style: .medium)
                    await impactFeedback.impactOccurred()
                    announcer.announce(score1: score1, score2: score2)
                }
            case .settingsButtonTapped:
                state.destination = .settings(SettingsFeature.State(startingScore: state.$startingScore))
                return .run { _ in
                    let impactFeedback = await UIImpactFeedbackGenerator(style: .medium)
                    await impactFeedback.impactOccurred()
                }
            case let .player1Counter(.delegate(action)),
            let .player2Counter(.delegate(action)):
                switch action {
                case .onButtonTapped:
                    return .run { [score1 = state.player1Score, score2 = state.player2Score] _ in
                        announcer.announce(score1: score1, score2: score2)
                    }
                }
            case .player1Counter:
                return .none
            case .player2Counter:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
        Scope(state: \.player1Counter, action: \.player1Counter) {
            CounterFeature()
        }
        Scope(state: \.player2Counter, action: \.player2Counter) {
            CounterFeature()
        }
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
                    store: store.scope(state: \.player2Counter, action: \.player2Counter)
                )
                .rotationEffect(.degrees(-180))
                
                Spacer()
                
                CounterView(
                    colorMode: .dark,
                    playerName: "Player 1",
                    buttonColor: Color("DarkBlue"),
                    store: store.scope(state: \.player1Counter, action: \.player1Counter)
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

var announcer = ScoreAnnouncer()

struct ScoreAnnouncer {
    var previousScore1: Int? = nil
    var previousScore2: Int? = nil

    mutating func announce(score1: Int, score2: Int) {
        var announcement = AttributedString("\(score1) to \(score2)")
        announcement.accessibilitySpeechAnnouncementPriority = .high
        AccessibilityNotification.Announcement(announcement).post()
    }
}

#Preview {
    ContentView(store: Store(
        initialState: AppFeature.State()) {
        AppFeature()
    })
}
