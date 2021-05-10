//
//  ProductScrollItem.swift
//  ProductScrollExample
//
//  Created by JoeShon Monroe on 5/8/21.
//

import SwiftUI

struct ProductScrollItem: Identifiable {
    var id = UUID()
    var price:Double?
    var title:String = ""
    var destination:AnyView = AnyView(EmptyView())
    var image:Image?
    var imageMode:ContentMode = .fit
    var backgroundColor:Color = .white
    
}
