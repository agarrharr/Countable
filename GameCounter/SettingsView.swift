import ComposableArchitecture
import SwiftUI

@Reducer
struct SettingsFeature {
    @ObservableState
    struct State: Equatable {
        @Shared var startingScore: String
    }
    
    enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
    }
}

struct SettingsView: View {
   @Bindable var store: StoreOf<SettingsFeature>
    
    // Why am I initially hiding the list?
    // It's because of a bug with SwiftUI
    // I want to have a large title, but if
    // there is a list, it shrinks down
    // So I wait a split second to show the list
    // https://developer.apple.com/forums/thread/737787
    @State private var showList: Bool = false
    @FocusState var isInputActive: Bool
    
    @Environment(\.sizeCategory) var sizeCategory
    
    public var body: some View {
        NavigationStack {
            VStack {
                if showList {
                    List {
                        Section {
                            HStack {
                                Image(systemName: "play.fill")
                                    .padding(4)
                                    .background(.blue)
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: self.cornerRadius))
                                LabeledContent {
                                    TextField("Starting Score", text: $store.startingScore)
                                        .multilineTextAlignment(.trailing)
                                        .keyboardType(.numberPad)
                                        .focused($isInputActive)
                                        .toolbar {
                                            ToolbarItemGroup(placement: .keyboard) {
                                                Spacer()
                                                
                                                Button("Done") {
                                                    isInputActive = false
                                                }
                                            }
                                        }
                                } label: {
                                  Text("Starting Score")
                                }
                            }
                            .onTapGesture {
                                isInputActive = true
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showList = true
            }
        }
    }
    
    var cornerRadius: CGFloat {
        switch sizeCategory {
        case .extraSmall, .small: 4
        case .medium: 6
        default: 8
        }
    }
}

#Preview {
    SettingsView(store: Store(initialState: SettingsFeature.State(startingScore: Shared("0"))) {
        SettingsFeature()
    })
}
