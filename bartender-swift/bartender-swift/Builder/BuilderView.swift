//
//  BuilderView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/21/23.
//

import SwiftUI

struct BuilderView: View {
    @Binding var appUser: AppUser?
    
    var body: some View {
        Text("Builder View")
    }
}


struct BuilderView_Previews: PreviewProvider {
    static var previews: some View {

        Group {
            BuilderView(appUser: .constant(.init(uid: "123456789", email: "anishagrawal2003@gmail.com")))
        }
    }
}
