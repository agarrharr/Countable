import ComposableArchitecture
import SwiftUI

import AppFeature

extension UserDefaults {
    static var shared: UserDefaults {
        return UserDefaults(suiteName: "group.com.garrett-harris.adam")!
    }
}

@main
struct CountableVisionOSApp: App {
    let store: StoreOf<AppFeature> = Store(initialState: AppFeature.State()) {
        AppFeature()._printChanges()
    } withDependencies: {
        $0.defaultAppStorage = UserDefaults.shared
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
        .defaultSize(width: 400, height: 600)
    }
}
