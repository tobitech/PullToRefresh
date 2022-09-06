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
      VanillaPullToRefreshView(
        viewModel: PullToRefreshViewModel(
          fetch: { count in
            try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
            
            let (data, _) = try await URLSession.shared.data(from: .init(string: "http://numbersapi.com/\(count)/trivia")!)
            
            return String(decoding: data, as: UTF8.self)
          }
        )
      )
    }
  }
}
