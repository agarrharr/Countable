import ComposableArchitecture
import UIKit
import WidgetKit

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
                    let impactFeedback = await UIImpactFeedbackGenerator(style: .medium)
                    await impactFeedback.impactOccurred()
                    WidgetCenter.shared.reloadTimelines(ofKind: "com.garrett-harris.adam.game-counter-app.singleplayerwidget")
                    await send(.delegate(.onButtonTapped))
                }
            }
        }
    }
    
    public init() {}
}
