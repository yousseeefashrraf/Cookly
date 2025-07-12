import SwiftUI
struct ScrollCalculator{
    static func getPercentage(containerProxy: GeometryProxy, ItemRect: CGRect, offset: CGFloat) -> CGFloat{
        
        let optimum = containerProxy.size.width * 0.85
        
        
        
        
        let currentItemPosition = abs(ItemRect.maxX)
        let percentage = currentItemPosition/optimum
        
        if(percentage > 1.1){
            return 0.8
        }
        
        return max(percentage,0.7)
        
    }
}



struct ViewsAndTimeView: View{
    var cookingTime: Int
    var prepTime: Int
    var reviews: Int
    
    var body: some View{
        
        HStack{
            let tags = [cookingTime, reviews]
            
            ForEach(tags, id: \.self){ tag in
                VStack(alignment: .leading){
                    let label = tag == cookingTime ? RecipesViewModel.fullMealTime(cookingTime: cookingTime, prepTime: prepTime) : "\(reviews)K"
                    
                    HStack{
                        
                        
                        Text(label)
                            .font(.system(.callout, design: .rounded))
                            .foregroundStyle(.white)
                        
                        
                        
                        
                        if(tag == reviews){
                            Image(systemName: "star.bubble")
                            
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .foregroundStyle(.white)
                            
                        }
                    }
                    .padding(7)
                    .padding(.horizontal, 2)
                    .overlay {
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.white, lineWidth: 1)
                            .opacity(0.9)
                        
                    }
                    
                }
                
                
            }
            
            
            
            
            
            
        }
    }
}

struct RecipesViewPrefrenceKey: PreferenceKey{
    static var defaultValue: [String : CGRect] = [:]
    
    static func reduce(value: inout [String: CGRect], nextValue: () -> [String: CGRect]) {
        value.merge(nextValue()) { $1 }
    }
    
}

struct TimerViewModelPrefrenceKey: PreferenceKey{
    static func reduce(value: inout Int?, nextValue: () -> Int?) {
        value = nextValue()
    }
    
    static var defaultValue: Int? = nil
    
    
    
}
struct RecipesTagsView: View{
    @ObservedObject var recipesViewModel: RecipesViewModel
    var body: some View{
        let tags = recipesViewModel.allFilters
        
        Text("Get cooking, \ntoday! 🥘")
            .font(.system(.title, design: .rounded))
            .bold()
            .padding(.leading,20)
        TagsView(items: tags){ tag, $isSelected in
            recipesViewModel.toggleFilter(tag: tag, isSelected: $isSelected)
            
            HapticFeedbackManager.manager.impact(style: .rigid)
            
        }
        
        onAppearAction: { tag, $isSelected in
            isSelected = recipesViewModel.appliedFilters.contains(tag)
            recipesViewModel.filteredRecipes = recipesViewModel.getFilteredRecipes()
        }
        .contentMargins(20)
    }
}

struct CardView: View{
    @Binding var allRects: [String:CGRect]
    @Binding var loadedRecipes: Set<String>
    let recipe: Recipe
    @ObservedObject var recipesViewModel: RecipesViewModel
    @ObservedObject var cookViewModel: CookViewModel

    var body: some View{
        let imgURL = URL(string:recipe.image ?? "")
        let proxy = allRects[recipe.name] ?? .zero
        
        AsyncImage(url: imgURL) { img in
            
            ZStack(alignment: .topLeading) {
                img
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.width)
                    .onAppear{
                        loadedRecipes.insert(recipe.name)
                    }
                LinearGradient(topLeadingBottomTrailingOf: [.clear, .clear, .black, .black])
                    .opacity(0.6)
                
               
                    VStack(alignment: .leading, spacing: 15){
                        
                        Text(recipe.name)
                            .font(.system(.title2, design: .rounded))
                            .bold()
                        
                            .lineLimit(2, reservesSpace: true)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.white)
                            .frame(maxWidth: 200, alignment: .leading)
                        
                        
                        ViewsAndTimeView(cookingTime: recipe.cookTimeMinutes ?? 0, prepTime: recipe.prepTimeMinutes ?? 0, reviews: recipe.reviewCount ?? 0)
                        
                        
                    }
                    .offset(y: proxy.height * 0.70)
                    .padding(.leading, 15)
                    
                
                
            }
            .overlay {
                PhaseAnimator([[Color.lightGreen, Color.green],[Color.green,Color.lightGreen]]){ color in
                    
                    let showBorder = (recipesViewModel.currentRecipe != nil && recipe == recipesViewModel.currentRecipe && (cookViewModel.timerManager != nil))
                    
                    RoundedRectangle(cornerRadius: 50)
                        .stroke ( showBorder ? LinearGradient(topLeadingBottomTrailingOf: color) : LinearGradient(topLeadingBottomTrailingOf: [.clear]) , lineWidth: 10)
                        .animation(.easeInOut(duration: 2))
                }
            }
            
            
        } placeholder: {
            PhaseAnimator([0.4, 0.2]){ opacity in
                VStack(alignment: .leading, spacing:opacity * 25 ){
                    Spacer()
                    
                    let widths = [proxy.width * 0.5, proxy.width * 0.6, proxy.width * 0.10]
                    
                    
                    ForEach(widths, id: \.self) { width in
                        RoundedRectangle(cornerRadius: 50)
                            .fill(.white)
                            .frame(width: width, height: 25, alignment: .leading)
                        
                            .opacity(1-opacity)
                        
                    }
                    
                    
                }
                .padding(.bottom, 40)
                .frame(width: proxy.width * 0.9, alignment: .leading)
                .padding(.leading, 15)
                .offset(y: -opacity * 50)
                .background(.gray)
                .opacity(opacity)
            }
        }
        
    }
}

struct RecipesViewScrollView: View{
    var proxy: GeometryProxy
    var content: [Recipe]
    var contentMargin: CGFloat
    @State var allRects: [String:CGRect] = [:]
    @State var loadedRecipes: Set<String> = []
    @ObservedObject var recipesViewModel: RecipesViewModel
    @ObservedObject var cookViewModel: CookViewModel
    
    
    
    var body: some View{
        ScrollView(.horizontal){
            LazyHStack(spacing: 10){
                ForEach(content, id: \.name) { recipe in
                    let widthPercentage = 0.80
                    let itemRect = allRects[recipe.name] ?? .zero
                    VStack{
                        var cardView: AnyView = AnyView(
                            VStack{
                                
                                
                                let offset = proxy.size.width -  proxy.size.width * (1-widthPercentage)
                                
                                let percentage = ScrollCalculator.getPercentage(containerProxy: proxy, ItemRect: itemRect, offset:  offset)
                                
                                
                                
                                CardView(allRects: $allRects, loadedRecipes: $loadedRecipes,recipe: recipe, recipesViewModel: recipesViewModel, cookViewModel: cookViewModel)
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                    .scaleEffect(x: percentage, y: percentage)
                                    .scrollTargetLayout()
                                
                            }
                        )
                        
                        if (loadedRecipes.contains(recipe.name)){
                            NavigationLink(value: recipe) { cardView }
                        } else { cardView }
                        
                        
                    }
                    .frame(width: proxy.size.width * widthPercentage, height: proxy.size.height * 0.9)
                    
                    
                    .background {
                        GeometryReader { item in
                            Color.clear
                                .preference(
                                    key: RecipesViewPrefrenceKey.self,
                                    value: [recipe.name: item.frame(in: .named("scrollSpace"))]
                                )
                        }
                    }
                }
            }
            .onPreferenceChange(RecipesViewPrefrenceKey.self) { value in
                allRects = value
            }
        }
        
        
        .contentMargins(contentMargin)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
    }
}


struct RecipesView: View {
    @ObservedObject var recipesViewModel: RecipesViewModel
    @ObservedObject var cookViewModel: CookViewModel
    @Binding var isSheetUp: Bool
    @Binding var countdown: (minutes: Int, seconds: Int)?
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 0){
                let content = recipesViewModel.filteredRecipes
                
                RecipesTagsView(recipesViewModel: recipesViewModel)
                
                let contentMargin = 35.0
                
                GeometryReader{ proxy in
                    RecipesViewScrollView(proxy: proxy, content: content, contentMargin: contentMargin, recipesViewModel: recipesViewModel, cookViewModel: cookViewModel)
                    
                    
                }
                .frame(height: 550)
                .coordinateSpace(name: "scrollSpace")
                .animation(.bouncy)
                Spacer()
            }
            .onAppear{
                if(cookViewModel.timerManager == nil){
                    recipesViewModel.currentRecipe = nil
                    cookViewModel.isShown = false
                    cookViewModel.invalidated = true
                }
                
                
            }
            
            
            .padding(.top, 40)
            .navigationDestination(for: Recipe.self){ recipe in
                RecipeView(recipesViewModel: recipesViewModel, recipe: recipe, isSheetUp: $isSheetUp, cookViewModel: cookViewModel, countdown: $countdown)
            }
            .accentColor(.red)
        }
        .tint(.darkGreen)
      
        
        
    }
}


struct AppStarterMainView: View{
    @State var isSheetUp = false
    @ObservedObject var recipesViewModel = RecipesViewModel()
    @State var screenWidth: CGFloat = 0.0
    @State private var didTimerStop = false
    @ObservedObject var cookViewModel = CookViewModel()
    @State var countdown: (minutes: Int, seconds: Int)? = (0,0)
    var body: some View{
        
        GeometryReader{ proxy in
            
            ZStack(alignment: .bottomTrailing){
                
                RecipesView(recipesViewModel: recipesViewModel, cookViewModel: cookViewModel, isSheetUp: $isSheetUp, countdown: $countdown)
                BubbleView(isSheetUp: $isSheetUp, cookViewModel: cookViewModel, screenSize: proxy.size, recipesViewModel: recipesViewModel)
                
                if cookViewModel.timerManager != nil{
                    SubscriberView(timerManager: cookViewModel.timerManager!, cookViewModel: cookViewModel,countDown: $countdown, cookingTime: recipesViewModel.currentRecipe?.cookTimeMinutes ?? 0)
                }
                
            }
            .onAppear{
                screenWidth = proxy.size.width/3
            }
            
        }
        .onAppear{
            if(cookViewModel.timerManager == nil){
                cookViewModel.isShown = false
                countdown = (0,0)
                didTimerStop = false
                cookViewModel.timerManager = nil
                
            }
        }
        .sheet(isPresented: $isSheetUp) {
            
            
            if(cookViewModel.timerManager != nil){
                SheetView(cookViewModel: cookViewModel, timerManager: cookViewModel.timerManager!, countDown: $countdown, screenWidth: $screenWidth, isSheetUp: $isSheetUp, imageUrl:recipesViewModel.currentRecipe?.image ?? "", cookingTime: recipesViewModel.currentRecipe?.cookTimeMinutes ?? 0)
            }
            
            
        }
        
        
    }
}
#Preview {
    AppStarterMainView()
}

