//
//  NetworkAuxiliary.swift
//  bartender
//
//  Created by Anish Agrawal on 3/26/24.
//

import Foundation
import UIKit

func convertImageToBase64String(img: UIImage) -> String {
    return img.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? ""
}
