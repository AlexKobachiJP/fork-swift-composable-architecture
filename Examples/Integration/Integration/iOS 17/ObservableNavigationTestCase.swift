@_spi(Logging) import ComposableArchitecture
import SwiftUI

struct ObservableNavigationTestCaseView: View {
  @State var store = Store(initialState: Feature.State()) {
    Feature()
  }

  var body: some View {
    NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
      NavigationLink(state: ObservableBasicsView.Feature.State()) {
        Text("Push feature")
      }
    } destination: { store in
      Form {
        Section {
          ObservableBasicsView(store: store)
        }
        Section {
          NavigationLink(state: ObservableBasicsView.Feature.State()) {
            Text("Push feature")
          }
        }
      }
    }
  }

  struct Feature: Reducer {
    struct State: Equatable {
      var path = StackState<ObservableBasicsView.Feature.State>()
    }
    enum Action {
      case path(StackAction<ObservableBasicsView.Feature.State, ObservableBasicsView.Feature.Action>)
    }
    var body: some ReducerOf<Self> {
      Reduce { state, action in
        .none
      }
      .forEach(\.path, action: /Action.path) {
        ObservableBasicsView.Feature()
      }
    }
  }
}