//
//  ComposableRefreshable.swift
//  PullToRefresh
//
//  Created by Oluwatobi Omotayo on 07/09/2022.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct PullToRefreshState: Equatable {
  var count = 0
  var fact: String?
}

enum PullToRefreshAction {
  case cancelButtonTapped
  case decrementButtonTapped
  case factResponse(Result<String, FactClient.Error>)
  case incrementButtonTapped
  case refresh
}

struct PullToRefreshEnvironment {
  var fact: FactClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let pullToRefreshReducer = Reducer<PullToRefreshState, PullToRefreshAction, PullToRefreshEnvironment> { state, action, environment in
  
  struct CancelId: Hashable {}
  
  switch action {
  case .cancelButtonTapped:
    // it's stronger to use a dedicated type,
    // than a word that can be accidentally made up.
    // return .cancel(id: "refresh")
    return .cancel(id: CancelId())

  case .decrementButtonTapped:
    state.count -= 1
    return .none

  case let .factResponse(.success(fact)):
    state.fact = fact
    return .none
    
  case let .factResponse(.failure(error)):
    // TODO: handle error
    print(error.localizedDescription)
    return .none

  case .incrementButtonTapped:
    state.count += 1
    return .none

  case .refresh:
    return environment.fact.fetch(state.count)
      // .receive(on: environment.mainQueue)
      .delay(for: .seconds(2), scheduler: environment.mainQueue)
      .catchToEffect()
      .map(PullToRefreshAction.factResponse)
      // .cancellable(id: "refresh")
      .cancellable(id: CancelId())
  }
}

struct PullToRefreshView: View {
  
  let store: Store<PullToRefreshState, PullToRefreshAction>
  @ObservedObject var viewStore: ViewStore<PullToRefreshState, PullToRefreshAction>
  
  init(store: Store<PullToRefreshState, PullToRefreshAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  var body: some View {
    List  {
      HStack {
        Button("-") { self.viewStore.send(.decrementButtonTapped) }
        Text("\(self.viewStore.count)")
        Button("+") { self.viewStore.send(.incrementButtonTapped) }
      }
      .buttonStyle(.plain)
      
      if let fact = self.viewStore.fact {
        Text(fact)
      }
//      else if self.viewModel.isLoading {
//        Button("Cancel") {
//          self.viewStore.send(.cancelButtonTapped)
//        }
//      }
    }
    .refreshable {
      self.viewStore.send(.refresh)
    }
  }
}

struct PullToRefreshView_Previews: PreviewProvider {
  static var previews: some View {
    PullToRefreshView(
      store: .init(
        initialState: .init(),
        reducer: pullToRefreshReducer,
        environment: .init(
          fact: .live,
          mainQueue: .main
        )
      )
    )
  }
}
