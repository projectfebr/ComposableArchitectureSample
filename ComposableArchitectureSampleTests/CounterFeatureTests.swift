//
//  CounterFeatureTests.swift
//  ComposableArchitectureSampleTests
//
//  Created by Александр Болотов on 30.10.2023.
//

import ComposableArchitecture
import XCTest

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

    func testTimer() async {
        let clock = TestClock()
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }

        await store.send(.toggleTimerButtonTapped) { state in
            state.isTimerRunning = true
        }
        
        await clock.advance(by: .seconds(1))
        
        await store.receive(.timerTick) { state in
            state.count = 1
        }

        await store.send(.toggleTimerButtonTapped) { state in
            state.isTimerRunning = false
        }
    }
}
