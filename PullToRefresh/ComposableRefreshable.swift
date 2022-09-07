//
//  ComposableRefreshable.swift
//  PullToRefresh
//
//  Created by Oluwatobi Omotayo on 07/09/2022.
//

import Combine
import ComposableArchitecture
import Foundation
import SwiftUI

struct PullToRefreshState: Equatable {
  var count = 0
  var fact: String?
  var isLoading = false
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
    state.isLoading = false
    // it's stronger to use a dedicated type,
    // than a word that can be accidentally made up.
    // return .cancel(id: "refresh")
    return .cancel(id: CancelId())

  case .decrementButtonTapped:
    state.count -= 1
    return .none

  case let .factResponse(.success(fact)):
    state.isLoading = false
    state.fact = fact
    return .none
    
  case let .factResponse(.failure(error)):
    state.isLoading = false
    // TODO: handle error
    print(error.localizedDescription)
    return .none

  case .incrementButtonTapped:
    state.count += 1
    return .none

  case .refresh:
    state.isLoading = true
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
      await self.viewStore.send(.refresh, while: \.isLoading)
    }
  }
}

/*
extension ViewStore {
  func send(
    _ action: Action,
    `while` isInFlight: @escaping (State) -> Bool
  ) async {
    self.send(action)
    
    // this function can help us turn non-async await code into async await code
    // this shows how to bridge non-async-await code into async-await code
    // note that we had to simulate an asynchronous work with old school `asyncAfter` rather than returning the number 42 immediately.
//    let number = await withUnsafeContinuation { continuation in
//      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//        continuation.resume(returning: 42)
//      }
//    }
    
    await withUnsafeContinuation { (continuation: UnsafeContinuation<Void, Never>) in
      var cancellable: Cancellable?
      
      cancellable = self.publisher
        .filter { !isInFlight($0) }
        .prefix(1)
        .sink { _ in
          continuation.resume()
          _ = cancellable // make sure the subscription is alive as long as the predicate is false.
        }
    }
  }
}
*/

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
