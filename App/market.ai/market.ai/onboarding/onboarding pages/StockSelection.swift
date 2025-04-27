import SwiftUI
import Combine

struct OnboardStocks: View {
    
    @Environment(\.navigationController) var navigationController
    
    @State private var stocks: [Stock] = []
    @State private var selectedStocks: [Stock] = []
    
    @State private var searchText: String = ""
    @State private var showSelections: Bool = false
    
    @State private var debouncedText: String = ""
    @State private var cancellables = Set<AnyCancellable>()


    var body: some View {
        ZStack {
            Color("bgNavy").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {

                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Your Portfolio")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            showSelections.toggle()
                        } label: {
                            if !selectedStocks.isEmpty {
                                Text("View")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color("purpleLight"))
                                    .padding(.trailing)
                            }
                        }
                    }
                    
                    Text("Select the stocks that match your portfolio. Marketplace will tailor your daily updates to these selections.")
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.gray)
                    TextField("", text: $searchText, prompt: Text("Search ...").foregroundStyle(.gray))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(.gray.opacity(0.18))
                .foregroundStyle(.white.opacity(0.75))
                .cornerRadius(12)
                .padding(.bottom, 10)
                
                
                StockDisplay(
                    stocks: stocks.isEmpty ? top50stocks : stocks,
                    searchText: $searchText,
                    selectedStocks: $selectedStocks
                )
                
                Spacer()
                
                Button(action: {
                    Task {
                        do {
                            guard case .onboardStocks(let user, let financialLiteracyLevel) = navigationController.screen else { fatalError() }
                            try await UserService.createUser(uid: user.uid, financialLiteracyLevel: financialLiteracyLevel, stocks: stocks)
                            RequestHelper.configure(for: user)
                            navigationController.screen = .home(user: user)
                        } catch { print(error) }
                    }
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
                    guard case .onboardStocks(let user, _) = navigationController.screen else { fatalError() }
                    navigationController.screen = .onboardLiteracy(user: user)
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
        .sheet(isPresented: $showSelections) {
            Portfolio(selectedStocks: $selectedStocks)
                .presentationDetents([.fraction(0.50)])
        }
        .onReceive(Just(searchText)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
        ) { value in
            self.debouncedText = value
        }
        .onChange(of: searchText) { _, newValue in
            debounceSearch(newValue)
        }
        .onChange(of: debouncedText) { _, newTerm in
            guard !newTerm.isEmpty else {
                self.stocks = []
                return
            }
            
            let stockSearcher = StockSearcher()
            stockSearcher.searchStocks(for: newTerm) { result in
                if newTerm != debouncedText { return }
                
                switch result {
                case .success(let stocks):
                    self.stocks = stocks
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    private func debounceSearch(_ text: String) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        Just(text)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { value in
                self.debouncedText = value
            }
            .store(in: &cancellables)
    }
}

struct StockDisplay: View {
    let stocks: [Stock]
    @Binding var searchText: String
    @Binding var selectedStocks: [Stock]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 25) {
                ForEach(0..<Int(ceil(Double(stocks.count) / 3.0)), id: \.self) { rowIndex in
                    HStack(spacing: 20) {
                        ForEach(0..<3, id: \.self) { columnIndex in
                            let index = rowIndex * 3 + columnIndex
                            if index < stocks.count {
                                let stock = stocks[index]
                                StockPill(
                                  stock: stock,
                                  selectedStocks: $selectedStocks
                                )
                            }
                        }
                    }
                }
            }
        }
        .padding(.top)
    }
}


#Preview {
    OnboardStocks()
}
