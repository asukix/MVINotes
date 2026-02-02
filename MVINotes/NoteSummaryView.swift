//
//  NoteSummaryView.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 02..
//

import SwiftUI

struct NoteSummaryView: View{
    let title: String = "MVI practice"
    let description: String = "Create a notes app using MVI architecture"
    let date: String = "2026. 02. 02."
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                    .bold(true)
                Text(description)
                Text(date)
            }
            Spacer()
            Button(action: {
                
            }) {
                Image(systemName: "star")
                    .imageScale(.medium)
            }
        }
        .padding(12)
    }
}


#Preview {
    NoteSummaryView()
}
