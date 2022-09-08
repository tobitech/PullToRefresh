//
//  FocusState.swift
//  PullToRefresh
//
//  Created by Oluwatobi Omotayo on 08/09/2022.
//

import SwiftUI

class LoginViewModel: ObservableObject {
  @Published var username = ""
  @Published var password = ""
  // @FocusState var focusedField: LoginForm.Field?
  
  func signInButtonTapped() -> LoginForm.Field? {
    if self.username.isEmpty {
      return .username
    } else if self.password.isEmpty {
      return .password
    } else {
      return nil
      // handleLogin(username, password)
    }
  }
}

struct LoginForm: View {
  enum Field: Hashable {
    case username
    case password
  }
  
//  @State private var username = ""
//  @State private var password = ""
  @FocusState private var focusedField: Field?
  
  @ObservedObject var viewModel: LoginViewModel
  
  var body: some View {
    Form {
      TextField("Username", text: self.$viewModel.username)
      // Accessing FocusState's value outside of the body of a View. This will result in a constant Binding of the initial value and will not update.
      // This is becuase @FocusState comforms to the DynamicProperty protocol, and this is something that can only be used with views not with objects.
        .focused($focusedField, equals: .username)
      
      SecureField("Password", text: self.$viewModel.password)
        .focused($focusedField, equals: .password)
      
      Button("Sign In") {
        self.focusedField = self.viewModel.signInButtonTapped()
      }
    }
  }
}
