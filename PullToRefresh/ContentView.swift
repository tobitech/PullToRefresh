//
//  ContentView.swift
//  PullToRefresh
//
//  Created by Oluwatobi Omotayo on 06/09/2022.
//

import SwiftUI

struct VanillaPullToRefreshView: View {
  var body: some View {
    List  {
      HStack {
        Button("-") { }
        Text("0")
        Button("+") { }
      }
      .buttonStyle(.plain)
      
      Text("0 is a good number.")
    }
    .refreshable {
      
    }
  }
}

struct VanillaPullToRefreshView_Previews: PreviewProvider {
  static var previews: some View {
    VanillaPullToRefreshView()
  }
}
