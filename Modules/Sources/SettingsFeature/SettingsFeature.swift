import ComposableArchitecture

@Reducer
public struct SettingsFeature {
    @ObservableState
    public struct State: Equatable {
        @Shared var startingScore: String
        
        public init(startingScore: Shared<String>) {
            self._startingScore = startingScore
        }
    }
    
    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
    }
    
    public init() {}
}
