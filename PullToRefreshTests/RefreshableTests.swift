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
        try await Task.sleep(nanoseconds: 20_000_000)
        return "\(count) is a good number."
      }
    )
    
    viewModel.incrementButtonTapped()
    XCTAssertEqual(viewModel.count, 1)
    
    XCTAssertEqual(viewModel.isLoading, false)
    let task = Task {
      await viewModel.getFact()
    }
    await Task.sleep(nanoseconds: 10_000_000)
    XCTAssertEqual(viewModel.isLoading, true)
    await task.value
    XCTAssertEqual(viewModel.fact, "1 is a good number.")
    XCTAssertEqual(viewModel.isLoading, false)
  }
}
