import SwiftUI

struct ArticleView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var chatMessages: [String] = []
    @State private var userInput = ""
    
    @FocusState private var keyboardFocused: Bool
    
    @State var article: Article

    
    var body: some View {
        ZStack {
            Color("bgNavy").ignoresSafeArea()
            
            GeometryReader { geo in
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        
                        // image
                        AsyncImage(url: article.imageUrl) { phase in
                            switch phase {
                            case .empty:
                                Color.gray.opacity(0.2)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Color.gray
                            @unknown default:
                                Color.gray
                            }
                        }
                        .frame(width: geo.size.width,
                               height: geo.size.height * 0.40)
                        .clipped()
                        
                        
                        VStack(alignment: .leading, spacing: 25) {
                            
                            HStack {
                                Spacer()
                                Text(article.title)
                                    .font(.system(size: 25, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            
                            Text(article.body)
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(15)
                            
                            // Key Ideas
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
                                        ForEach(chatMessages, id: \.self) { msg in
                                            chatBubble(message: msg)
                                        }
                                    }
                                }
                                .frame(maxHeight: 200)
                                .background(Color.white.opacity(0.03))
                                .cornerRadius(15)
                                
                                HStack {
                                    VStack(spacing: 12) {
                                      TextField("", text: $userInput, prompt: Text("Ask anything").foregroundStyle(.gray))
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                        .padding()
                                    }

                                    
                                    Button {
//                                        sendMessage()
                                    } label: {
                                        Image(systemName: "arrow.up.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(!userInput.isEmpty ? Color("purpleLight") : .gray.opacity(0.5))
                                            .offset(x: -3, y: 1)
                                            .padding(.trailing)
                                    }
                                }
                                .background(.gray.opacity(0.18))
                                .foregroundStyle(.white.opacity(0.75))
                                .cornerRadius(20)
                                .padding(.bottom, 10)
                            }
                            
                            
                            Spacer(minLength: 30)
                        }
                        .padding()
                    }
                }
                .ignoresSafeArea(edges: .top)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { dismiss() }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Custom Back")
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
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
//    
//    private func sendMessage() {
//        guard !userInput.isEmpty else { return }
//        chatMessages.append(userInput)
//        userInput = ""
//    }
}
