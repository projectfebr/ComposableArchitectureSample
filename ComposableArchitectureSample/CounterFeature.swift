//
//  CounterFeature.swift
//  ComposableArchitectureSample
//
//  Created by Александр Болотов on 29.10.2023.
//

import ComposableArchitecture
import Foundation

struct CounterFeature: Reducer {
    struct State {
        var count = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }

    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case factButtonTapped
        case factResponse(String)
        case toggleTimerButtonTapped
        case timerTick
    }

    enum CancelID {
        case timer
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFact

    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.Effect<Action> {
        switch action {
        case .decrementButtonTapped:
            state.count -= 1
            state.fact = nil
            return .none
        case .incrementButtonTapped:
            state.count += 1
            state.fact = nil
            return .none
        case .factButtonTapped:
            state.fact = nil
            state.isLoading = true
            return .run { [count = state.count] send in
                try await send(.factResponse(numberFact.fetch(count)))
            }
        case let .factResponse(fact):
            state.fact = fact
            state.isLoading = false
            return .none
        case .toggleTimerButtonTapped:
            state.isTimerRunning.toggle()
            if state.isTimerRunning {
                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(1)) {
                        await send(.timerTick)
                    }
                }
                // помечаем эффект отменяемым чтобы в будущем можно было остановить эффект
                .cancellable(id: CancelID.timer)
            } else {
                return .cancel(id: CancelID.timer)
            }
        case .timerTick:
            state.count += 1
            state.fact = nil
            return .none
        }
    }
}

extension CounterFeature.State: Equatable {}


// В тестах для использования receive тип Action функции должен быть Equatable.
// Это связано с тем, что хранилище тестов должно подтвердить полученное действие.
extension CounterFeature.Action: Equatable {}
