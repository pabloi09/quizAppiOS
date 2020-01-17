//
//  ImageStore.swift
//  Quiz App 10
//
//  Created by Pablo Martín Redondo on 14/11/2019.
//  Copyright © 2019 Pablo Martín Redondo. All rights reserved.
//

import Foundation
import UIKit

class ImageStore : ObservableObject{
    @Published var imageCache = [URL : UIImage]()
    
    var defaultImage = UIImage(named: "none")!
    
    func image(url : URL?) -> UIImage {
        guard let url = url else {
            return defaultImage
        }
        if let img = imageCache[url]{
            return img
        }
        DispatchQueue.global().async{
            if let data = try? Data(contentsOf: url) ,
                let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageCache[url] = img
                }
            }
        }
        return defaultImage
    }
    
}
