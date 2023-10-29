//
//  CounterFeatureTests.swift
//  ComposableArchitectureSampleTests
//
//  Created by Александр Болотов on 30.10.2023.
//

import XCTest
import ComposableArchitecture


@MainActor
final class CounterFeatureTests: XCTestCase {
    func testCounter() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped) { state in
            state.count = 1
        }
        
        await store.send(.decrementButtonTapped) { state in
            state.count = 0
        }
        
        
    }
}
