import Foundation
import SwiftUI
class RecipesJSONData: Codable {
    var recipes: [Recipe]
    let total, skip, limit: Int
}

// MARK: - Recipe
struct Recipe: Codable {
    let id: Int
    let name: String
    let ingredients, instructions: [String]
    let prepTimeMinutes, cookTimeMinutes, servings: Int?
    let difficulty: Difficulty?
    let cuisine: String?
    let caloriesPerServing: Int?
    let tags: [String]?
    let userID: Int?
    let image: String?
    let rating: Double?
    let reviewCount: Int?
    let mealType: [String]?
    let isVegetarian: Bool?
}

enum Difficulty: String, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case unknown = "Unknown"
}

class RecipesViewModel: ObservableObject{
    @Published var recipes: RecipesJSONData? = nil
    
     init(){
        fetchJSON()
    }
  
    
    private func fetchJSON(){
        guard
            let url = URL(string: "https://dummyjson.com/recipes") else {
            print("URL is in wrong format")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
                print("Wrong URL")
                return
            }
            
            do {
                let jsonData = try JSONDecoder().decode(RecipesJSONData.self, from: data)
                 DispatchQueue.main.async{ [weak self] in
                     print("data decoded correctly")
                     self?.recipes = jsonData
                }
                
            } catch{
                print(error.localizedDescription)
                return
            }
            
        }
        .resume()
    }
}

enum DateMode {
    case fireDate, currentDate
}

class TimerManager: ObservableObject{
    let timer: Timer.TimerPublisher
    @Published var currentDate: Date
    @Published var fireDate: Date 
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return formatter
    }
    
    init(currentDate: Date, fireDate: Date) {
        self.timer = Timer.publish(every: 1.0, on: .main, in: .default)
        self.currentDate = currentDate
        self.fireDate = fireDate
    }
    
    func getIntervalSinceFiring() -> DateComponents{
        let calendar = Calendar.current
        let CurrentDateComponents = calendar.dateComponents([.hour, .minute, .second], from: currentDate)
        let FireDateComponents = calendar.dateComponents([.hour, .minute, .second], from: fireDate)
        
        let timeInterval = currentDate.timeIntervalSince1970 - fireDate.timeIntervalSince1970
        
        let hour: Int = Int(timeInterval) / (60*60)
        let min: Int = Int(timeInterval) / (60)
        let sec = Int(timeInterval) % 60
        
        var components = DateComponents(hour:hour, minute: min, second: sec)
        return components
    }
    
    func getTimeRemaining(cookingTimeMinutes cookingTime: Int) -> (minutes: Int, seconds: Int){
        
        
        
        guard let intervalMinutes = getIntervalSinceFiring().minute, let intervalSeconds = getIntervalSinceFiring().second else {
            return (0,0)
        }
        let intervalInSeconds = intervalMinutes * 60 + intervalSeconds
        let cookingTime = cookingTime * 60 
        
        let remainingTime = (minutes:   (cookingTime - intervalInSeconds) / 60
                             , seconds: (cookingTime - intervalInSeconds) % 60)
        
        return remainingTime
    }
    
    func timeGonePercentage(cookingTimeMinutes cookingTime: Int) -> Double{
        var currentTime = getIntervalSinceFiring()
        
        guard let minutes = currentTime.minute, let seconds = currentTime.second else {
            return 0
        }
        let gone = Double(minutes * 60 + seconds)
        let total = Double(cookingTime * 60)
        let percentage = gone / total
        
        return percentage
        
    }
}

class CookViewModel: ObservableObject{
    @Published var isShown = false
    @Published var timerManager: TimerManager? = nil

    
    init(){
        ShowIcon(after: 5.0)
    }
    
    func ShowIcon(after: CGFloat){
        Timer.scheduledTimer(withTimeInterval: after, repeats: false) { [weak self] t in
            withAnimation(.spring) {
                self?.isShown = true
            }
            
        }
    }
    
    func startCookingTimer(startingDate date: Date){
        timerManager = TimerManager(currentDate: .now, fireDate: date)
        }
    }

    
