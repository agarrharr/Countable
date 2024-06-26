import ComposableArchitecture
import UIKit
#if canImport(WidgetKit)
import WidgetKit
#endif

@Reducer
public struct CounterFeature {
    @ObservableState
    public struct State {
        @Shared var score: Int
        
        public init(score: Shared<Int>) {
          self._score = score
        }
    }
    
    public enum Action {
        case buttonTapped(Int)
        case delegate(Delegate)
        
        @CasePathable
        public enum Delegate {
            case onButtonTapped
        }
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
            case let .buttonTapped(amount):
                state.score += amount
                return .run { send in
                    await send(.delegate(.onButtonTapped))

                    #if !os(visionOS)
                    let impactFeedback = await UIImpactFeedbackGenerator(style: .medium)
                    await impactFeedback.impactOccurred()
                    #endif

                    #if canImport(WidgetKit)
                    WidgetCenter.shared.reloadTimelines(ofKind: "com.garrett-harris.adam.game-counter-app.singleplayerwidget")
                    #endif
                }
            }
        }
    }
    
    public init() {}
}
