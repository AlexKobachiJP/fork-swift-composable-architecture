import AuthenticationClient
import ComposableArchitecture
import Dispatch
import LoginCore
import NewGameCore

public struct TicTacToe: ReducerProtocol {
  // TODO: What is the `@PresentationState` equivalent for non-optional enum state?
  // TODO: Should `ifLet` and `ifCaseLet` (and `forEach`) manage effect lifecycles?
  // TODO: Should `presents` just be `ifLet`+`dismiss`(+`???`)
  public enum State: Equatable {
    case login(Login.State)
    case newGame(NewGame.State)

    public init() { self = .login(Login.State()) }
  }

  public enum Action: Equatable {
    case login(Login.Action)
    case newGame(NewGame.Action)
  }

  public init() {}

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .login(.twoFactor(.presented(.twoFactorResponse(.success)))):
        state = .newGame(NewGame.State())
        return .none

      case let .login(.loginResponse(.success(response))) where !response.twoFactorRequired:
        state = .newGame(NewGame.State())
        return .none

      case .login:
        return .none

      case .newGame(.logoutButtonTapped):
        state = .login(Login.State())
        return .none

      case .newGame:
        return .none
      }
    }
    .ifCaseLet(/State.login, action: /Action.login) {
      Login()
    }
    .ifCaseLet(/State.newGame, action: /Action.newGame) {
      NewGame()
    }
  }
}
