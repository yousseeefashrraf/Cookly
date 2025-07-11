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
    
    func fetchRecipes() {
        Self.fetchJSON(errorHandler: APIFetchingError.handleError)
    }
    
    static private func fetchJSON(errorHandler: @escaping (Error) -> Void){
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
            
        }
        .resume()
    }
    
}

class RecipesViewModel: ObservableObject{
    @Published var networkManager = NetworkManager.networkManager
    
    init(){
        networkManager.fetchRecipes()
    }
    
}
