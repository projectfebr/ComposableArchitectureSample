//
//  CounterFeature.swift
//  ComposableArchitectureSample
//
//  Created by Александр Болотов on 29.10.2023.
//

import ComposableArchitecture

struct CounterFeature: Reducer {
    struct State {
        var count = 0
    }

    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
    }

    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.Effect<Action> {
        switch action {
        case .decrementButtonTapped:
            state.count -= 1
            return .none
        case .incrementButtonTapped:
            state.count += 1
            return .none
        }
    }
}

extension CounterFeature.State: Equatable {}
