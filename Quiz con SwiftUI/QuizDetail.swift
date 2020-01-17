//
//  QuizDetail.swift
//  Quiz con SwiftUI
//
//  Created by Pablo Martín Redondo on 05/12/2019.
//  Copyright © 2019 Pablo Martín Redondo. All rights reserved.
//

import SwiftUI
import Combine

private let preferences = UserDefaults.standard

struct QuizDetail: View {
    @ObservedObject var quizItem : QuizItem
    @State var answer: String = ""
    @ObservedObject var imageStore: ImageStore = ImageStore()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var alertShowing : Bool = false
    @ObservedObject var memory : Memory = Memory()
    var changeFav : ()->() = {}
    @Environment(\.horizontalSizeClass) var horizontalSizeclass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    
    var body: some View {
        Group{
            if horizontalSizeclass == .compact{
                VStack(alignment: .trailing){
                    InfoQuiz(quizItem: quizItem,
                             imageStore: imageStore)
                        .frame(height: UIScreen.screenHeight/2)
                        .padding(.top, 1)
                    UserIteractionField(answer: $answer,
                                        alertShowing: $alertShowing){
                                            self.submit()}
                    Spacer()
                    .modifier(BarSettings(alertShowing: $alertShowing,
                                          getAlert: {self.getAlert()},
                                          changeFav: {self.changeFav()},
                                          memory: memory,
                                          quizItem: quizItem))
                }
            }else{
                HStack{
                    InfoQuiz(quizItem: quizItem,
                             imageStore: imageStore)
                        .frame(width: UIScreen.screenWidth/2)
                    UserIteractionField(answer: $answer,
                                        alertShowing: $alertShowing){self.submit()}
                        .frame(width: UIScreen.screenWidth/2)
                    Spacer()
                    .modifier(BarSettings(alertShowing: $alertShowing,
                                          getAlert: {self.getAlert()},
                                          changeFav: {self.changeFav()},
                                          memory: memory,
                                          quizItem: quizItem))
                }
            }
        }

    }
    

    func submit(){
        if answer.lowercased() == quizItem.answer.lowercased() {
            if(!memory.quizzesDone.contains(quizItem.id)){
                memory.add(id: quizItem.id)
                
            }
        }
    }
    
    func getAlert() -> Alert{
        if answer.lowercased() == quizItem.answer.lowercased() {
            return Alert(title: Text("Congrats!!") ,
                         message: Text("Your answer was correct."),
                         dismissButton: Alert.Button.cancel(Text("Go back"),
                                                            action: {self.mode.wrappedValue.dismiss()}))
        }else {
            return Alert(title: Text("Try again!") ,
                         message: Text("Your answer was wrong. The correct answer is \(quizItem.answer)"),
                         dismissButton: Alert.Button.cancel(Text("Try again")))
        }
    }
}

struct InfoQuiz: View {
    @ObservedObject var quizItem: QuizItem
    @ObservedObject var imageStore: ImageStore
    
    var body: some View {
        VStack(alignment: .trailing){
            Text(quizItem.question).font(.largeTitle)
                .frame(minWidth: 0.0,
                       maxWidth: .infinity,
                       alignment: .leading)
                .padding()
            Image(uiImage: imageStore.image(url: quizItem.attachment?.url))
                .resizable()
                .frame(minWidth: 0.0,
                       maxWidth: .infinity,
                       idealHeight: 236.0 ,
                       alignment: .top)
            HStack{
                Text("By \(quizItem.author?.username ?? "Anonymus")")
                    .lineLimit(2)
                Image(uiImage: imageStore.image(url: quizItem.author?.photo?.url))
                    .resizable()
                    .frame(width: 50.0, height: 50.0, alignment: .trailing)
                    .clipShape(Circle())
            }
            .padding()
        }

    }
    
}

struct UserIteractionField: View {
    @Binding var answer: String
    @Binding var alertShowing: Bool
    var submit: ()->()
    var body: some View {
        VStack(alignment: .trailing){
            TextField("Answer the question",
                      text: $answer)
                .padding()
            Button(action: {
                UIApplication.shared.endEditing()
                self.submit()
                self.alertShowing = true
                
            }){
                Text("Submit")
            }
            .padding()
            .padding(.trailing,15)
        }
    }
    
}

struct BarSettings: ViewModifier {
    @Binding var alertShowing : Bool
    var getAlert : ()->Alert
    var changeFav: ()->()
    @ObservedObject var memory : Memory
    @ObservedObject var quizItem: QuizItem
    
    func body(content: Content) -> some View {
        content
        .alert(isPresented: $alertShowing, content: {
            getAlert()
        })
        .navigationBarTitle("Question \(quizItem.index!)")
        .navigationBarItems(trailing: HStack{
            Button(action : {
                self.changeFav()
            }){
                Image(systemName: quizItem.favourite ? "heart.fill" : "heart")
                    .foregroundColor(Color.red)
            }
            PointsView(memory: memory)
        })
        
    }
}


struct QuizDetail_Previews: PreviewProvider {
    static var previews: some View {
        let model = Quiz10Model()
        let imageStore = ImageStore()
        if let url = URL(string: "https://quiz.dit.upm.es/api/quizzes/random10wa?token=6bb259eede7bacdc5aab"){
            model.getDefault(url: url)
            let view = QuizDetail(quizItem: model.quizzes[0], imageStore: imageStore, memory: Memory(), changeFav: {
                print("Fav")
            })
            return AnyView(view)
        }
        return AnyView(Text("No funciona"))
    }
}

extension UIApplication {
    func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
