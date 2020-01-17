//
//  ContentView.swift
//  Quiz con SwiftUI
//
//  Created by Pablo Martín Redondo on 28/11/2019.
//  Copyright © 2019 Pablo Martín Redondo. All rights reserved.
//

import SwiftUI

private let preferences = UserDefaults.standard

struct ContentView: View {
    
    @EnvironmentObject var quizModel : Quiz10Model
    @EnvironmentObject var imageStore : ImageStore
    @EnvironmentObject var memory : Memory
    
    var body: some View {
        NavigationView{
            List{
                ForEach(self.quizModel.quizzes){ quizItem in
                    NavigationLink(destination :
                        QuizDetail(quizItem: quizItem,
                                   imageStore: self.imageStore,
                                   memory: self.memory,
                                   changeFav: {
                            self.quizModel.changeFav(quizItem)
                        })){
                            CustomCell(quizItem: quizItem,
                                       imageStore: self.imageStore){
                                self.quizModel.changeFav(quizItem)
                            }
                    }
                }
            }
            .navigationBarTitle(Text("Quizzes")
            .font(.largeTitle))
            .navigationBarItems(trailing: HStack{
                PointsView(memory: memory)
                Button(action : {
                    self.quizModel.download()
                }){
                    Image(systemName: "arrow.2.circlepath")
                }
            .padding(7)

            })
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let quizModel = Quiz10Model()
        if let url = URL(string: "https://quiz.dit.upm.es/api/quizzes/random10wa?token=6bb259eede7bacdc5aab"){
            quizModel.getDefault(url: url)
        }
        let imageStore = ImageStore()
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
            .environmentObject(quizModel)
            .environmentObject(imageStore)
        return contentView
    }
}
