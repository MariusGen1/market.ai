import SwiftUI

struct ArticleView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var chatMessages: [ChatMessage] = []
    @State private var userInput = ""
    
    @FocusState private var keyboardFocused: Bool
    
    let article: Article
    
    private func getMessages() async {
        do {
            chatMessages = try await ChatService.getMessages(for: article.articleId)
        } catch { print(error) }
    }
    
    private func postMessage() async {
        guard userInput.count > 0 else { return }
        let tmp = userInput
        userInput = ""
        
        do {
            try await ChatService.postMessage(articleId: article.articleId, body: tmp)
            await getMessages()
        } catch { print(error) }
    }
    
    
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
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 25, weight: .bold))
                                Spacer()
                            }
                            
                            RoundedTextContainer(content: article.body)
                            
                            // Key Ideas
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Portfolio Impact")
                                    .font(.system(size: 20, weight: .bold))
                                
                                RoundedTextContainer(content: article.portfolioImpact)
                            }
                            
                            // Chat Assistant
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Ask about this article")
                                    .font(.system(size: 20, weight: .bold))
                                
                                VStack(spacing: 12) {
                                    ForEach(chatMessages) { msg in
                                        chatBubble(message: msg)
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
                                    
                                    Button { Task { await postMessage() } } label: {
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
                                    .bold()
                                Text("Back")
                                    .bold()
                            }
                            .padding(10)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .padding(.vertical)
                            .foregroundStyle(.black)
                            .font(.footnote)
                        }
                        .shadow(radius: 5)
                    }
                }
                .task { await getMessages() }
                .foregroundStyle(.white)
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
    
    private func chatBubble(message: ChatMessage) -> some View {
        HStack {
            if message.isUserMessage { Spacer() }
            
            Text(message.body)
                .padding(10)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.white)
            
            if !message.isUserMessage { Spacer() }
        }
        .padding(.horizontal, 5)
    }
}

struct RoundedTextContainer: View {
    let content: String
    
    var body: some View {
        Text(content)
            .font(.system(size: 16))
            .foregroundColor(.white.opacity(0.8))
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(15)
    }
}
