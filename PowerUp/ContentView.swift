import SwiftUI
import HealthKit

struct ContentView: View {
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
            attemptLoadHealthData()
        }
    }

    func attemptLoadHealthData() {
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
}
