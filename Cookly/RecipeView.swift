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
    var index: Int = 19
    var width = 0
    var height = 0
    var body: some View {
      
       
            GeometryReader { proxy in
                ScrollView(.vertical){
                
                let widthPercentage = 0.9
                VStack(alignment: .leading,spacing: 0){
                    VStack(spacing: 0){
                        VStack(alignment: .leading){
                            ZStack(alignment: .leading){
                               
                                VStack{
                                    Text("\(recipesViewModel.recipes?.recipes[index].name ?? "Not avilable")")
                                        .font(.system(.title, design: .rounded,weight: .semibold))
                                        .frame(width: proxy.size.width * 0.87, alignment: .leading)
                                        .lineLimit(4)
                                        .minimumScaleFactor(0.8)
                                        .multilineTextAlignment(.leading)
                                        .lineSpacing(2)
                                        .overlay {
                                            LinearGradient(colors: [.black, .gray, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        }
                                    
                                }
                        
                            }
                            .mask {
                                Text("\(recipesViewModel.recipes?.recipes[index].name ?? "Not avilable")")
                                    .font(.system(.title, design: .rounded,weight: .semibold))
                                    .frame(width: proxy.size.width * 0.87, alignment: .leading)
                                    .lineLimit(4)
                                    .minimumScaleFactor(0.8)
                                    .multilineTextAlignment(.leading)
                                    .lineSpacing(2)
                                
                            }
                            
                            
                          
                            let mealTypesSize = recipesViewModel.recipes?.recipes[index].mealType?.count ?? 0
                            
                            let tagsSize = recipesViewModel.recipes?.recipes[index].tags?.count ?? 0
                                
                            if(mealTypesSize > tagsSize){
                                TagsView(items: recipesViewModel.recipes?.recipes[index].mealType ?? [])
                                    .frame(width: 500)
                                    .padding(.bottom, 10)
                                    .zIndex(90)
                                
                            
                                TagsView(items: recipesViewModel.recipes?.recipes[index].tags ?? [])
                                    .frame(width: 500)
                                    .padding(.bottom, 10)
                                    .zIndex(90)
                                
                            } else {
                                
                                TagsView(items: recipesViewModel.recipes?.recipes[index].tags ?? [])
                                        .frame(width: 500)
                                        .padding(.bottom, 2)
                                        .zIndex(90)
                                
                                TagsView(items: recipesViewModel.recipes?.recipes[index].mealType ?? [])
                                    .frame(width: 500)
                                    .padding(.bottom, 10)
                                    .zIndex(90)
                                
                            
                            }
                            
                           
                               
                           
                        if let imgURL = URL(string: recipesViewModel.recipes?.recipes[index].image ?? "") {
                            AsyncImage(url: imgURL) { img in
                                ZStack(alignment: .topTrailing){
                                   
                                    img
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: proxy.size.width * (widthPercentage), height: proxy.size.height  * 0.27)
                                        .clipped()
                                        .clipShape (
                                            RoundedRectangle(cornerRadius: 35)
                                        )
                                    Text("\(recipesViewModel.recipes?.recipes[index].caloriesPerServing ?? 0) Cal. Per Serving")
                                        .font(.system(.caption2, design: .rounded,weight: .semibold))
                                        .padding(10)
                                        .background(.white)
                                        .foregroundStyle( LinearGradient(colors: [.black, .gray, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 50)
                                                
                                        )
                                    
                                        .overlay{
                                            RoundedRectangle(cornerRadius: 50)
                                                .stroke()
                                        }
                                        .padding(-15)
                                }
                                
                            } placeholder: {
                                ProgressView()
                                    .frame(width: proxy.size.width * (widthPercentage + 0.1), height: proxy.size.height  * 0.27)
                                    .scaleEffect(x: 2, y: 2)
                            }
                        }
                        
                        VStack(alignment: .leading){
                            HStack{
                                ReviewView(stars: recipesViewModel.recipes?.recipes[index].rating ?? 0)
                                
                                Spacer()
                                if let difficulty =  (recipesViewModel.recipes?.recipes[index].difficulty?.rawValue) {
                                    Text("Difficulty: ")
                                        .font(.system(.callout, design: .rounded))
                                    +
                                    Text("\(difficulty)")
                                        .font(.system(.callout, design: .rounded))
                                        .bold()
                                    
                                    
                                }
                                
                                
                            }
                            .padding(.top, 10)
                            Text("\(recipesViewModel.recipes?.recipes[index].cuisine ?? "Not available")")
                                .font(.system(.callout, design: .rounded))
                                .bold()
                            
                            
                            
                        }
                        .padding(.horizontal, 10)
                        
                        
                        
                        
                        
                    }
                    .frame(width: proxy.size.width * widthPercentage, alignment: .leading )
                    .offset(x: proxy.frame(in: .local).midX - proxy.size.width * widthPercentage/2 )
                    .padding(.top, 30)
                }
                .padding(.top, 30)
                    
                   
                    VStack{
                        
                        VStack{
                            HStack(alignment: .top){
                                let fontPadding = 15.0

                                VStack(spacing: fontPadding){
                                    Text("Servings")
                                        .font(.system(.title3, design: .rounded, weight: .medium))
                                    Text("\(recipesViewModel.recipes?.recipes[index].servings ?? 0)")
                                        .font(.system(.callout, design: .rounded, weight: .medium))
                                        .opacity(0.8)


                                }
                                Spacer()
                                VStack(spacing: fontPadding){
                                    Text("Preparation")
                                        .font(.system(.title3, design: .rounded, weight: .medium))
                                    Text("\(recipesViewModel.recipes?.recipes[index].prepTimeMinutes ?? 0) Mins")
                                        .font(.system(.callout, design: .rounded, weight: .medium))
                                        .opacity(0.8)
                                }
                                Spacer()
                                VStack(spacing: fontPadding){
                                    Text("Cook")
                                        .font(.system(.title3, design: .rounded, weight: .medium))
                                    Text("\(recipesViewModel.recipes?.recipes[index].cookTimeMinutes ?? 0) Mins")
                                        .font(.system(.callout, design: .rounded, weight: .medium))
                                        .opacity(0.8)
                                }
                            }
                            .padding(25)
                        }
                    }
                    .overlay {
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 25, topTrailing: 25))
                            .stroke(.gray, lineWidth: 2)
                            .opacity(0.2)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 25)
            }
            
            
        }
        .frame(maxWidth: .infinity, alignment: .center)
        }
           
    }
}



struct TagsView: View{
    let items: [String]

    var body: some View {
        ScrollView(.horizontal) {
            HStack{
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
        
        .scrollIndicators(.hidden)
        .padding(.leading, 10)
    }
}
#Preview {
    RecipeView()
}
