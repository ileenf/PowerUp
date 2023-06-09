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
    let localDataKeys = ["firstName", "lastName", "selectedSex", "age", "eatOutFrequency", "veggieFrequency", "foodCategory", "workoutFrequency", "selectedTypeOption", "selectedPartOption", "height", "weight", "heartRate", "caloriesBurned",  "stepCount", "avgSleepDuration"]
    
    var body: some Scene {
        WindowGroup {
            
            // checking if all data is nil?
            if hasAllNonNilData() == false {
                WelcomeView().onAppear() {
                    print("ALL THE DATA IS NOT NULL")
                    clearUserData()
                }

            }
            // call this is all data is not nil
            else {
                // i want to call clearUserdata here, but it wont let me
                WelcomeBackView().onAppear {
                    print("at least one data is null")
//                    printUserData()
//                    clearUserData()
                }
            }
        }
    }   
    
    private func hasAllNonNilData() -> Bool {
        print("in nil check")
        for key in localDataKeys {
            if UserDefaults.standard.value(forKey: key) == nil {
                print("at least one data is not nil")
                return false
            }
        }
        print("all data has some value")
        return true
    }
    private func printUserData() {
        let firstName = UserDefaults.standard.string(forKey: "firstName")
        let lastName = UserDefaults.standard.string(forKey: "lastName")
        let selectedSex = UserDefaults.standard.string(forKey: "selectedSex")
        let age = UserDefaults.standard.string(forKey: "age")
        let workOutFrequency = UserDefaults.standard.string(forKey: "workoutFrequency")
        print(firstName)
        print(lastName)
        print(selectedSex)
        print(age)
        print(workOutFrequency)
        
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
        UserDefaults.standard.removeObject(forKey: "foodCategory")
        UserDefaults.standard.removeObject(forKey: "workoutFrequency")
        UserDefaults.standard.removeObject(forKey: "selectedTypeOption")
        UserDefaults.standard.removeObject(forKey: "selectedPartOption")
        UserDefaults.standard.removeObject(forKey: "height")
        UserDefaults.standard.removeObject(forKey: "weight")
        UserDefaults.standard.removeObject(forKey: "heartRate")
        UserDefaults.standard.removeObject(forKey: "caloriesBurned")
        UserDefaults.standard.removeObject(forKey: "stepCount")
        UserDefaults.standard.removeObject(forKey: "avgSleepDuration")
    }
}
