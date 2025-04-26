import SwiftUI

struct OnboardLiteracy: View {
    
    @Binding var selectedTab: Int
    @State private var selection: String? = nil

    let options = [
        "Beginner",
        "Casual Investor",
        "Active Trader",
        "Expert"
    ]

    var body: some View {
        
        ZStack {
            Color("bgNavy")
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {

                VStack(alignment: .leading, spacing: 10) {
                    Text("Financial Literacy")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

                    Text("Tell us your experience level — whether you're just getting started or an active trader, we'll tailor your news to match your knowledge.")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }

                
                Spacer()
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selection = option
                        }) {
                            Text(option)
                                .font(.system(size: 16, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    selection == option ? Color("purpleLight") : Color.white.opacity(0.1)
                                )
                                .foregroundColor(selection == option ? .black : .white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selection == option ? Color("purpleLight") : Color.clear, lineWidth: 2)
                                )
                        }
                    }
                }
                
                Button(action: {
                    selectedTab += 1
                }) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("purpleLight"))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    selectedTab -= 1
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 10, height: 10)
                            .foregroundStyle(Color("purpleLight"))
                        Text("Back")
                            .foregroundStyle(Color("purpleLight"))
                            .font(.system(size: 17, weight: .medium, design: .default))
                    }
                }
            }
        }
    }
}
