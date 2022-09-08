//
//  PullToRefreshApp.swift
//  PullToRefresh
//
//  Created by Oluwatobi Omotayo on 06/09/2022.
//

import SwiftUI

@main
struct PullToRefreshApp: App {
  var body: some Scene {
    WindowGroup {
      LoginForm(viewModel: .init())
    }
  }
}
