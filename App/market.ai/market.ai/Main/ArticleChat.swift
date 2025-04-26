import SwiftUI

struct ArticleChat: View {
    @State private var chatMessages: [String] = []
    @State private var userInput: String = ""

    var body: some View {
        ZStack {
            Color("bgNavy")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 25) {
                
                // Summary Card
                VStack(alignment: .leading, spacing: 10) {
                    Text("Summary")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("The S&P 500 has recovered about half of the losses it suffered from tariff impacts, signaling a cautious optimism in the market, but key challenges remain.")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.8))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(Color.white.opacity(0.05))
                .cornerRadius(15)
                
                // Excerpts Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Key Ideas")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 12) {
                        excerptBox("“Investors are weighing the impact of new tariffs on long-term earnings.”")
                        excerptBox("“Some sectors like technology have bounced back quicker than others.”")
                        excerptBox("“Trade negotiations remain a key wildcard moving forward.”")
                    }
                }
                
                // Chat Assistant
                VStack(alignment: .leading, spacing: 15) {
                    Text("Ask about this article")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(chatMessages, id: \.self) { message in
                                chatBubble(message: message)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                    .background(Color.white.opacity(0.03))
                    .cornerRadius(15)
                    
                    HStack {
                        TextField("Ask a question...", text: $userInput)
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        
                        Button {
                            sendMessage()
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.blue.opacity(0.8))
                                .cornerRadius(10)
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
    
    // MARK: - Helper views
    
    private func excerptBox(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 15))
            .foregroundColor(.white.opacity(0.8))
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
    }
    
    private func chatBubble(message: String) -> some View {
        HStack {
            Text(message)
                .padding(10)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal, 5)
    }
    
    private func sendMessage() {
        guard !userInput.isEmpty else { return }
        chatMessages.append(userInput)
        userInput = ""
        
        // TODO: Send to AI and append response
    }
}

#Preview {
    ArticleChat()
}
