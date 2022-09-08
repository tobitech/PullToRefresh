//
//  ComposableFocusState.swift
//  PullToRefresh
//
//  Created by Oluwatobi Omotayo on 08/09/2022.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct LoginState: Equatable {
  @BindableState var focusField: Field? = nil
  @BindableState var password: String = ""
  @BindableState var username: String = ""
  
  enum Field: String, Hashable {
    case username, password
  }
}

enum LoginAction: BindableAction {
//  case setFocusedField(LoginState.Field?)
//  case setPassword(String)
//  case setUsername(String)
  case binding(BindingAction<LoginState>)
  case signInButtonTapped
}

struct LoginEnvironment {}

let loginReducer: Reducer<LoginState, LoginAction, LoginEnvironment> = Reducer { state, action, _ in
  switch action {
  case .binding:
    return .none

  case .signInButtonTapped:
    if state.username.isEmpty {
      state.focusField = .username
    } else if state.password.isEmpty {
      state.focusField = .password
    }
    return .none
  }
}.binding()

struct TCALoginView: View {
  @FocusState var focusedField: LoginState.Field?
  let store: Store<LoginState, LoginAction>
  @ObservedObject var viewStore: ViewStore<LoginState, LoginAction>
  
  init(store: Store<LoginState, LoginAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  var body: some View {
    Form {
      TextField("Username", text: self.viewStore.binding(\.$username))
        .focused($focusedField, equals: .username)
      
      SecureField("Password", text: self.viewStore.binding(\.$password))
        .focused($focusedField, equals: .password)
      
      Button("Sign In") {
        self.viewStore.send(.signInButtonTapped)
      }
      
      Text("\(String(describing: self.viewStore.focusField))")
    }
//    .onChange(of: self.viewStore.focusField) { newValue in
//      self.focusedField = newValue
//    }
//    .onChange(of: self.focusedField) { newValue in
//      self.viewStore.send(.binding(.set(\.focusField, newValue)))
//    }
    .synchronize(
      self.viewStore.binding(\.$focusField),
      self.$focusedField
    )
  }
}

extension View {
//  func synchronize<Value: Equatable>(
//    _ first: Binding<Value>,
//    _ second: Binding<Value>
//  ) -> some View {
//    self
//      .onChange(of: first.wrappedValue) { second.wrappedValue = $0 }
//      .onChange(of: second.wrappedValue) { first.wrappedValue = $0 }
//  }
  
  // hopefully this will be possible some day in Swift to have `PropertyWrapper` as a protocol.
//  func synchronize<A, B>(
//    _ first: A,
//    _ second: B
//  ) where A: PropertyWrapper, B: PropertyWrapper, A.Wrapped == B.Wrapped -> some View {
//    self
//      .onChange(of: first.wrappedValue) { second.wrappedValue = $0 }
//      .onChange(of: second.wrappedValue) { first.wrappedValue = $0 }
//  }
  
  func synchronize<Value: Equatable>(
    _ first: Binding<Value>,
    _ second: FocusState<Value>.Binding
  ) -> some View {
    self
      .onChange(of: first.wrappedValue) { second.wrappedValue = $0 }
      .onChange(of: second.wrappedValue) { first.wrappedValue = $0 }
  }
}
