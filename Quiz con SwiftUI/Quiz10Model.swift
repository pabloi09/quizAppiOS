//
//  Quiz10Model.swift
//  Quiz App 10
//
//  Created by Pablo Martín Redondo on 14/11/2019.
//  Copyright © 2019 Pablo Martín Redondo. All rights reserved.
//

import Foundation

class QuizItem : Codable, Identifiable, ObservableObject {
    
    let id: Int
    let question: String
    let answer: String
    let author: Author?
    let attachment: Attachment?
    @Published var favourite: Bool
    let tips: [String]
    var index : Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case question = "question"
        case answer = "answer"
        case author = "author"
        case attachment = "attachment"
        
        case favourite = "favourite"
        case tips = "tips"
        case index  = "index"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        question = try values.decode(String.self, forKey: .question)
        answer = try values.decode(String.self, forKey: .answer)
        author = try values.decode(Author.self, forKey: .author)
        attachment = try values.decode(Attachment.self, forKey: .attachment)
        favourite = try values.decode(Bool.self, forKey: .favourite)
        tips = try values.decode([String].self, forKey: .tips)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(question, forKey: .question)
        try container.encode(answer, forKey: .answer)
        try container.encode(author, forKey: .author)
        try container.encode(attachment, forKey: .attachment)
        try container.encode(favourite, forKey: .favourite)
        try container.encode(tips, forKey: .tips)
        
    }
    struct Author: Codable {
        let isAdmin: Bool?
        let username: String
        let photo: Attachment?
    }
    struct Attachment: Codable {
        let filename: String
        let mime: String
        let url: URL?
    }
    
    
}


class Quiz10Model : ObservableObject {
    
    @Published var quizzes = [QuizItem]()
    private let TOKEN = "6bb259eede7bacdc5aab"
    private let baseUrl = "https://quiz.dit.upm.es"
    private let downloadRoute = "/api/quizzes/random10wa?token="
    private let favouritesRoute = "/api/users/tokenOwner/favourites/"
    
    func download(){
        let surl = "\(baseUrl)\(downloadRoute)\(TOKEN)"
        guard let url = URL(string: surl) else {
            print("ERROR DE CONSTRUCCION DE URL")
            return
        }
        DispatchQueue.global().async {
            do{
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let quizzes = try decoder.decode([QuizItem].self, from: data)
                for index in 0...quizzes.count - 1{
                    quizzes[index].index = index + 1
                }
                DispatchQueue.main.async {
                    self.quizzes = quizzes
                }
            } catch {
               
            }
        }
    }
    
    //funcion solo usada en desarrollo
    func getDefault(url:URL){
        guard let data = try? Data(contentsOf: url) else{
            return
        }
                       
        let decoder = JSONDecoder()
        if let quizzes = try? decoder.decode([QuizItem].self, from: data){
                    self.quizzes = quizzes
        }
    }
    
    func changeFav(_ item: QuizItem){
        // Crear la configuracion de la sesion:
        let config = URLSessionConfiguration.default
        // Crear una session
        let session = URLSession(configuration: config)
        // URL del sitio de subida
        let url = URL(string: "\(baseUrl)\(favouritesRoute)\(item.id)?token=\(TOKEN)")!
        let index = quizzes.firstIndex(){ quiz in
            return item.id == quiz.id
        }
        // La petición HTTP:
        var request = URLRequest(url: url)
        request.httpMethod = quizzes[index!].favourite ? "DELETE":"PUT"
        DispatchQueue.global().async {
            let task = session.dataTask(with: request) {
                (data: Data?, res: URLResponse?, error: Error?) in
                
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                let code = (res as! HTTPURLResponse).statusCode
                if code != 200 {
                    print(HTTPURLResponse.localizedString(forStatusCode: code))
                    return
                }
                DispatchQueue.main.async {
                    self.quizzes[index!].favourite = !self.quizzes[index!].favourite
                }
            }
            task.resume()
        }
        
    }
}
