//
//  RefreshableTests.swift
//  PullToRefresh
//
//  Created by Oluwatobi Omotayo on 06/09/2022.
//

@testable import PullToRefresh
import XCTest

class RefreshableTests: XCTestCase {
  func testVanilla() {
    let viewModel = PullToRefreshViewModel(
      fetch: { count in
        "\(count) is a good number."
      }
    )
    
    viewModel.incrementButtonTapped()
    XCTAssertEqual(viewModel.count, 1)
  }
}
