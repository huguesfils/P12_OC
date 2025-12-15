//
//  InfoItemView.swift
//  Joiefull
//
//  Created by Hugues Fils Caparos on 15/12/2025.
//

import SwiftUI

struct InfoItemView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Veste urbaine")
                    .foregroundStyle(Color.black)
                    .fontWeight(.semibold)
                Text("89€")
                    .foregroundStyle(Color.black)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 8) {
                Label {
                    Text("4.1")
                        .foregroundStyle(Color.black)
                } icon: {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.orange)
                }
                
                Text("120€")
                    .strikethrough()
                    .foregroundStyle(Color.black)
                    .opacity(0.7)
            }
        }
    }
}

#Preview {
    InfoItemView()
        .padding()
}
