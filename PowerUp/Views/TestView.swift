//import SwiftUI
//import HealthKit
//
//struct ProfileView: View {
//    // to store in local storage
//    @State private var firstName = ""
//    @State private var lastName = ""
//    @State private var selectedSex: HKBiologicalSex = .notSet
//    @State private var age: Int = 0
//    // only for initial log in
//    @State private var dateOfBirth = Date()
//    @State private var stepCount: Int = 0
//    @State private var height: Double = 0.0
//    @State private var avgSleepDuration: Double = 0.0
//    @State var caloriesBurned: Int = 0
//    @State var weight: Int = 0
//    @State var heartRate: Int = 0
//
//    var body: some View {
//        VStack {
//            TextField("First Name", text: $firstName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//
//            TextField("Last Name", text: $lastName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//
//            DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
//                .padding()
//            
//            Picker("Sex", selection: $selectedSex) {
//                Text("Female").tag(HKBiologicalSex.female)
//                Text("Male").tag(HKBiologicalSex.male)
//                Text("Other").tag(HKBiologicalSex.other)
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding()
//            
//            Text("Step Count: \(stepCount)")
//                .padding()
//            Text(String(format: "Height: %.2f meters", height))
//                .padding()
//            Text(String(format: "Sleep Duration: %.2f hours", avgSleepDuration))
//                .padding()
//            Text(String(format: "Calories Burned: %i calories", caloriesBurned))
//                .padding()
//            Text(String(format: "Current Weight: %.2f lb", weight))
//                .padding()
////            Text(String(format: "Current Heart Rate: %i bpm", heartRate)).padding()
//
//            NavigationLink(destination: DietView()) {
//                Text("Continue")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//            .simultaneousGesture(TapGesture().onEnded(saveUserData))
//            .padding()
//        }
//        .onAppear {
//            getHealthData()
//        }
//    }
//    
//    func saveUserData() {
//        // saves data on local storage
//        UserDefaults.standard.set(firstName, forKey: "firstName")
////        print("Received first name: " + firstName)
//        UserDefaults.standard.set(lastName, forKey: "lastName")
////        print("Received last name: " + lastName)
//        UserDefaults.standard.set(String(selectedSex.rawValue), forKey: "selectedSex")
////        print("Recieved gender: " + String(selectedSex.rawValue))
//        let calendar = Calendar.current
//        let now = Date()
//        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
//        UserDefaults.standard.set(ageComponents.year, forKey: "age")
//    }
//    
//
//    func loadDateOfBirth() {
//        let healthStore = HKHealthStore()
//
//        do {
//            let dateOfBirth = try healthStore.dateOfBirthComponents()
//            if let date = dateOfBirth.date {
//                DispatchQueue.main.async {
//                    self.dateOfBirth = date
//                }
//            }
//        } catch {
//            // Handle error
//        }
//    }
//
//    func loadBiologicalSex() {
//        let healthStore = HKHealthStore()
//
//        do {
//            let biologicalSex = try healthStore.biologicalSex()
//            DispatchQueue.main.async {
//                self.selectedSex = biologicalSex.biologicalSex
//            }
//        } catch {
//            // Handle error
//        }
//    }
//    
//    func getHealthData() {
//        // Check if HealthKit is available on the device
//        guard HKHealthStore.isHealthDataAvailable() else {
//            // Handle case when HealthKit is not available
//            return
//        }
//
//        let healthStore = HKHealthStore()
//
//        // Define the types of health data you want to read
//        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)
//        let heightType = HKObjectType.quantityType(forIdentifier: .height)
//        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
//        let caloriesBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
//        let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
//        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
//
//        // Request authorization from the user
//        healthStore.requestAuthorization(toShare: nil, read: [stepCountType!, heightType!, sleepType, caloriesBurnedType, weightType, heartRateType]) { (success, error) in
//            if success {
//                // Authorization granted, fetch the data
//                
//                // Fetch step count data
//                let stepCountQuery = HKSampleQuery(sampleType: stepCountType!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
//                    if let steps = results?.compactMap({ $0 as? HKQuantitySample }) {
//                        let totalSteps = steps.reduce(0, { $0 + $1.quantity.doubleValue(for: HKUnit.count()) })
//                        self.stepCount = Int(totalSteps)
//                    
//                        print("Step Count: \(totalSteps)")
//                        // Use the step count data in your app's logic
//                    } else if let error = error {
//                        print("Error retrieving step count data: \(error.localizedDescription)")
//                    }
//                }
//                healthStore.execute(stepCountQuery)
//                
//                // Fetch height data
//                let heightQuery = HKSampleQuery(sampleType: heightType!, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
//                    if let heightSample = results?.last as? HKQuantitySample {
//                        let heightInMeters = heightSample.quantity.doubleValue(for: HKUnit.meter())
//                        self.height = heightInMeters
//                        print("Height: \(height) meters")
//                        // Use the height data in your app's logic
//                    } else if let error = error {
//                        print("Error retrieving height data: \(error.localizedDescription)")
//                    }
//                }
//                healthStore.execute(heightQuery)
//                
//                let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
//                        let endDate = Date()
//                        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
//                
//                // Fetch sleep data
//                let sleepQuery = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
//                            if let sleepSamples = results as? [HKCategorySample] {
//                                // Calculate the average sleep duration
//                                let totalSleepDuration = sleepSamples.reduce(0.0, { $0 + $1.endDate.timeIntervalSince($1.startDate) })
//                                let averageSleepDurationInHours = totalSleepDuration / Double(sleepSamples.count) / 3600
//                                self.avgSleepDuration = averageSleepDurationInHours
//                                
//                                print("Average Sleep Duration: \(averageSleepDurationInHours) hours")
//                                // Use the average sleep duration in your app's logic
//                            } else if let error = error {
//                                print("Error retrieving sleep data: \(error.localizedDescription)")
//                            }
//                        }
//                healthStore.execute(sleepQuery)
//                
//                // Fetch calories burned data
//                let caloriesBurnedQuery = HKStatisticsQuery(quantityType: caloriesBurnedType, quantitySamplePredicate: nil, options: .cumulativeSum) { (query, result, error) in
//                    if let statistics = result, let sum = statistics.sumQuantity() {
//                        DispatchQueue.main.async {
//                            self.caloriesBurned = Int(sum.doubleValue(for: HKUnit.kilocalorie()))
//                            print("Calories Burned: \(caloriesBurned)")
//                        }
//                    } else {
//                        print("Error retrieving calories burned data: \(error?.localizedDescription ?? "")")
//                    }
//                }
//                healthStore.execute(caloriesBurnedQuery)
//                
//                // Fetch weight data
//                let weightQuery = HKStatisticsQuery(quantityType: weightType, quantitySamplePredicate: nil, options: .discreteAverage) { (query, result, error) in
//                    if let statistics = result, let average = statistics.averageQuantity() {
//                        DispatchQueue.main.async {
//                            let weightKilos = (average.doubleValue(for: HKUnit.gramUnit(with: .kilo)))
//                            self.weight = Int(weightKilos * 2.20462)
//                            print("Weight: \(weight) lb")
//                        }
//                    } else {
//                        print("Error retrieving weight data: \(error?.localizedDescription ?? "")")
//                    }
//                }
//                healthStore.execute(weightQuery)
//
//                // Fetch heart rate data
//                let heartRateQuery = HKStatisticsQuery(quantityType: heartRateType, quantitySamplePredicate: nil, options: .discreteAverage) { (query, result, error) in
//                    if let statistics = result, let average = statistics.averageQuantity() {
//                        DispatchQueue.main.async {
//                            self.heartRate = Int(average.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())))
//                            print("Heart Rate: \(heartRate) bpm")
//                        }
//                    } else {
//                        print("Error retrieving heart rate data: \(error?.localizedDescription ?? "")")
//                    }
//                }
//                healthStore.execute(heartRateQuery)
//                
//            } else if let error = error {
//                print("Error requesting HealthKit authorization: \(error.localizedDescription)")
//            }
//        }
//    }
//}
