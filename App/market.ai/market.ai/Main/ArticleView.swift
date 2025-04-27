import SwiftUI

struct ArticleView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var chatMessages: [ChatMessage] = []
    @State private var userInput = ""
    
    @FocusState private var keyboardFocused: Bool
    
    let article: Article
    
    var formattedArticleDate: String {
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy hh:mm"
        return df.string(from: article.ts)
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
                                
                                VStack(spacing: 7) {
                                    Text(article.title.replacingOccurrences(of: "#", with: ""))
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 25, weight: .bold))
                                    Text(formattedArticleDate)
                                        .font(.footnote)
                                        .opacity(0.6)
                                }
                                Spacer()
                            }
                            
                            RoundedTextContainer(content: article.body)
                            
                            // Key Ideas
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Portfolio Impact")
                                    .font(.system(size: 20, weight: .bold))
                                
                                RoundedTextContainer(content: article.portfolioImpact)
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Sources")
                                    .font(.system(size: 20, weight: .bold))
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: 10) {
                                        ForEach(article.sources, id: \.absoluteString) { source in
                                            WebsiteLinkView(url: source)
                                        }
                                    }
                                }
                            }
                            
                            
                            // Chat Assistant
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Ask about this article")
                                    .font(.system(size: 20, weight: .bold))
                                
                                ChatView(article.articleId)
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
}

struct RoundedTextContainer: View {
    let content: String
    
    var body: some View {
        Text(LocalizedStringKey(content))
            .font(.system(size: 16))
            .foregroundColor(.white.opacity(0.8))
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(15)
    }
}

struct ChatView: View {
    private let articleId: Int
    @State private var messages: [ChatMessage]?
    @State private var thinking = false
    @State private var userInput = ""
    
    init(_ articleId: Int) { self.articleId = articleId }
    
    private func getMessages() async {
        do {
            messages = try await ChatService.getMessages(for: articleId)
        } catch { print(error) }
    }
    
    private func postMessage() async {
        guard userInput.count > 0 else { return }
        let tmp = userInput
        userInput = ""
        withAnimation { thinking = true }
        
        withAnimation { messages?.append(ChatMessage(body: tmp)) }
        
        do {
            try await ChatService.postMessage(articleId: articleId, body: tmp)
            await getMessages()
            withAnimation { thinking = false }
        } catch { print(error) }
    }
    
    var body: some View {
        Group {
            if let messages {
                VStack(spacing: 10) {
                    ForEach(messages) { msg in
                        MessageView(message: msg)
                    }
                    
                    if thinking {
                        ThinkinAnimation()
                    }
                    
                    HStack {
                        TextField("", text: $userInput, prompt: Text("Ask anything").foregroundStyle(.gray))
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                        
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
                }
                .padding(.bottom, 20)
                
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding(.top, 50)
            }
        }
        .task { await getMessages() }
    }
}

struct MessageView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUserMessage { Spacer() }

            Text(LocalizedStringKey(message.body))
                .multilineTextAlignment(message.isUserMessage ? .trailing : .leading)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.white.opacity(0.05))
                )
            
            if !message.isUserMessage { Spacer() }
        }
    }
}

struct ThinkinAnimation: View {
    @State private var shimmer = false
    
    var body: some View {
        HStack {
            ZStack {
                HStack(spacing: 10) {
                    HStack {
                        Text("Thinking...")
                        Image(systemName: "sparkles")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                    }
                    .foregroundColor(.gray)
                }
                HStack(spacing: 10) {
                    HStack {
                        Text("Thinking...")
                        Image(systemName: "sparkles")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                        }
                        .foregroundColor(.gray)
                        .mask(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.clear, .white, .clear]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .offset(x: shimmer ? 180 : -180)
                        )
                }
            }
            Spacer()
        }
    .onAppear {
        withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) { shimmer = true } }
    }
}

struct WebsiteLinkView: View {
    @Environment(\.openURL) var openURL
    let url: URL
    
    var body: some View {
        Button { openURL(url) } label: {
            HStack {
                Text(url.host(percentEncoded: false) ?? url.description)
                    .multilineTextAlignment(.leading)
                    .font(.caption)
                Spacer()
                Image(systemName: "arrow.up.right.square")
            }
            .foregroundColor(.white)
            .padding(10)
            .background(
                Capsule()
                    .foregroundStyle(Color.white.opacity(0.05))
            )
        }
    }
}
