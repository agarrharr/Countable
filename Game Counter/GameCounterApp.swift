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
