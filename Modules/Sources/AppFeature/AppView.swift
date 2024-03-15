import ComposableArchitecture
import SwiftUI

import CounterFeature
import SettingsFeature

public struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    public init(store: StoreOf<AppFeature>) {
        self.store = store
    }
    
    public var body: some View {
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

#Preview {
    AppView(store: Store(
        initialState: AppFeature.State()) {
        AppFeature()
    })
}
