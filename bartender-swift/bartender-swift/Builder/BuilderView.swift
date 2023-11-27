//
//  BuilderView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/21/23.
//

import SwiftUI

struct BuilderView: View {
    @EnvironmentObject var currUser: CurrUser
    
    var body: some View {
        Text("Builder View")
    }
}


struct BuilderView_Previews: PreviewProvider {
    static var previews: some View {

        Group {
            BuilderView()
        }
    }
}
