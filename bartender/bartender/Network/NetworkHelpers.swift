//
//  NetworkAuxiliary.swift
//  bartender
//
//  Created by Anish Agrawal on 3/26/24.
//

import Foundation
import UIKit

//func convertImageToBase64StringAsync(img: UIImage) async -> String {
//    return await withCheckedContinuation { continuation in
//        DispatchQueue.global(qos: .userInitiated).async {
//            let base64String = img.jpegData(compressionQuality: 0.8)?.base64EncodedString() ?? ""
//            continuation.resume(returning: base64String)
//        }
//    }
//}

func convertImageToBase64String(img: UIImage) -> String {
    return img.jpegData(compressionQuality: 0.8)?.base64EncodedString() ?? ""
}
