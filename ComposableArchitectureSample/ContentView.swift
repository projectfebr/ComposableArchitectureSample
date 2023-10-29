//
//  ContentView.swift
//  ComposableArchitectureSample
//
//  Created by Александр Болотов on 29.10.2023.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    var body: some View {
        CounterView(
            store: Store(
                initialState: CounterFeature.State(),
                reducer: {
                    CounterFeature()
                }
            )
        )
    }
}

#Preview {
    ContentView()
}
