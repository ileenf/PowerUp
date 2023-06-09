import SwiftUI

struct ResultsView: View {
    @State private var firstName: String = ""
    @State private var eatOutFrequency: Int = 0
    @State private var veggieFrequency: Int = 0
    @State private var foodCategory: String = ""
    @State private var workoutFrequency: Int = 0
    @State private var bodyPart: String = ""
    @State private var activityLevel: String = ""
    @State private var workoutIntensity: Int = 0
    @State private var gender: Int = 0
    @State private var height: Int = 0
    @State private var weight: Int = 0
    @State private var heartRate: Int = 0
    @State private var caloriesBurned: Int = 0
    @State private var stepCount: Int = 0
    @State private var avgSleepDuration: Int = 0
    @State private var activityLevelToIntensity = ["Leisure": 1, "Casual": 2, "Active": 3]
    @State private var overallScore: Int = 0
    @State private var dietScore: Int = 0
    @State private var exerciseScore: Int = 0
    @State private var sleepScore: Int = 0
    @State private var recommendedExercises: [String] = []
    @State private var recommendedFoods: [String] = []
    @State private var recommendedSleep: String = ""
    
    // color for UI
    let baseBlack = Color(rgb: 0x1c1b1d)
    let lightPink = Color(rgb: 0xdeaf9d)
    let lightWhite = Color(rgb: 0xf2efed)
    
    var body: some View {
        baseBlack
            .ignoresSafeArea()
            .overlay(
                VStack {
                    Text("The results are in...")
                        .foregroundColor(lightWhite)
                        .font(.title)
                        .bold()
                        .padding()
                        .onAppear {
                            requestAllScoreData()
                            requestFoodRecommendationData()
                            requestExerciseRecommendationData()
                        }
                    
                    Text("Overall Score: \(self.overallScore)/1000")
                        .foregroundColor(lightPink)
                        .font(.title)
                        .padding()
                    
                    Text("Sleep Score: \(self.sleepScore)%")
                        .foregroundColor(lightPink)
                        .font(.headline)
                        .padding()
                    
                    Text("\(self.recommendedSleep)")
                        .foregroundColor(lightWhite)
                    
                    Text("Diet Score: \(self.dietScore)%")
                        .foregroundColor(lightPink)
                        .font(.headline)
                        .padding()
                    
                    Text("Foods high in \(self.foodCategory)")
                    
                    ForEach(recommendedFoods.prefix(5), id: \.self) { food in
                        Text("Food: \(food)")
                            .foregroundColor(lightWhite)
                    }
                    
                    Text("Exercise Score: \(self.exerciseScore)%")
                        .foregroundColor(lightPink)
                        .font(.headline)
                        .padding()
                    
                    Text("\(self.bodyPart) exercises")
                        .foregroundColor(lightWhite)
                        .font(.headline)
    
                    ForEach(recommendedExercises.prefix(5), id: \.self) { exercise in
                        Text("Exercise: \(exercise)")
                            .foregroundColor(lightWhite)
                    }
                }
//                .navigationBarTitle("PowerUp")
//                    .foregroundColor(lightWhite)
                .onAppear(perform: {
                    retrieveUserData()
                })
            )
    }

    private func retrieveUserData() {
        firstName = UserDefaults.standard.string(forKey: "firstName") ?? ""
        gender = UserDefaults.standard.integer(forKey: "selectedSex")
        eatOutFrequency = UserDefaults.standard.integer(forKey: "eatOutFrequency")
        veggieFrequency = UserDefaults.standard.integer(forKey: "veggieFrequency")
        foodCategory = UserDefaults.standard.string(forKey: "foodCategory") ?? ""
        workoutFrequency = UserDefaults.standard.integer(forKey: "workoutFrequency")
        bodyPart = UserDefaults.standard.string(forKey: "selectedPartOption") ?? ""
        activityLevel = UserDefaults.standard.string(forKey: "selectedTypeOption") ?? ""
        height = UserDefaults.standard.integer(forKey: "height")
        weight = UserDefaults.standard.integer(forKey: "weight")
        heartRate = UserDefaults.standard.integer(forKey: "heartRate")
        caloriesBurned = UserDefaults.standard.integer(forKey: "caloriesBurned")
        stepCount = UserDefaults.standard.integer(forKey: "stepCount")
        avgSleepDuration = UserDefaults.standard.integer(forKey: "avgSleepDuration")
        workoutIntensity = activityLevelToIntensity[activityLevel] ?? 0
    }

    private func requestAllScoreData() {
        // Create the base URL
        var urlComponents = URLComponents(string: "https://power-up-backend.vercel.app/api/score/all")

        // Add the query items (URL parameters)
        urlComponents?.queryItems = [
            URLQueryItem(name: "gender", value: String(gender)),
            URLQueryItem(name: "height", value: String(height)),
            URLQueryItem(name: "weight", value: String(weight)),
            URLQueryItem(name: "heart_rate", value: String(heartRate)),
            URLQueryItem(name: "active_calories", value: String(caloriesBurned)),
            URLQueryItem(name: "steps", value: String(stepCount)),
            URLQueryItem(name: "average_sleep_hours", value: String(avgSleepDuration)),
            URLQueryItem(name: "times_eating_out", value: String(eatOutFrequency)),
            URLQueryItem(name: "times_eating_vegetables", value: String(veggieFrequency)),
            URLQueryItem(name: "workouts_per_week", value: String(workoutFrequency)),
            URLQueryItem(name: "workout_intensity", value: String(workoutIntensity))
        ]

        // Create the URL from the URLComponents
        guard let url = urlComponents?.url else {
            // Handle invalid URL
            return
        }

        // Create the request
        let request = URLRequest(url: url)

        // Create the URLSession
        let session = URLSession.shared

        // Create the data task
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            // Check if response is valid HTTPURLResponse and status code is 200 (OK)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Parse the JSON data
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonDict = json as? [String: Any] {
                            // Access the scores from the JSON response
                            if let dietScore = jsonDict["diet_score"] as? Double,
                                let exerciseScore = jsonDict["exercise_score"] as? Double,
                                let fitnessScore = jsonDict["fitness_score"] as? Double,
                                let healthScore = jsonDict["health_score"] as? Double,
                                let overallScore = jsonDict["overall_score"] as? Double,
                                let sleepScore = jsonDict["sleep_score"] as? Double {
                                // Use the scores as needed
                                print("Diet Score: \(dietScore)")
                                print("Exercise Score: \(exerciseScore)")
                                print("Fitness Score: \(fitnessScore)")
                                print("Health Score: \(healthScore)")
                                print("Overall Score: \(overallScore)")
                                print("Sleep Score: \(sleepScore)")
                                
                                self.overallScore = Int(overallScore)
                                self.dietScore = Int(dietScore * 100)
                                self.exerciseScore = Int(exerciseScore * 100)
                                self.sleepScore = Int(sleepScore * 100)
                                
                                print("Diet Score: \(self.dietScore)")
                                print("Exercise Score: \(self.exerciseScore)")
                                print("Overall Score: \(self.overallScore)")
                                print("Sleep Score: \(self.sleepScore)")
                                
                                getSleepRecommendationData()
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            } else {
                print("Invalid HTTP response")
            }
        }

        // Start the task
        task.resume()
        
    }
    
    private func getSleepRecommendationData() {
        if self.sleepScore > 50 {
            self.recommendedSleep = "You are getting sufficient sleep!"
        } else {
            var hoursToSleep = 0.0
            if (gender == 1) {
                print("AVG SLEEP DURATION")
                print(Double(self.avgSleepDuration))
                hoursToSleep = abs(9.0 - Double(self.avgSleepDuration))
            } else {
                hoursToSleep = abs(8.5 - Double(self.avgSleepDuration))
            }
            self.recommendedSleep = "You are not getting enough sleep. Sleep \(hoursToSleep) more hours/night"
        }
        
    }
    
    private func requestExerciseRecommendationData(){
        print("GETTING EXERCISE RECS")
        let exerciseType = bodyPart.lowercased()


        // Create the base URL
        var urlComponents = URLComponents(string: "https://power-up-backend.vercel.app/api/exercise/\(exerciseType)")
        
        print("EXERCISE URL: \(urlComponents?.url)")

        // Create the URL from the URLComponents
        guard let url = urlComponents?.url else {
            // Handle invalid URL
            return
        }

        // Create the request
        let request = URLRequest(url: url)

        // Create the session and task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

            if let data = data {
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        for json in jsonArray {
                            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                        for json in jsonArray {
                                            if let bodyPart = json["BodyPart"] as? String,
                                               let description = json["Desc"] as? String,
                                               let equipment = json["Equipment"] as? String,
                                               let title = json["Title"] as? String {
                                                // Use the extracted values here
                                                print("Body Part: \(bodyPart)")
                                                print("Description: \(description)")
                                                print("Equipment: \(equipment)")
                                                print("Title: \(title)")
                                                DispatchQueue.main.async {
                                                    recommendedExercises.append(title)
                                                }
                                                print()
                                            }
                                        }
                                    }
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }
        task.resume()

    }
    
    private func requestFoodRecommendationData(){
        print("GETTING FOOD RECS")
        let foodType = foodCategory.lowercased()

        // Create the base URL
        var urlComponents = URLComponents(string: "https://power-up-backend.vercel.app/api/foods/\(foodType)")
        
        // Add the query items (URL parameters)
        urlComponents?.queryItems = [
            URLQueryItem(name: "min", value: "50"),
            URLQueryItem(name: "max", value: "100"),
        ]

        // Create the URL from the URLComponents
        guard let url = urlComponents?.url else {
            // Handle invalid URL
            return
        }

        // Create the request
        let request = URLRequest(url: url)

        // Create the session and task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

            if let data = data {
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        for json in jsonArray {
                            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                        for json in jsonArray {
                                            if let category = json["Category"] as? String,
                                               let description = json["Description"] as? String {
                                                // Use the extracted values here
                                                print("Category: \(category)")
                                                print("Description: \(description)")
                                                DispatchQueue.main.async {
                                                    recommendedFoods.append(description)
                                                }
                                                print()
                                            }
                                        }
                                    }
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }
        task.resume()

    }
}
