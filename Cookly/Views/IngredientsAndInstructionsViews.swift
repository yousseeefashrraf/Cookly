import SwiftUI
struct ChevronIconView: View{
    @Binding var isSheetUp: Bool
    var sectionScrollableId: String
    @Binding var scrollPosition: ScrollPosition
    var backgroundColor: Color
    var body: some View {
        Image(systemName: isSheetUp ? "chevron.up" : "chevron.down")
            .frame(width: 30)
            .frame(width: 50, height: 50)
            .background(backgroundColor)
            .onTapGesture {
                withAnimation(.interactiveSpring) {
                    isSheetUp.toggle()
                    
                    if(isSheetUp){
                        scrollPosition.scrollTo(id: sectionScrollableId)
                    }
                }
                
            }
    }
}

struct IngredientsView: View {
    @State var isSheetUp = false
    var ingrediants: [String] = []
    @Binding var scrollPosition: ScrollPosition
    var body: some View{
        VStack(alignment: .leading){
            HStack(alignment: .center){
                Text("Ingredients")
                    .font(.system(.title2, design: .rounded,weight: .semibold))
                Spacer()
                ChevronIconView( isSheetUp: $isSheetUp, sectionScrollableId: "IngrediantsSection", scrollPosition: $scrollPosition, backgroundColor: .lightGreen)
                
            
        }
        
        if(!ingrediants.isEmpty && isSheetUp){
            ItemsListView(items: ingrediants, sectionId: "IngrediantsSection")
            
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

struct ItemsListView: View{
    var items: [String]
    var sectionId: String
    var body: some View{
        VStack(alignment: .leading){
            ForEach(items, id: \String.self){ item in
                HStack(alignment: .center){
                    Image(systemName: "smallcircle.filled.circle")
                    Text(item)
                        .font(.system(.title3, design: .rounded,weight: .light))
                }
                 
                  
            }
        }
        .id(sectionId)
    }
}

struct InstructionsView: View {
    @State var isSheetUp = false
    var instructions: [String] = []
    @Binding var scrollPosition: ScrollPosition
    var body: some View{
        VStack(alignment: .leading){
            HStack(alignment: .center){
                Text("Instructions")
                    .font(.system(.title2, design: .rounded,weight: .semibold))
                Spacer()
                ChevronIconView(isSheetUp: $isSheetUp, sectionScrollableId: "InstructionsSection", scrollPosition: $scrollPosition, backgroundColor: .darkGreen)
            }
              
                if(!instructions.isEmpty && isSheetUp){
                    ItemsListView(items: instructions, sectionId: "InstructionsSection")
            
            }
            
           
        }
        .frame(maxWidth: .infinity)
        .padding(25)
        .background(Color("darkGreen"))
        .clipShape(
            RoundedRectangle(cornerRadius: 25)
        )    }
}

#Preview {
    IngredientsView(isSheetUp: true, ingrediants: ["1","2","3"], scrollPosition: .constant(ScrollPosition(y: 100)))
    
    InstructionsView(isSheetUp: true, instructions: ["1","2","3"], scrollPosition: .constant(ScrollPosition(y: 100)))
}
