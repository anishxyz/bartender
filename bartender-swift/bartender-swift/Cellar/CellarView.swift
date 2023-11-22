//
//  Cellar.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/21/23.
//

import SwiftUI


struct CellarView: View {
    @Binding var appUser: AppUser?
    
    var body: some View {
        Text("Cellar View")
    }
}


struct CellarView_Previews: PreviewProvider {
    static var previews: some View {

        Group {
            CellarView(appUser: .constant(.init(uid: "123456789", email: "anishagrawal2003@gmail.com")))
        }
    }
}
