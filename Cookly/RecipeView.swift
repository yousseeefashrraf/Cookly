import SwiftUI

struct StarsView: View{
    var body: some View {
        HStack(spacing: 3){
            ForEach(0..<5) { index in
                Image(systemName: "star.fill")
                
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundStyle(.gray)
            }
        }
    }
}
struct ReviewView: View{
    var stars: CGFloat = 0.0
    var body: some View {
        HStack(alignment: .center){
            
           
     
            GeometryReader { proxy in
                ZStack(alignment: .leading){
                
                StarsView()
                    Rectangle()
                        .fill(.yellow)
                        
                        .frame(width: (proxy.size.width + 1.5) * (stars/5))
                       
                        
                    
                }
                .frame(width: 20 * 5 + 3 * 4,height: 20)
                .mask(StarsView())

            }
            }
            .frame(width: 20 * 5 + 3 * 4,height: 20)
            Text("\(String(format: "%.1f", stars))")
                .font(.system(.subheadline, design: .monospaced))

            
        

    }
}


struct RecipeView: View {
    @ObservedObject var recipesViewModel = RecipesViewModel()
    var index: Int = 10
    @State var scrollPosition: ScrollPosition = ScrollPosition()
    var body: some View {
        GeometryReader { proxy in
            
            ZStack(alignment: .bottomTrailing){
                
           
                
                
            ScrollView(.vertical) {
                RecipeContent(proxy: proxy, recipesViewModel: recipesViewModel, index: index, scrollPosition: $scrollPosition)
                    .frame(width: proxy.size.width)
            }
            .scrollClipDisabled(true)
            .scrollIndicators(.hidden)
            .ignoresSafeArea()
            .scrollPosition($scrollPosition)
            .padding(.top, 40)
                
            CookView(maxWidth: (proxy.size.width * 0.1))
                  
        }
    }
    }
}

struct RecipeContent: View {
    let proxy: GeometryProxy
    @ObservedObject var recipesViewModel: RecipesViewModel
    var index: Int
    @Binding var  scrollPosition: ScrollPosition
    var body: some View {
        let widthPercentage = 0.9
        let recipe = recipesViewModel.recipes?.recipes[index]

        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {

                // Recipe Title with Gradient
                Text(recipe?.name ?? "Not available")
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
                        Text(recipe?.name ?? "Not available")
                            .font(.system(.title, design: .rounded, weight: .semibold))
                            .frame(width: proxy.size.width * 0.87, alignment: .leading)
                            .lineLimit(4)
                            .minimumScaleFactor(0.8)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(2)
                    }

                // Tags
                let mealTypes = recipe?.mealType ?? []
                let tags = recipe?.tags ?? []
                if mealTypes.count > tags.count {
                    TagsView(items: mealTypes)
                    TagsView(items: tags)
                } else {
                    TagsView(items: tags)
                    TagsView(items: mealTypes)
                }

                // Image
                if let imgURL = URL(string: recipe?.image ?? "") {
                    AsyncImage(url: imgURL) { img in
                        ZStack(alignment: .topTrailing) {
                            img
                                .resizable()
                                .scaledToFill()
                                .frame(width: proxy.size.width * widthPercentage)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 35))

                            Text("\(recipe?.caloriesPerServing ?? 0) Cal. Per Serving")
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

                // Review and Difficulty
                HStack {
                    ReviewView(stars: recipe?.rating ?? 0)
                    Spacer()
                    if let difficulty = recipe?.difficulty?.rawValue {
                        (Text("Difficulty: ") + Text(difficulty).bold())
                            .font(.system(.callout, design: .rounded))
                    }
                }
                .padding(.top, 10)

                // Cuisine
                Text(recipe?.cuisine ?? "Not available")
                    .font(.system(.callout, design: .rounded))
                    .bold()
            }
            .frame(width: proxy.size.width * widthPercentage, alignment: .leading)
            .offset(x: proxy.frame(in: .local).midX - proxy.size.width * widthPercentage / 2)
            .padding(.top, 30)

            // Stats
            HStack(alignment: .top) {
                VStack {
                    Text("Servings").font(.system(.title3, design: .rounded, weight: .medium))
                    Text("\(recipe?.servings ?? 0)")
                        .font(.system(.callout, design: .rounded, weight: .medium))
                        .opacity(0.8)
                }
                Spacer()
                VStack {
                    Text("Preparation").font(.system(.title3, design: .rounded, weight: .medium))
                    Text("\(recipe?.prepTimeMinutes ?? 0) Mins")
                        .font(.system(.callout, design: .rounded, weight: .medium))
                        .opacity(0.8)
                }
                Spacer()
                VStack {
                    Text("Cook").font(.system(.title3, design: .rounded, weight: .medium))
                    Text("\(recipe?.cookTimeMinutes ?? 0) Mins")
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

            // Ingredients and Instructions
            IngrediantsView(ingrediants: recipe?.ingredients ?? [], scrollPosition: $scrollPosition)
                .padding(.top, -30)

            InstructionsView(scrollPosition: $scrollPosition, instructions: recipe?.instructions ?? [])
                .padding(.top, -40)
        }
    }
}

struct CookView: View{
    @State var width = 65.0
    @State var isSheetUp = false
    var maxWidth = 0.0
    @StateObject var cookViewModel = CookViewModel()
    var body: some View{
        if (cookViewModel.isShown) {
            VStack{
                
                
                let gradient =
                LinearGradient(colors: [.red, .gray, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                
                let frames = [1 :
                                LinearGradient(colors: [.red, .gray, .blue], startPoint: .topLeading, endPoint: .bottomTrailing), 2 :  LinearGradient(colors: [.blue, .gray, .red], startPoint: .topLeading, endPoint: .bottomTrailing),
                              3 : LinearGradient(colors: [.black, .gray, .black], startPoint: .topLeading, endPoint: .bottomTrailing)]
                
                PhaseAnimator(frames.keys) { eq in
                    Image(systemName: "timer")
                        .resizable()
                        .scaledToFit()
                        .padding(15)
                        .background(.white)
                        .clipShape(.circle)
                        .overlay {
                            
                            Circle()
                                .fill(frames[eq] ?? gradient)
                                .frame(width: width + 5)
                            
                            
                                .mask {
                                    Circle().stroke()
                                        .padding(2)
                                }
                        }
                        .foregroundStyle(eq == 1 ? .gray : .black)
                } animation: { _ in
                        .bouncy.delay(1)
                }
                
                
            }
            
            
            
            
            .frame(width: width)
            .padding(10)
            .offset(y: 20)
        }
    }
}

struct IngrediantsView: View {
    @State var isSheetUp = false
    var ingrediants: [String] = []
    @Binding var scrollPosition: ScrollPosition
    var body: some View{
        VStack(alignment: .leading){
            HStack(alignment: .center){
                Text("Ingredients")
                    .font(.system(.title2, design: .rounded,weight: .semibold))
                Spacer()
                Image(systemName: isSheetUp ? "chevron.up" : "chevron.down")
                    .frame(width: 30)
                    .frame(width: 50, height: 50)
                    .background(Color("lightGreen"))
                    .onTapGesture {
                        withAnimation(.interactiveSpring) {
                            isSheetUp.toggle()
                            
                            if(isSheetUp){
                                scrollPosition.scrollTo(y: scrollPosition.point?.y ?? 0.0 + 800)
                            } else {
                                scrollPosition.scrollTo(id: "ingrediantsSection")

                            }
                        }
                        
                    }
            }
            
                
                
                if(!ingrediants.isEmpty && isSheetUp){
                VStack(alignment: .leading){
                    ForEach(ingrediants, id: \String.self){ item in
                        HStack(alignment: .center){
                            Image(systemName: "smallcircle.filled.circle")
                            Text(item)
                                .font(.system(.title3, design: .rounded,weight: .light))
                        }
                         
                          
                    }
                }
                .id("ingrediantsSection")

            
            }
            
           
        }
       
        .frame(maxWidth: .infinity)
        .padding(25)
        .padding(.bottom, 17)
        .background(Color("lightGreen"))
        .clipShape(
            RoundedRectangle(cornerRadius: 25)
        )
        
    }
}

struct InstructionsView: View {
    @State var isSheetUp = false
    @Binding var scrollPosition: ScrollPosition
    var instructions: [String] = []
    var body: some View{
        VStack(alignment: .leading){
            HStack(alignment: .center){
                Text("Instructions")
                    .font(.system(.title2, design: .rounded,weight: .semibold))
                Spacer()
                Image(systemName: isSheetUp ? "chevron.up" : "chevron.down")
                    .frame(width: 30)
                    .frame(width: 50, height: 50)
                    .background(Color("darkGreen"))
                    .onTapGesture {
                        withAnimation(.interactiveSpring) {
                            isSheetUp.toggle()
                            
                            if(isSheetUp){
                                scrollPosition.scrollTo(id: "InstructionsSection")
                            }
                        }
                        
                    }
            }
            
                
                
                if(!instructions.isEmpty && isSheetUp){
                VStack(alignment: .leading){
                    ForEach(instructions, id: \String.self){ item in
                        HStack(alignment: .center){
                            Image(systemName: "smallcircle.filled.circle")
                            Text(item)
                                .font(.system(.title3, design: .rounded,weight: .light))
                        }
                         
                          
                    }
                }
                .id("InstructionsSection")
            
            }
            
           
        }
        .frame(maxWidth: .infinity)
        .padding(25)
        .background(Color("darkGreen"))
        .clipShape(
            RoundedRectangle(cornerRadius: 25)
        )    }
}

struct SheetView: View {
    @ObservedObject var cookViewModel: CookViewModel
    @State var countDown: (minutes: Int, seconds: Int)? = nil
    @State var percentage = 0.0
    @State var panFrameCount = 0
    var cookingTime = 1
    var body: some View {
        VStack{
            VStack{
                Text("Cooking..")
                    .font(.system(.largeTitle,design: .rounded))
                    .bold()
                
                VStack(alignment: .center, spacing: -10){
                    
               
                Image(systemName: "flame")
                    
                    .resizable()
                    .scaledToFit()
                    
                    .foregroundStyle(panFrameCount.isMultiple(of: 5) ? .gray : .orange)
                    .scaleEffect(x: panFrameCount.isMultiple(of: 5) ? 1.1 : 1 , y:panFrameCount.isMultiple(of: 5) ? 1.1 : 1)
                    .frame(width: 50)
                    .padding(.leading, -15)
                    
                Image(systemName: panFrameCount.isMultiple(of: 2) ? "frying.pan" : "frying.pan.fill")
                    
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(x: panFrameCount.isMultiple(of: 3) ? 1.1 : 1 , y:panFrameCount.isMultiple(of: 3) ? 1.1 : 1)
                    .frame(width: 150)
                    .foregroundStyle(panFrameCount.isMultiple(of: 3) ? .gray : .black)
            }
            }
                .padding(.top, 50)
             
            if let timeManager = cookViewModel.timerManager, let countDown {
              
                    GeometryReader{ proxy in
                        let width = proxy.size.width * 0.3
                        ZStack{
                            HStack(spacing: 0){
                                Text("\(countDown.minutes<=9 ? "0" : "")\(countDown.minutes)")
                                    .lineLimit(1)
                                    .frame(width: width, alignment: .trailing)
                                Text(":")
                                Text("\(countDown.seconds<=9 ? "0" : "")\(countDown.seconds)")
                                    .lineLimit(1)
                                    .frame(width: width, alignment: .leading)
                            }
                            .frame(width: proxy.size.width * 0.67, height: proxy.size.width * 0.67)
                            .overlay(content: {
                                Circle()
                                    .stroke(.gray, lineWidth: 7)
                                    
                            })
                            
                            Color(.systemGray5)
                                .frame(width: proxy.size.width * 0.67, height: proxy.size.width * 0.67)
                                .mask {
                                    Circle()
                                        .stroke(.gray, lineWidth: 7)
                                    
                                }
                            
                            Circle()
                                .trim(from: 0.0, to: percentage)
                                .stroke(style: .init(lineWidth: 13, lineCap: .round))
                                .foregroundStyle(.darkGreen)
                                .frame(width: proxy.size.width * 0.67, height: proxy.size.width * 0.67)
                                .rotationEffect(.degrees(-90))
                            
                                
                            
                        }
                       
                        .font(.system(size: proxy.size.width * 0.15, design: .rounded))
                        .position(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY)
                        
                       
                    }
                   
            } else {
                
                
                Text("Start Your timer")
            }
           
                
            Button {
                cookViewModel.startCookingTimer(startingDate: .now)
            let _ = cookViewModel.timerManager?.timer.connect()
            } label: {
                Text("Click")
            }
            Spacer()
        }
        .padding(.top, 30)
        
        if let timerManager = cookViewModel.timerManager {
        VStack{
        }.onReceive(timerManager.timer) { date in
            withAnimation(.easeInOut(duration: 0.45)) {
                timerManager.currentDate = date
                percentage = timerManager.timeGonePercentage(cookingTimeMinutes: cookingTime)
                panFrameCount += 1
            }
            
            
            let time =
            
            timerManager.getTimeRemaining(cookingTimeMinutes: cookingTime)
            
            if(time.minutes * 60 + time.seconds <= 0){
                cookViewModel.timerManager = nil
                countDown = nil
               
            }
            
            countDown = time
            
            
            
            
        }
        
            
        }
        
        
        
    }
}
struct TagsView: View{
    let items: [String]

    var body: some View {
        ScrollView(.horizontal) {
            HStack(){
                ForEach(items, id: \String.self){ item in
                    Text(item)
                        .font(.system(.callout, design: .rounded, weight: .medium))
                        .opacity(1)
                        .padding(6)
                        .overlay {
                            RoundedRectangle(cornerRadius: 60)
                                .fill(LinearGradient(colors: [.red, .gray, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                               
                                .mask {
                                    RoundedRectangle(cornerRadius: 60)
                                        .stroke()
                                }
                                
                                
                        }
                       
                        
                }
            }

        }
        .scrollBounceBehavior(.basedOnSize)
        .padding(.leading, 10)
    }
}
#Preview {
//    RecipeView()
    
    SheetView(cookViewModel: CookViewModel())
}
