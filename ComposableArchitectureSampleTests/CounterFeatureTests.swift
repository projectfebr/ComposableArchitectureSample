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

    func testNumberFact() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: { $0.numberFact.fetch = { "\($0) is a good number." } }

        await store.send(.factButtonTapped) { state in
            state.isLoading = true
        }

        await store.receive(.factResponse("\(store.state.count) is a good number.")) { state in
            state.isLoading = false
            state.fact = "\(store.state.count) is a good number."
        }

//        await store.receive(.factResponse("???"), timeout: .seconds(1)) {
//             $0.isLoading = false
//             $0.fact = "???"
//           }
//   Ошибка
//        Received unexpected action: …
//
//            − CounterFeature.Action.factResponse("???")
//            + CounterFeature.Action.factResponse("0 is the coldest possible temperature old the Kelvin scale.")
//
//        (Expected: −, Received: +)

        /// Здесь мы видим, что нет способа протестировать это поведение. Сервер каждый раз будет отправлять другой факт. И даже если бы мы могли предсказать, какие данные будут отправлены обратно с сервера, это все равно было бы не идеально, потому что наши тесты станут медленными и ненадежными, поскольку для них требуется подключение к Интернету и время безотказной работы внешнего сервера. По этим и многим другим причинам настоятельно рекомендуется контролировать свою зависимость от внешних систем
    }
}
