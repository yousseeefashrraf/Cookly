import SwiftUI

enum APIFetchingError: Error{
    case wrongURLFormat
    case badStatusCode
    case incorrectJsonDecoding
    
    static func handleError(error: Error) -> Void{
        
        switch error {
        case APIFetchingError.wrongURLFormat:
            print("URL is in wrong format")
            
        case APIFetchingError.badStatusCode:
            print("Unsecssesful fetching due to web problems")
            
        case APIFetchingError.incorrectJsonDecoding:
            print("incorrect Json Decoding")
        default:
            print("Unknown error")
        }
        
    }
}

class NetworkManager: ObservableObject{
    @Published var jsonData: RecipesJSONData? = nil
    static var networkManager = NetworkManager()
    
    
    private init(){
    }
    
    func fetchRecipes(completionHandler: @escaping ()->()) {
        Self.fetchJSON(errorHandler: APIFetchingError.handleError, completionHandler: completionHandler)
    }
    
    static private func fetchJSON(errorHandler: @escaping (Error) -> Void, completionHandler: @escaping ()->()){
        guard
            let url = URL(string: "https://dummyjson.com/recipes") else {
            errorHandler(APIFetchingError.wrongURLFormat)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data else {
                errorHandler(APIFetchingError.badStatusCode)
                return
            }
            
            do {
                let jsonData = try JSONDecoder().decode(RecipesJSONData.self, from: data)
                DispatchQueue.main.async{
                    NetworkManager.networkManager.jsonData = jsonData
                }
                
            } catch{
                errorHandler(APIFetchingError.incorrectJsonDecoding)
            }
            
            DispatchQueue.main.async{
                completionHandler()
            }
            
            
            
        }
        .resume()
    }
    
}

class RecipesViewModel: ObservableObject{
    @Published var networkManager = NetworkManager.networkManager
    @Published var appliedFilters: [String] = ["All"]
    @Published var isLoading = true
    @Published var allFilters: [String] = ["All"]
    @Published var filteredRecipes: [Recipe] = []
    @Published var currentRecipe: Recipe? = nil

    init(){
        self.networkManager.fetchRecipes{ [weak self] in
            self?.allFilters.append(contentsOf: self?.getAllFilters() ?? [])
            self?.isLoading = false
        }
        
        
        
    }
    
    func getAllFilters() -> [String]{
        var filters: [String] = []
        
        guard let recipes = networkManager.jsonData?.recipes else { return [] }
        
        for recipe in recipes {
            
            
            if let tags = recipe.tags{
                var newFilters =  tags.filter { item in
                    !filters.contains(item)
                }
                
                filters.append(contentsOf: newFilters)
                
                
            }
            
            if let mealType = recipe.mealType {
                
                var newFilters =  mealType.filter { item in
                    !filters.contains(item)
                }
                
                filters.append(contentsOf: newFilters)
                
            }
            
            if let cuisine = recipe.cuisine{
                if(!filters.contains(cuisine)){
                    filters.append(cuisine)
                }
                
            }
            
        }
        
        print(filters)
        return filters
    }
    
    func getFilteredRecipes() -> [Recipe]{
        var filtered: [Recipe] = []
        guard let recipes = networkManager.jsonData?.recipes else {
            return []
        }
        
        guard !appliedFilters.contains("All") else{
            return networkManager.jsonData?.recipes ?? []
        }
        filtered = recipes.filter({ recipe in
            
            let containesATag = recipe.tags?.map{
                return appliedFilters.contains($0)
            }
            let containesAMeal = recipe.mealType?.map {
                return appliedFilters.contains($0)
            }
            let containesACusine = appliedFilters.contains(recipe.cuisine ?? "")
            
            
            return (containesATag?.contains(true) ?? false) || (containesAMeal?.contains(true) ?? false) || containesACusine
        })
        
        return filtered
    }
    
    func toggleFilter(tag: String, isSelected: Binding<Bool> ){
        
        if(appliedFilters.contains(tag)){
            appliedFilters =  appliedFilters.filter { item in
                item != tag
                
            }
            isSelected.wrappedValue = false
        } else {
            appliedFilters.append(tag)
            isSelected.wrappedValue = true
        }
        
        filteredRecipes = getFilteredRecipes()
    }
    
    static func fullMealTime(cookingTime: Int, prepTime: Int ) -> LocalizedStringKey{
        
        
        
        let totalTime = cookingTime + prepTime
        let isJustMinutes = Int(totalTime / 60) == 0

        
        return (isJustMinutes ? "^[\(totalTime) Minute](inflect: true)" : (totalTime % 60 != 0) ? "^[\(totalTime/60) Hour](inflect: true) ^[\(totalTime % 60) Minute](inflect: true)" : "^[\(totalTime/60) Hour]")
    }
}
