import SwiftUI

struct RecipeView: View {
    @ObservedObject var recipesViewModel: RecipesViewModel
    var recipe: Recipe
    @Binding var isSheetUp: Bool
    @State var screenWidth: CGFloat = 0.0
    @State var scrollPosition: ScrollPosition = ScrollPosition()
    @ObservedObject var cookViewModel: CookViewModel
    @Binding var countdown: (minutes: Int, seconds: Int)?
    
    init(recipesViewModel: RecipesViewModel, recipe: Recipe, isSheetUp:Binding<Bool>, cookViewModel: CookViewModel, countdown: Binding<(minutes: Int, seconds: Int)?>) {
        self._recipesViewModel =  ObservedObject(wrappedValue: recipesViewModel)
        self._countdown = countdown
        self.recipe = recipe
        self._isSheetUp = isSheetUp
        self._cookViewModel = ObservedObject(wrappedValue: cookViewModel)
        
       
    }
    
    var body: some View {
        

        
        GeometryReader { proxy in
            Color.clear
                .onAppear{
                    screenWidth = proxy.size.width/3
                }
            
            ZStack(alignment: .bottomTrailing){
                
           
                
                
            ScrollView(.vertical) {
                RecipeContent(proxy: proxy, recipesViewModel: recipesViewModel, recipe: recipe, scrollPosition: $scrollPosition)
                    .frame(width: proxy.size.width)
            }
            .scrollClipDisabled(true)
            .scrollIndicators(.hidden)
            .ignoresSafeArea()
            .scrollPosition($scrollPosition)
            .padding(.top, 40)
                
                
                  
        }
           
    }
        .onAppear {
            if(!cookViewModel.isShown){
                cookViewModel.ShowIcon(after: 15)
                recipesViewModel.currentRecipe = recipe
                cookViewModel.invalidated = false
            }
        }
    }
}

struct ImageView: View{
    var imgURL: URL
    var proxy: GeometryProxy
    var widthPercentage: CGFloat
    var caloriesPerServing: Int
    var body: some View{
        AsyncImage(url: imgURL) { img in
            ZStack(alignment: .topTrailing) {
                img
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width * (widthPercentage))
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 35))

                Text("\(caloriesPerServing) Cal. Per Serving")
                    .font(.system(.caption2, design: .rounded, weight: .semibold))
                    .padding(10)
                    .background(.white)
                    .foregroundStyle(LinearGradient(colors: [.black, .gray, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .overlay {
                        RoundedRectangle(cornerRadius: 50).stroke()
                    }
                    .padding(-15)
            }
        } placeholder: {
            ProgressView()
                .frame(width: proxy.size.width * (widthPercentage + 0.1), height: proxy.size.height * 0.27)
                .scaleEffect(x: 2, y: 2)
        }
    }
}

struct TitleGradientView: View{
    var title: String
    var proxy: GeometryProxy
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // Recipe Title with Gradient
            Text(title)
                .font(.system(.title, design: .rounded, weight: .semibold))
                .frame(width: proxy.size.width * 0.87, alignment: .leading)
                .lineLimit(4)
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.leading)
                .lineSpacing(2)
                .overlay {
                    LinearGradient(colors: [.black, .gray, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                }
                .mask {
                    Text(title)
                        .font(.system(.title, design: .rounded, weight: .semibold))
                        .frame(width: proxy.size.width * 0.87, alignment: .leading)
                        .lineLimit(4)
                        .minimumScaleFactor(0.8)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(2)
                }
            
        }
    }
}

struct RecipeContent: View {
    let proxy: GeometryProxy
    @ObservedObject var recipesViewModel: RecipesViewModel
    var recipe: Recipe
    @Binding var  scrollPosition: ScrollPosition
    var body: some View {
        let widthPercentage = 0.9

        VStack{
            
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .center, spacing: 10) {
                    
                    // Recipe Title with Gradient
                    TitleGradientView(title: recipe.name, proxy: proxy)
                        .padding(.horizontal, 30)
                    // Tags
                    let mealTypes = recipe.mealType ?? []
                    let tags = recipe.tags ?? []
                    if mealTypes.count > tags.count {
                        TagsView(items: mealTypes)
                            .padding(.leading, 20)
                        
                        TagsView(items: tags)
                            .padding(.leading, 20)
                    } else {
                        TagsView(items: tags)
                            .padding(.leading, 20)
                        TagsView(items: mealTypes)
                            .padding(.leading, 20)
                    }
                    
                    // Image
                    if let imgURL = URL(string: recipe.image ?? "") {
                        ImageView(imgURL: imgURL, proxy: proxy, widthPercentage: widthPercentage, caloriesPerServing: recipe.caloriesPerServing ?? 0)
                            .padding(.top, 20)
                    }
                    
                }
                
                // Review and Difficulty
                HStack {
                    ReviewView(stars: recipe.rating ?? 0)
                    
                    Spacer()
                    if let difficulty = recipe.difficulty?.rawValue {
                        (Text("Difficulty: ") + Text(difficulty).bold())
                            .font(.system(.callout, design: .rounded))
                    }
                }
                .padding(.horizontal, 30)
                // Cuisine
                Text(recipe.cuisine ?? "Not available")
                    .font(.system(.callout, design: .rounded))
                    .bold()
                    .padding(.horizontal, 30)
                
                HStack(alignment: .top) {
                    VStack {
                        Text("Servings").font(.system(.title3, design: .rounded, weight: .medium))
                        Text("\(recipe.servings ?? 0)")
                            .font(.system(.callout, design: .rounded, weight: .medium))
                            .opacity(0.8)
                    }
                    Spacer()
                    VStack {
                        Text("Preparation").font(.system(.title3, design: .rounded, weight: .medium))
                        Text("\(recipe.prepTimeMinutes ?? 0) Mins")
                            .font(.system(.callout, design: .rounded, weight: .medium))
                            .opacity(0.8)
                    }
                    Spacer()
                    VStack {
                        Text("Cook").font(.system(.title3, design: .rounded, weight: .medium))
                        Text("\(recipe.cookTimeMinutes ?? 0) Mins")
                            .font(.system(.callout, design: .rounded, weight: .medium))
                            .opacity(0.8)
                    }
                    
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 30)
                .overlay {
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 25, topTrailing: 25))
                        .stroke(.gray, lineWidth: 2)
                        .opacity(0.2)
                }
            }
            
            // Ingredients and Instructions
            IngredientsView(ingrediants: recipe.ingredients ?? [], scrollPosition: $scrollPosition)
                .padding(.top, -30)

            InstructionsView(instructions: recipe.instructions ?? [], scrollPosition: $scrollPosition)
                .padding(.top, -40)
        }
        .navigationTitle(recipe.name ?? "Recipe")
        .navigationBarTitleDisplayMode(.inline)

        
        
        
          
        }
    }




#Preview {

//    RecipeView(recipesViewModel: RecipesViewModel(), recipe: RecipesViewModel().networkManager.jsonData?.recipes[0] ?? Recipe(id: 5, name: "New", ingredients: [], instructions: [], prepTimeMinutes: 10, cookTimeMinutes: 10, servings: 10, difficulty: .easy, cuisine: nil, caloriesPerServing: 89, tags: nil, userID: 5, image: "", rating: 4.54, reviewCount: 5, mealType: [], isVegetarian: true), isSheetUp: .constant(false), cookViewModel: CookViewModel())
}
