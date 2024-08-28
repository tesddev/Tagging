//
//  Tag.swift
//  Tagging
//
//  Created by Tes on 28/08/2024.
//

import Foundation

struct Tag: Identifiable, Hashable{
    var id = UUID().uuidString
    var text: String
    var size: CGFloat = 0
}
