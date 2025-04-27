import SwiftUI

struct OnboardLiteracy: View {
    @Environment(\.navigationController) var navigationController
    @State private var selection: FinancialLiteracyLevel? = nil

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
                
                HStack {
                    Spacer()
                    Image("literacy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 225, height: 225)
                    Spacer()
                }

                
                Spacer()
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(FinancialLiteracyLevel.allCases.sorted(by: { $0.rawValue < $1.rawValue }), id: \.rawValue) { option in
                        Button(action: {
                            selection = option
                        }) {
                            Text(option.name)
                                .font(.system(size: 16, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.gray.opacity(0.20))
                                .foregroundStyle(.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color("purpleLight"), lineWidth: selection == option ? 4 : 0)
                                )
                        }
                    }
                }
                
                
                Button(action: {
                    guard let selection else { return }
                    guard case .onboardLiteracy(let user) = navigationController.screen else { fatalError() }
                    navigationController.screen = .onboardStocks(user: user, financialLiteracyLevel: selection)
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
                    guard case .onboardLiteracy(let user) = navigationController.screen else { fatalError() }
                    navigationController.screen = .landing(user: user)
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

#Preview {
    OnboardLiteracy()
}
