import SwiftUI
import HealthKit

struct OldProfileView: View {
    // to store in local storage
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedSex: HKBiologicalSex = .notSet
    @State private var age: Int = 0
    // only for initial log in
    @State private var dateOfBirth = Date()
    @State private var stepCount: Int = 0
    @State private var height: Double = 0.0
    @State private var avgSleepDuration: Double = 0.0
    @State var caloriesBurned: Int = 0
    @State var weight: Int = 0
    @State var heartRate: Int = 0

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

//            Text("Step Count: \(stepCount)")
//                .padding()
            Text(String(format: "Height: %.2f meters", height))
                .padding()
//            Text(String(format: "Sleep Duration: %.2f hours", avgSleepDuration))
//                .padding()
//            Text(String(format: "Calories Burned: %i calories", caloriesBurned))
//                .padding()
            Text(String(format: "Current Weight: %i lb", weight))
                .padding()

            Spacer()

            NavigationLink(destination: DietView()) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .simultaneousGesture(TapGesture().onEnded(saveUserData))
            .padding()
        }
        .onAppear {
            getHealthData()
        }
    }
    
    func saveUserData() {
        // saves data on local storage
        UserDefaults.standard.set(firstName, forKey: "firstName")
        UserDefaults.standard.set(lastName, forKey: "lastName")
        UserDefaults.standard.set(String(selectedSex.rawValue), forKey: "selectedSex")
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
        UserDefaults.standard.set(ageComponents.year, forKey: "age")
        print("Saved data from ProfileView")
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
        let caloriesBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!

        // Request authorization from the user
        healthStore.requestAuthorization(toShare: nil, read: [stepCountType!, heightType!, sleepType, caloriesBurnedType, weightType, heartRateType]) { (success, error) in
            if success {
                // Authorization granted, fetch the data
                
                // Fetch step count data
                let stepCountQuery = HKSampleQuery(sampleType: stepCountType!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                    if let steps = results?.compactMap({ $0 as? HKQuantitySample }) {
                        let totalSteps = steps.reduce(0, { $0 + $1.quantity.doubleValue(for: HKUnit.count()) })
                        self.stepCount = Int(totalSteps)
                    
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
                        self.height = heightInMeters
                        print("Height: \(height) meters")
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
                        let averageSleepDurationInHours = totalSleepDuration / Double(sleepSamples.count) / 3600
                        self.avgSleepDuration = averageSleepDurationInHours
                        
                        print("Average Sleep Duration: \(averageSleepDurationInHours) hours")
                        // Use the average sleep duration in your app's logic
                    } else if let error = error {
                        print("Error retrieving sleep data: \(error.localizedDescription)")
                    }
                }
                healthStore.execute(sleepQuery)
                
                // Fetch calories burned data
                let caloriesBurnedQuery = HKStatisticsQuery(quantityType: caloriesBurnedType, quantitySamplePredicate: nil, options: .cumulativeSum) { (query, result, error) in
                    if let statistics = result, let sum = statistics.sumQuantity() {
                        DispatchQueue.main.async {
                            self.caloriesBurned = Int(sum.doubleValue(for: HKUnit.kilocalorie()))
                            print("Calories Burned: \(caloriesBurned)")
                        }
                    } else {
                        print("Error retrieving calories burned data: \(error?.localizedDescription ?? "Unknown Error")")
                    }
                }
                healthStore.execute(caloriesBurnedQuery)
                
                // Fetch weight data
                let weightQuery = HKSampleQuery(sampleType: weightType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                    if let weightSample = results?.last as? HKQuantitySample {
                        let weightInPounds = weightSample.quantity.doubleValue(for: HKUnit.pound())
                        self.weight = Int(weightInPounds)
                        print("Current Weight: \(weight) lb")
                        // Use the weight data in your app's logic
                    } else if let error = error {
                        print("Error retrieving weight data: \(error.localizedDescription)")
                    }
                }
                healthStore.execute(weightQuery)

                // Fetch heart rate data
                let heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                    if let heartRateSamples = results as? [HKQuantitySample] {
                        let heartRateSum = heartRateSamples.reduce(0.0, { $0 + $1.quantity.doubleValue(for: HKUnit(from: "count/min")) })
                        let averageHeartRate = heartRateSum / Double(heartRateSamples.count)
                        self.heartRate = Int(averageHeartRate)
                        print("Average Heart Rate: \(averageHeartRate) bpm")
                        // Use the heart rate data in your app's logic
                    } else if let error = error {
                        print("Error retrieving heart rate data: \(error.localizedDescription)")
                    }
                }
                healthStore.execute(heartRateQuery)
            } else {
                // Authorization denied or an error occurred
                print("HealthKit authorization denied or error occurred: \(error?.localizedDescription ?? "Unknown Error")")
            }
        }
    }
}
