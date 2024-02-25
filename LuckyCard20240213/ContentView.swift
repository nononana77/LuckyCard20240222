import SwiftUI

class TextLimiter : ObservableObject {
    private let limit : Int
    
    init(limit: Int) {
        self.limit = limit
    }
    
    @Published var textValue = "" {
        didSet {
            if textValue.count > self.limit {
                textValue = String(textValue.prefix(self.limit))
                self.hasReachedLimit = true
            } else {
                self.hasReachedLimit = false
            }
        }
    }
    @Published var hasReachedLimit = false
}

struct ContentView: View {
    @State var isFlipped = false
    
    @State var isOn = true
    @State var stepperValue = 0
    @State var textValue = ""
    
    @State var isVisible = false
    @State var isVisible2 = false
    
    @ObservedObject var input = TextLimiter(limit: 10)
    
    var body: some View {
        VStack{
            Button{
            } label: {
                Image(systemName: "ladybug")
                Text("LUCKY CARD")
                    .font(.title)
                Image(systemName: "lizard.fill")
                
            }
            
            
            TextField("YOUR NAME", text: $input.textValue) //MARK: Changed
                .frame(width:150, height: 100,alignment: .center)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(input.hasReachedLimit ? Color.red : Color.blue)
                )
                //.border(Color.red, width: $input.hasReachedLimit.wrappedValue ? 1:0)
            
            if input.hasReachedLimit {
                Text("Type under 10 characters")
                    .foregroundStyle(.red)
                    .font(.caption)

            }
            
            Button("Create") {
                isVisible2 = true
            }
            .disabled(input.hasReachedLimit) //MARK: Changed
            .font(.title2)
            .sheet(isPresented: $isVisible2, content: {
                ZStack{
                    myCard(
                        text: "🍀🍀🍀🍀🍀🍀🍀", textC: .black,
                        color: .red, scolor: .blue,
                        isTrue: 0, isFalse: -90,
                        isFlipped: isFlipped
                    )
                    .animation(isFlipped ? .linear.delay(0.35): .linear, value: isFlipped)
                    
                    //MARK: Changed
                    myCard(
                        text: input.textValue, textC: .black,
                        color: .yellow, scolor: .red,
                        isTrue: 90, isFalse: 0,
                        isFlipped: isFlipped
                    )
                    .animation(isFlipped ? .linear : .linear.delay(0.35) , value: isFlipped)
                }
                .onTapGesture {
                    withAnimation (.easeInOut){
                        isFlipped.toggle()
                    }
                }
            })
            
            
        }
        .padding()
        
    }
}

#Preview {
    ContentView()
}

struct myCard: View {
    var text: String
    var textC: Color
    var color: Color
    var scolor: Color
    var isTrue: CGFloat
    var isFalse : CGFloat
    var isFlipped : Bool
    
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width:250, height:200)
                .foregroundColor(color)
            
            Text(text).bold().font(.title)
                .foregroundStyle(textC)
        }
        .rotation3DEffect(.degrees(isFlipped ? isTrue : isFalse),
                          axis: (x: 0.0, y: 1.0, z:0.0))
    }
}
