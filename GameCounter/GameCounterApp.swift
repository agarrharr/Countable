import ComposableArchitecture
import SwiftUI

@main
struct GameCounterApp: App {
    var body: some Scene {
        WindowGroup {
            let store: StoreOf<AppFeature> = Store(initialState: AppFeature.State()) {
                AppFeature()._printChanges()
            } withDependencies: {
                $0.defaultAppStorage = UserDefaults(suiteName: "group.com.garrett-harris.adam")!
            }
            
            ContentView(store: store)
            .onAppear {
                // Keep the screen on
                UIApplication.shared.isIdleTimerDisabled = true
            }
        }
    }
}
