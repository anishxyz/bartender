//
//  CellarView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/21/23.
//

import SwiftUI


struct CellarView: View {
    @EnvironmentObject var currUser: CurrUser
    
    @StateObject var viewModel = CellarViewModel()
    
    @State private var showingAddBottle = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    ForEach(viewModel.cellar) { bottle in
                        BottleDetailView(bottle: bottle)
                    }
                    .onDelete(perform: deleteBottle)
                }
                .refreshable {
                    viewModel.fetchCellarData(forUserID: currUser.uid)
                }
                .navigationTitle("🍾 The Cellar")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("From Camera", action: {
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
                .sheet(isPresented: $showingAddBottle) {
                    AddBottleView()
                        .environmentObject(viewModel)
                }
            }
        }
        .onAppear {
            viewModel.fetchCellarData(forUserID: currUser.uid)
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

        Group {
            CellarView()
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
            
            CellarView()
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
                .environment(\.colorScheme, .dark)
        }
    }
}
