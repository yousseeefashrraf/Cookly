import Foundation

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
