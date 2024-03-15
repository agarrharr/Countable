import ComposableArchitecture
import SwiftUI

import AppFeature

extension UserDefaults {
    static var shared: UserDefaults {
        return UserDefaults(suiteName: "group.com.garrett-harris.adam")!
    }
}

@main
struct GameCounterApp: App {
    var body: some Scene {
        WindowGroup {
            let store: StoreOf<AppFeature> = Store(initialState: AppFeature.State()) {
                AppFeature()._printChanges()
            } withDependencies: {
                $0.defaultAppStorage = UserDefaults.shared
            }
            
            AppView(store: store)
            .onAppear {
                // Keep the screen on
                UIApplication.shared.isIdleTimerDisabled = true
            }
        }
    }
}
