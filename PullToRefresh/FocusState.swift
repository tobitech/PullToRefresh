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
  @Published var focusedField: LoginForm.Field?
  
  func signInButtonTapped() async {
    if self.username.isEmpty {
      focusedField = .username
    } else if self.password.isEmpty {
      focusedField = .password
    } else {
      // we can nil out focus after an asynchronous work.
      focusedField = nil
      do {
        // try await handleLogin(username, password)
      } catch {
        self.focusedField = .username
      }
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
        Task {
          await self.viewModel.signInButtonTapped()
        }
      }
      
      Text("\(String(describing: self.viewModel.focusedField))")
    }
    .onChange(of: self.viewModel.focusedField) { newValue in
      self.focusedField = newValue
    }
    .onChange(of: self.focusedField) { newValue in
      self.viewModel.focusedField = newValue
    }
  }
}
