//
//  HealthStatsView.swift
//  PowerUp
//
//  Created by Ileen F on 5/19/23.
//

import SwiftUI
import HealthKit

struct HealthStatsView: View {
    @State private var caloriesBurned: Int = 332
    @State private var weight: Int = 23
    @State private var heartRate: Int = 42

    var body: some View {
        VStack {
            Text("Active Calories Burned: \(caloriesBurned) cal")
                .padding()
            Text("Weight (lbs): \(weight)")
                .padding()
            Text("Heart Rate (BPM): \(heartRate)")
                .padding()
            
            NavigationLink(destination: ProfileView()) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
                
            }
        .navigationBarTitle("Health Stats")
        .onAppear {
            getHealthData()
            }
        }

    func getHealthData() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device.")
            return
        }

        let healthStore = HKHealthStore()

        let caloriesBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!

        healthStore.requestAuthorization(toShare: nil, read: [caloriesBurnedType, weightType, heartRateType]) { (success, error) in
            if success {
                // Authorization granted, fetch the data
                print("successss")

                // Fetch calories burned data
                let caloriesBurnedQuery = HKStatisticsQuery(quantityType: caloriesBurnedType, quantitySamplePredicate: nil, options: .cumulativeSum) { (query, result, error) in
                    if let statistics = result, let sum = statistics.sumQuantity() {
                        DispatchQueue.main.async {
                            self.caloriesBurned = Int(sum.doubleValue(for: HKUnit.kilocalorie()))
                        }
                    } else {
                        print("Error retrieving calories burned data: \(error?.localizedDescription ?? "")")
                    }
                }
                healthStore.execute(caloriesBurnedQuery)

                // Fetch weight data
                let weightQuery = HKStatisticsQuery(quantityType: weightType, quantitySamplePredicate: nil, options: .discreteAverage) { (query, result, error) in
                    if let statistics = result, let average = statistics.averageQuantity() {
                        DispatchQueue.main.async {
                            let weightKilos = (average.doubleValue(for: HKUnit.gramUnit(with: .kilo)))
                            self.weight = Int(weightKilos * 2.20462)
                        }
                    } else {
                        print("Error retrieving weight data: \(error?.localizedDescription ?? "")")
                    }
                }
                healthStore.execute(weightQuery)

                // Fetch heart rate data
                let heartRateQuery = HKStatisticsQuery(quantityType: heartRateType, quantitySamplePredicate: nil, options: .discreteAverage) { (query, result, error) in
                    if let statistics = result, let average = statistics.averageQuantity() {
                        DispatchQueue.main.async {
                            self.heartRate = Int(average.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())))
                        }
                    } else {
                        print("Error retrieving heart rate data: \(error?.localizedDescription ?? "")")
                    }
                }
                healthStore.execute(heartRateQuery)
            } else if let error = error {
                print("Error requesting HealthKit authorization: \(error.localizedDescription)")
            }
        }
    }
}
