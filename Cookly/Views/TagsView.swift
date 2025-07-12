import SwiftUI

enum TagAnimator: CaseIterable {
    case blueGrayRed
    case GrayRedBlue
    case RedGrayBlue
    
    var phase: LinearGradient {
        
        switch self {
        case .GrayRedBlue:
            return LinearGradient(topLeadingBottomTrailingOf: [.gray, .red, .blue])
                                  
        case .RedGrayBlue:
                                    return LinearGradient(topLeadingBottomTrailingOf: [.red, .gray, .blue])
                               
        case .blueGrayRed:
            return LinearGradient(topLeadingBottomTrailingOf: [.blue, .gray, .red])
        }
    }
    
}

struct TagView: View{
    @State var isSelected = false
    let item: String
    let action: ((String,Binding<Bool>) -> ())?
    let onAppearAction: ((String,Binding<Bool>) -> ())?
    
    var body: some View{
        
        PhaseAnimator(TagAnimator.allCases){ phase in
            Text(item)
                .font(.system(.callout, design: .rounded, weight: .medium))
                .opacity(1)
                .padding(5)
                .padding(.horizontal, 6).background(isSelected ? Color.black : Color.clear)
                .foregroundStyle(isSelected ? Color.white : Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 60))
                .overlay {
                    RoundedRectangle(cornerRadius: 60)
                        .fill( isSelected ? phase.phase : LinearGradient(topLeadingBottomTrailingOf: [.red, .gray, .blue]))
                        .mask {
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(lineWidth: 4)

                        }
                    
                }
                .shadow(color: isSelected ? .lightGreen : .white ,radius: 5)
                .onAppear{
                    
                    onAppearAction?(item,$isSelected)
                }
                .onTapGesture {
                    action?(item, $isSelected)
                }
                .animation(.easeInOut, value: 0.5)
        }
        
    }

}

struct TagsView: View{
    let items: [String]
    let action: ((String,Binding<Bool>) -> ())?
    let onAppearAction: ((String,Binding<Bool>) -> ())?

    init(items: [String], action: ((String, Binding<Bool>)->())? = nil, onAppearAction: (((String,Binding<Bool>) -> ())?) = nil){
        self.items = items
        self.action = action
        self.onAppearAction = onAppearAction
    }
    var body: some View {
        ScrollView(.horizontal) {
            HStack(){
                ForEach(items, id: \String.self){ item in
                    
                    TagView(item: item, action: action, onAppearAction: onAppearAction)
                        
                       
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
    }
}


#Preview {
    TagsView(items: ["Hello", "One", "Two"])
}
