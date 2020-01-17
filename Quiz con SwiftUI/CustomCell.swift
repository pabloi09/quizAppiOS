//
//  CustomCell.swift
//  Quiz con SwiftUI
//
//  Created by Pablo Martín Redondo on 03/12/2019.
//  Copyright © 2019 Pablo Martín Redondo. All rights reserved.
//

import SwiftUI

struct CustomCell: View {
    @ObservedObject var quizItem : QuizItem
    @ObservedObject var imageStore : ImageStore
    var changeFav : ()->()
    var body: some View {
        HStack{
            ZStack(alignment: .trailing){
                
                Image(uiImage: self.imageStore.image(url: quizItem.attachment?.url))
                    .resizable()
                    .frame(width: CGFloat(171.0), height: CGFloat(140.0), alignment: .topTrailing)
                VStack{
                Image(systemName: quizItem.favourite ? "heart.fill" : "heart")
                    .foregroundColor(Color.red)
                    .padding(6)
                }
                .background(Color.black)
                .clipShape(Circle())
                .frame(minHeight: 0, maxHeight : 140, alignment: .bottom)
                .padding(3)
                .onTapGesture {
                        self.changeFav()
                }
            }
            
            
            
            VStack(alignment: .trailing){
                Text(quizItem.question)
                    .lineLimit(6)
                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 110.0, alignment: .leading)
                
                HStack{
                    Text("By \(quizItem.author?.username ?? "Anonimus")")
                        .multilineTextAlignment(.trailing)
                        .lineLimit(10)
                    
                    Image(uiImage: self.imageStore.image(url: quizItem.author?.photo?.url))
                        .resizable()
                        .frame(width: CGFloat(30.0), height: CGFloat(30.0), alignment: .topTrailing)
                        .clipShape(Circle())
                    
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 140.0)
            
            
            
            
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct CustomCell_Previews: PreviewProvider {
    static var previews: some View {
        let model = Quiz10Model()
        let imageStore = ImageStore()
        if let url = URL(string: "https://quiz.dit.upm.es/api/quizzes/random10wa?token=6bb259eede7bacdc5aab"){
            model.getDefault(url: url)
            let view = CustomCell(quizItem: model.quizzes[0], imageStore: imageStore){
                print("Fav change")
            }
            return AnyView(view)
        }
        return AnyView(Text("No funciona"))
        
    }
}
