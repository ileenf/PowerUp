//
//  PowerUpApp.swift
//  PowerUp
//
//  Created by Ileen F on 5/3/23.
//

import SwiftUI

@main
struct PowerUpApp: App {
    let storedFirstName = UserDefaults.standard.string(forKey: "firstName")
    var body: some Scene {
        WindowGroup {
            if storedFirstName == nil || storedFirstName == "" {
                WelcomeView()
            }
            else {
                ResultsView().onAppear {
                    clearUserData()
                }
            }
        }
    }
    private func clearUserData() {
        print("clearing data")
        // Clear the stored user data in UserDefaults
        UserDefaults.standard.removeObject(forKey: "firstName")
        UserDefaults.standard.removeObject(forKey: "lastName")
        UserDefaults.standard.removeObject(forKey: "selectedSex")
        UserDefaults.standard.removeObject(forKey: "age")
        UserDefaults.standard.removeObject(forKey: "eatOutFrequency")
        UserDefaults.standard.removeObject(forKey: "veggieFrequency")
        UserDefaults.standard.removeObject(forKey: "selectedOption")
        UserDefaults.standard.removeObject(forKey: "workoutFrequency")
        UserDefaults.standard.removeObject(forKey: "selectedTypeOption")
        UserDefaults.standard.removeObject(forKey: "selectedPartOption")
    }
}
