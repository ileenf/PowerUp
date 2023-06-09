import SwiftUI
import HealthKit

struct ProfileView: View {
    // to store in local storage
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedSex: HKBiologicalSex = .notSet
    // only for initial log in
    @State private var dateOfBirth = Date()
    @State private var stepCount: Int = 0
    @State private var height: Double = 0.0
    @State private var avgSleepDuration: Double = 0.0
    @State var caloriesBurned: Int = 0
    @State var weight: Int = 0
    @State var heartRate: Int = 0
    // color for UI
    let baseBlack = Color(rgb: 0x1c1b1d)
    let lightPink = Color(rgb: 0xdeaf9d)
    let lightWhite = Color(rgb: 0xf2efed)
    
    var body: some View {
        baseBlack
            .ignoresSafeArea() // Ignore just for the color
            .overlay(
                VStack {
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(PlainTextFieldStyle())
                        .frame(width: 300, height: 20)
                        .padding()
                        .font(.headline)
                        .foregroundColor(baseBlack)
//                        .accentColor(lightWhite)
                        .background(lightWhite)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                    
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(PlainTextFieldStyle())
                        .frame(width: 300, height: 20)
                        .padding()
                        .font(.headline)
                        .foregroundColor(baseBlack)
//                        .accentColor(lightWhite)
                        .background(lightWhite)
                        .cornerRadius(8)
                        .shadow(radius: 4)

                    Spacer()
                    
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                        .frame(width: 360, height: 40)
                        .background(lightPink)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                    
                    Picker("Sex", selection: $selectedSex) {
                        Text("Female").tag(HKBiologicalSex.female)
                            .font(.headline)
                        Text("Male").tag(HKBiologicalSex.male)
                            .font(.headline)
                        Text("Other").tag(HKBiologicalSex.other)
                            .font(.headline)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 360, height: 40)
                    .background(lightWhite)
                    .padding()
                    
                    Spacer()
                    
                    Text(String(format: "Height: %.2f cm", height))
                        .padding()
                        .font(.headline)
                        .foregroundColor(.black)
                        .background(lightPink)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                    
                    Text(String(format: "Current Weight: %i kg", weight))
                        .padding()
                        .font(.headline)
                        .foregroundColor(.black)
                        .background(lightPink)
                        .cornerRadius(8)
                        .shadow(radius: 4)

                    Spacer()
                    
                    NavigationLink(destination: DietView()) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(baseBlack)
                            .padding()
                            .background(lightPink)
                            .cornerRadius(10)
                    }
                    .simultaneousGesture(TapGesture().onEnded(saveUserData))
                        .padding()
                }
                .onAppear {
                    getHealthData()
                }
                .background(baseBlack.opacity(0.1)) // Set background color
           )
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
        UserDefaults.standard.set(height, forKey: "height")
        UserDefaults.standard.set(weight, forKey: "weight")
        UserDefaults.standard.set(heartRate, forKey: "heartRate")
        UserDefaults.standard.set(caloriesBurned, forKey: "caloriesBurned")
        UserDefaults.standard.set(stepCount, forKey: "stepCount")
        UserDefaults.standard.set(avgSleepDuration, forKey: "avgSleepDuration")
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

        // time ranges for querying data
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        
        // Request authorization from the user
        healthStore.requestAuthorization(toShare: nil, read: [stepCountType!, heightType!, sleepType, caloriesBurnedType, weightType, heartRateType]) { (success, error) in
            if success {
                // Authorization granted, fetch the data
                
                // Fetch step count data
                let stepCountQuery = HKSampleQuery(sampleType: stepCountType!, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                    if let steps = results?.compactMap({ $0 as? HKQuantitySample }) {
                        let totalSteps = steps.reduce(0.0, { $0 + $1.quantity.doubleValue(for: HKUnit.count()) })
                        let numberOfEntries = steps.count
                        let averageStepCount: Double
                        
                        if numberOfEntries >= 7 {
                            averageStepCount = totalSteps / 7.0
                        } else {
                            averageStepCount = totalSteps / Double(numberOfEntries)
                        }
                        
                        DispatchQueue.main.async {
                            self.stepCount = Int(averageStepCount)
                            print("Number of Step Entries: \(numberOfEntries)")
                            print("Average Step Count (Past 7 Days): \(self.stepCount)")
                        }
                    } else if let error = error {
                        print("Error retrieving step count data: \(error.localizedDescription)")
                    }
                }
                healthStore.execute(stepCountQuery)
                
                // Fetch height data
                let heightQuery = HKSampleQuery(sampleType: heightType!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                    if let heightSample = results?.last as? HKQuantitySample {
                        let heightInCM = heightSample.quantity.doubleValue(for: HKUnit.meter()) * 100
                        self.height = heightInCM
                        print("Height: \(height) cm")
                        // Use the height data in your app's logic
                    } else if let error = error {
                        print("Error retrieving height data: \(error.localizedDescription)")
                    }
                }
                healthStore.execute(heightQuery)
                
                // Fetch sleep data
                let sleepQuery = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                    if let sleepSamples = results as? [HKCategorySample] {
                        // Calculate the average sleep duration
                        let totalSleepDuration = sleepSamples.reduce(0.0, { $0 + $1.endDate.timeIntervalSince($1.startDate) })
                        let averageSleepDurationInHours = totalSleepDuration / Double(sleepSamples.count) / 3600
                        self.avgSleepDuration = averageSleepDurationInHours
                        
                        print("Average Sleep Duration: \(averageSleepDurationInHours) hours")
                    } else if let error = error {
                        print("Error retrieving sleep data: \(error.localizedDescription)")
                    }
                }
                healthStore.execute(sleepQuery)
                
                // Fetch calories burned data
                let caloriesQuery = HKSampleQuery(sampleType: caloriesBurnedType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
                    if let samples = samples as? [HKQuantitySample] {
                        let numberOfEntries = samples.count
                        let totalCaloriesBurned = samples.reduce(0.0) { $0 + $1.quantity.doubleValue(for: HKUnit.kilocalorie()) }
                        let averageCaloriesBurned: Double
                        
                        if numberOfEntries < 7 {
                            averageCaloriesBurned = totalCaloriesBurned / Double(numberOfEntries)
                        } else {
                            averageCaloriesBurned = totalCaloriesBurned / 7.0
                        }
                        
                        DispatchQueue.main.async {
                            self.caloriesBurned = Int(averageCaloriesBurned)
                            print("Number of Valid Entries: \(numberOfEntries)")
                            print("Average Calories Burned per Day (Past 7 Days): \(self.caloriesBurned)")
                        }
                    } else if let error = error {
                        print("Error retrieving calories burned data: \(error.localizedDescription)")
                    }
                }
                
                healthStore.execute(caloriesQuery)
                
                // Fetch weight data
                let weightQuery = HKSampleQuery(sampleType: weightType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                    if let weightSample = results?.last as? HKQuantitySample {
                        let weightInKg = weightSample.quantity.doubleValue(for: HKUnit.pound()) * 0.45359237
                        self.weight = Int(weightInKg)
                        print("Current Weight: \(weight) lb")
                        // Use the weight data in your app's logic
                    } else if let error = error {
                        print("Error retrieving weight data: \(error.localizedDescription)")
                    }
                }
                healthStore.execute(weightQuery)
                
                // Fetch heart rate data
                let heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
                    if let heartRateSamples = results?.compactMap({ $0 as? HKQuantitySample }) {
                        let totalHeartRate = heartRateSamples.reduce(0.0, { $0 + $1.quantity.doubleValue(for: HKUnit(from: "count/min")) })
                        let numberOfEntries = heartRateSamples.count
                        let averageHeartRate: Double
                        
                        if numberOfEntries >= 7 {
                            averageHeartRate = totalHeartRate / 7.0
                        } else {
                            averageHeartRate = totalHeartRate / Double(numberOfEntries)
                        }
                        
                        DispatchQueue.main.async {
                            self.heartRate = Int(averageHeartRate)
                            print("Number of Heart Rate Entries: \(numberOfEntries)")
                            print("Average Heart Rate (Past 7 Days): \(self.heartRate) bpm")
                        }
                    } else if let error = error {
                        print("Error retrieving heart rate data: \(error.localizedDescription)")
                    }
                }
                
                healthStore.execute(heartRateQuery)
            }
        }
    }
}
