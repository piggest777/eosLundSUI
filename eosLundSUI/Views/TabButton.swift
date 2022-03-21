//
//  TabButton.swift
//  eosLundSUI
//
//  Created by Denis Rakitin on 2022-03-18.
//

import SwiftUI

struct TabButton: View {
    
    var title: String
    var animation: Namespace.ID
    @Binding var currentTab: String
    
    var body: some View {
        Button{
            
            withAnimation(.spring()){
                currentTab = title
            }
            
        } label: {
             Text(title)
                .fontWeight(.light)
                .foregroundColor(currentTab == title ? .white : .black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 3)
                .background(
                
                    ZStack{
                        if currentTab ==  title {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                )
        }
    }
    
}

//struct TabButton_Previews: PreviewProvider {
//    static var previews: some View {
//        TabButton()
//    }
//}
