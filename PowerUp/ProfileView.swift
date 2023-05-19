import SwiftUI
import HealthKit

struct ProfileView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var dateOfBirth = Date()
    @State private var selectedSex: HKBiologicalSex = .notSet

    var body: some View {
        VStack {
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                .padding()
            
            Picker("Sex", selection: $selectedSex) {
                Text("Female").tag(HKBiologicalSex.female)
                Text("Male").tag(HKBiologicalSex.male)
                Text("Other").tag(HKBiologicalSex.other)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button(action: {
                saveUserData()
            }) {
                Text("Save Data")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear {
            loadPersonalData()
            getHealthData()
        }
    }

    func loadPersonalData() {
        let healthStore = HKHealthStore()
        let dateOfBirthType = HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!
        let biologicalSexType = HKObjectType.characteristicType(forIdentifier: .biologicalSex)!

        healthStore.requestAuthorization(toShare: nil, read: [dateOfBirthType, biologicalSexType]) { (success, error) in
            if success {
                loadDateOfBirth()
                loadBiologicalSex()
            } else {
                // Handle authorization error
            }
        }
    }

    func loadDateOfBirth() {
        let healthStore = HKHealthStore()

        do {
            let dateOfBirth = try healthStore.dateOfBirthComponents()
            if let date = dateOfBirth.date {
                DispatchQueue.main.async {
                    self.dateOfBirth = date
                }
            }
        } catch {
            // Handle error
        }
    }

    func loadBiologicalSex() {
        let healthStore = HKHealthStore()

        do {
            let biologicalSex = try healthStore.biologicalSex()
            DispatchQueue.main.async {
                self.selectedSex = biologicalSex.biologicalSex
            }
        } catch {
            // Handle error
        }
    }

    func saveUserData() {
        // Handle the user data as needed
        // For example, you can pass the data to another view or perform further processing
        print("User data saved:")
        print("First Name: \(firstName)")
        print("Last Name: \(lastName)")
        print("Date of Birth: \(dateOfBirth)")
        print("Sex: \(selectedSex.rawValue)")
    }
    
    func getHealthData() {
        // Check if HealthKit is available on the device
        guard HKHealthStore.isHealthDataAvailable() else {
            // Handle case when HealthKit is not available
            return
        }

        let healthStore = HKHealthStore()

        // Define the types of health data you want to read
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)
        let heightType = HKObjectType.quantityType(forIdentifier: .height)
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!

        // Request authorization from the user
        healthStore.requestAuthorization(toShare: nil, read: [stepCountType!, heightType!, sleepType]) { (success, error) in
            if success {
                // Authorization granted, fetch the data
                
                // Fetch step count data
                let stepCountQuery = HKSampleQuery(sampleType: stepCountType!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                    if let steps = results?.compactMap({ $0 as? HKQuantitySample }) {
                        let totalSteps = steps.reduce(0, { $0 + $1.quantity.doubleValue(for: HKUnit.count()) })
                        print("Step Count: \(totalSteps)")
                        // Use the step count data in your app's logic
                    } else if let error = error {
                        print("Error retrieving step count data: \(error.localizedDescription)")
                    }
                }
                healthStore.execute(stepCountQuery)
                
                // Fetch height data
                let heightQuery = HKSampleQuery(sampleType: heightType!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                    if let heightSample = results?.last as? HKQuantitySample {
                        let heightInMeters = heightSample.quantity.doubleValue(for: HKUnit.meter())
                        print("Height: \(heightInMeters) meters")
                        // Use the height data in your app's logic
                    } else if let error = error {
                        print("Error retrieving height data: \(error.localizedDescription)")
                    }
                }
                healthStore.execute(heightQuery)
                
                let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
                        let endDate = Date()
                        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
                
                // Fetch sleep data
                let sleepQuery = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                            if let sleepSamples = results as? [HKCategorySample] {
                                // Calculate the average sleep duration
                                let totalSleepDuration = sleepSamples.reduce(0.0, { $0 + $1.endDate.timeIntervalSince($1.startDate) })
                                let averageSleepDuration = totalSleepDuration / Double(sleepSamples.count)
                                
                                print("Average Sleep Duration: \(averageSleepDuration/3600) hours")
                                // Use the average sleep duration in your app's logic
                            } else if let error = error {
                                print("Error retrieving sleep data: \(error.localizedDescription)")
                            }
                        }
                healthStore.execute(sleepQuery)
            } else if let error = error {
                print("Error requesting HealthKit authorization: \(error.localizedDescription)")
            }
        }
}
}
