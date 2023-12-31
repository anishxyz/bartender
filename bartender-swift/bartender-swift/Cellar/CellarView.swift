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
    @StateObject var loadingState = LoadingStateViewModel()
    
    @State private var showingAddBottle = false
    @State private var showingAddBarSheet = false
    
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
                                Section(header: Text("Bottles").font(.headline)) {
                                    Button("From Camera", action: {
                                        // Action for selecting 'From Camera'
                                    })
                                    Button("Enter Custom", action: {
                                        showingAddBottle = true
                                    })
                                }
                                Section(header: Text("Bars").font(.headline)) {
                                    Button("Create", action: {
                                        showingAddBarSheet = true
                                    })
//                                    Button("Move Bottles", action: {
//
//                                    })
                                }
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
                .sheet(isPresented: $showingAddBarSheet) {
                    AddBarSheetView(isPresented: $showingAddBarSheet)
                        .environmentObject(viewModel)
                        .environmentObject(loadingState)
                        .presentationDetents([.medium])
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
