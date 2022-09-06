//
//  ContentView.swift
//  PullToRefresh
//
//  Created by Oluwatobi Omotayo on 06/09/2022.
//

import SwiftUI

class PullToRefreshViewModel: ObservableObject {
  @Published var count = 0
  @Published var fact: String? = nil
  
  func incrementButtonTapped() {
    self.count += 1
  }
  
  func decrementButtonTapped() {
    self.count -= 1
  }
  
  // we want to reach out to an external API service, which mean we need to do a bit of asynchronous work.
  // perfect opportunity to try out Swift's new async/await machinery.
  func getFact() async {
    self.fact = nil
    
    do {
      try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
      
      let (data, _) = try await URLSession.shared.data(from: .init(string: "http://numbersapi.com/\(self.count)/trivia")!)
      withAnimation {
        self.fact = String(decoding: data, as: UTF8.self)
      }
    } catch {
      print(error.localizedDescription)
      // TODO: do some error handling
    }
  }
}

struct VanillaPullToRefreshView: View {
  @ObservedObject var viewModel: PullToRefreshViewModel
  
  var body: some View {
    List  {
      HStack {
        Button("-") { self.viewModel.decrementButtonTapped() }
        Text("\(self.viewModel.count)")
        Button("+") { self.viewModel.incrementButtonTapped() }
      }
      .buttonStyle(.plain)
      
      if let fact = self.viewModel.fact {
        Text(fact)
      }
    }
    .refreshable {
      await self.viewModel.getFact()
    }
  }
}

struct VanillaPullToRefreshView_Previews: PreviewProvider {
  static var previews: some View {
    VanillaPullToRefreshView(viewModel: PullToRefreshViewModel())
  }
}
