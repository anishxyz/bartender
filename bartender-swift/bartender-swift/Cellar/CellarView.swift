//
//  CellarView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/21/23.
//

import SwiftUI


struct CellarView: View {
    @EnvironmentObject var currUser: CurrUser
    
    @EnvironmentObject var viewModel: CellarViewModel
    
    @State private var showingAddBottle = false
    
    @StateObject var loadingState = LoadingStateViewModel()
    
    var filteredCellar: [Bottle] {
        if let barID = viewModel.selectedBarID {
            return viewModel.cellar.filter { $0.bar_id == barID }
        } else {
            return viewModel.cellar // No filter applied, return all bottles
        }
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    Section(header: BarDropdownView(bars: viewModel.bars) { selectedBar in
                        viewModel.filterBottles(byBarID: selectedBar?.bar_id)
                    }) {
                        ForEach(filteredCellar) { bottle in
                            BottleDetailView(bottle: bottle)
                        }
                        .onDelete(perform: deleteBottle)
                    }
                }
                .refreshable {
                    loadingState.startLoading()
                    viewModel.fetchCellarData(forUserID: currUser.uid) {
                        loadingState.stopLoading()
                    }
                }
                .navigationTitle("🍾 The Cellar")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            ActivityIndicatorLS(loadingState: loadingState, style: .medium, color: UIColor.orange)
                            Menu {
                                Button("From Camera (coming soon)", action: {
                                    // Action for selecting 'From Camera'
                                })
                                Button("Enter Manually", action: {
                                    showingAddBottle = true
                                })
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.orange)
                                    .colorMultiply(.orange)
                            }
                        }
                    }
                }
                .sheet(isPresented: $showingAddBottle) {
                    AddBottleView()
                        .environmentObject(viewModel)
                }
            }
        }
    }
    
    private func deleteBottle(at offsets: IndexSet) {
        offsets.forEach { index in
            let bottleID = viewModel.cellar[index].id
            viewModel.deleteBottleFromCellar(bottleID: bottleID, forUserID: currUser.uid)
        }
    }
}


struct BarDropdownView: View {
    var bars: [Bar]
    var onSelect: (Bar?) -> Void
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: CellarViewModel

    var body: some View {
        HStack {
            Menu {
                Button("Full Cellar", action: {
                    onSelect(nil)
                })
                .textCase(nil)
                ForEach(bars, id: \.bar_id) { bar in
                    Button(bar.name, action: {
                        onSelect(bar)
                    })
                        .textCase(nil)
                }
            } label: {
                HStack {
                    Text("Bars")
                        .bold()
                    Image(systemName: "chevron.down") // System icon for the caret
                }
                .textCase(nil)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .background(Color.orange.colorMultiply(.orange))
                .clipShape(Capsule())
            }
            Spacer()
        }
        .padding(.leading, -18) // This value may need to be adjusted based on the default List padding
        .padding(.bottom, 10)
    }
}



struct CellarView_Previews: PreviewProvider {
    static var previews: some View {
        
        let mockViewModel = CellarViewModel()
        
        let currUser = CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com")

        Group {
            CellarView()
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
                .environmentObject(mockViewModel)
                .onAppear {
                    mockViewModel.fetchCellarData(forUserID: currUser.uid)
                }
            
            CellarView()
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
                .environmentObject(mockViewModel)
                .environment(\.colorScheme, .dark)
                .onAppear {
                    mockViewModel.fetchCellarData(forUserID: currUser.uid)
                }
        }
    }
}
