//
//  ResultsView.swift
//  PowerUp
//
//  Created by Ileen F on 5/19/23.
//

import SwiftUI

struct ResultsView: View {
    var calories: Int
    var body: some View {
        VStack {
            Text("calories: \(calories) cal")
                .padding()
        }
    }
}
