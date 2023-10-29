//
//  CounterView.swift
//  ComposableArchitectureSample
//
//  Created by Александр Болотов on 29.10.2023.
//

import ComposableArchitecture
import SwiftUI

struct CounterView: View {
    let store: StoreOf<CounterFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("\(viewStore.count)")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                HStack {
                    Button(action: { viewStore.send(.decrementButtonTapped) }, label: {
                        Text("-")
                    })
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    Button(action: { viewStore.send(.incrementButtonTapped) }, label: {
                        Text("+")
                    })
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    CounterView(
        store: Store(
            initialState: CounterFeature.State(),
            reducer: {
                CounterFeature()
            }
        )
    )
}