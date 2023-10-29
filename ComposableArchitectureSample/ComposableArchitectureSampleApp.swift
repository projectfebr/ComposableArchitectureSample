//
//  ComposableArchitectureSampleApp.swift
//  ComposableArchitectureSample
//
//  Created by Александр Болотов on 29.10.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct ComposableArchitectureSampleApp: App {
    static let store = Store(
        initialState: CounterFeature.State(),
        reducer: {
            CounterFeature()
        }
    )
    
    var body: some Scene {
        WindowGroup {
            CounterView(store: ComposableArchitectureSampleApp.store)
        }
    }
}
