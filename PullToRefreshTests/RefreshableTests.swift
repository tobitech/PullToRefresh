//
//  RefreshableTests.swift
//  PullToRefresh
//
//  Created by Oluwatobi Omotayo on 06/09/2022.
//

@testable import PullToRefresh
import XCTest

class RefreshableTests: XCTestCase {
  func testVanilla() async {
    let viewModel = PullToRefreshViewModel(
      fetch: { count in
        "\(count) is a good number."
      }
    )
    
    viewModel.incrementButtonTapped()
    XCTAssertEqual(viewModel.count, 1)
    
    XCTAssertEqual(viewModel.isLoading, false)
    
    await viewModel.getFact()
    
    XCTAssertEqual(viewModel.fact, "1 is a good number.")
    XCTAssertEqual(viewModel.isLoading, false)
  }
}
