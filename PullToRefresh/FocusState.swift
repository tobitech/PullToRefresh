//
//  FocusState.swift
//  PullToRefresh
//
//  Created by Oluwatobi Omotayo on 08/09/2022.
//

import SwiftUI

struct LoginForm: View {
  enum Field: Hashable {
    case username
    case password
  }
  
  @State private var username = ""
  @State private var password = ""
  @FocusState private var focusedField: Field?
  
  var body: some View {
    Form {
      TextField("Username", text: $username)
        .focused($focusedField, equals: .username)
      
      SecureField("Password", text: $password)
        .focused($focusedField, equals: .password)
      
      Button("Sign In") {
        if username.isEmpty {
          focusedField = .username
        } else if password.isEmpty {
          focusedField = .password
        } else {
          // handleLogin(username, password)
        }
      }
    }
  }
}
