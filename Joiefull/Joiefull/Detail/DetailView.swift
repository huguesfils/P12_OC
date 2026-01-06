//
//  DetailView.swift
//  Joiefull
//
//  Created by Hugues Fils Caparos on 06/01/2026.
//

import SwiftUI

struct DetailView: View {
    let item: Item?
    
    var body: some View {
        if let item = item {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Image principale
                    AsyncImage(url: URL(string: item.picture.url)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 400)
                                .onAppear {
                                    print("📥 [DetailView] Début téléchargement: \(item.picture.url)")
                                }
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity)
                                .frame(height: 400)
                                .clipped()
                                .onAppear {
                                    print("✅ [DetailView] Image chargée: \(item.picture.url)")
                                }
                        case .failure(let error):
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 400)
                                .foregroundColor(.gray)
                                .onAppear {
                                    print("❌ [DetailView] Erreur chargement: \(item.picture.url) - \(error)")
                                }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(item.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(item.category)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack(alignment: .center, spacing: 12) {
                            Text("\(String(format: "%.2f", item.price))€")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            if item.original_price > item.price {
                                Text("\(String(format: "%.2f", item.original_price))€")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .strikethrough()
                            }
                        }
                        
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("\(item.likes) personnes aiment ce produit")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        Text("Description")
                            .font(.headline)
                        Text(item.picture.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle(item.name)
            .navigationBarTitleDisplayMode(.inline)
        } else {
            VStack(spacing: 20) {
                Image(systemName: "hand.tap")
                    .font(.system(size: 80))
                    .foregroundColor(.secondary)
                Text("Sélectionnez un article")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    let sampleItem = Item(
        id: 0,
        picture: Picture(
            url: "",
            description: "Sac à main orange posé sur une poignée de porte"
        ),
        name: "Sac à main orange",
        category: "ACCESSORIES",
        likes: 56,
        price: 69.99,
        original_price: 89.99
    )
    
    NavigationStack {
        DetailView(item: sampleItem)
    }
}
