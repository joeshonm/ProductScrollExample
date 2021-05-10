//
//  ContentView.swift
//  ProductScrollExample
//
//  Created by JoeShon Monroe on 5/8/21.
//

import SwiftUI

struct ContentView: View {
    
    @State static var backgroundColor = Color(.sRGB, red: 236/255, green: 238/255, blue: 239/255, opacity: 1)
    
    @State var products:[ProductScrollItem] = [
        ProductScrollItem(price: 250, title: "Craig Green ZX 2K Phormar Shoes", destination: AnyView(Text("Craig Green ZX 2K Phormar Shoes")), image: Image("Craig_Green_ZX_2K_Phormar_Shoes_Blue_FY5717_01_standard-250"), backgroundColor: backgroundColor),
        ProductScrollItem(price: 500, title: "Y-3 Runner 4D Low", destination: AnyView(Text("Y-3 Runner 4D Low")), image: Image("Y-3_Runner_4D_IOW_Black_FZ4502_01_standard-500"), backgroundColor: backgroundColor),
        ProductScrollItem(price: 330, title: "Y-3 Ultraboost 21", destination: AnyView(Text("Y-3 Ultraboost 21")), image: Image("Y-3_Ultraboost_21_White_H67477_01_standard-330"), backgroundColor: backgroundColor),
        ProductScrollItem(price: 140, title: "ZX 0000 Evolution Shoes", destination: AnyView(Text("ZX 0000 Evolution Shoes")), image: Image("ZX_0000_Evolution_Shoes_White_GZ8500_HM1-140"), imageMode: .fill, backgroundColor: backgroundColor)
    ]
    
    
    @State private var productDestination:AnyView = AnyView(EmptyView())
    @State private var showProductDestination = false
    
    var body: some View {
        NavigationView {
            
            VStack {
                ProductScroll(items: $products) { destination in
                    productDestination = destination
                    showProductDestination = true
                }
                    .ignoresSafeArea(.container, edges: .top)
                    .ignoresSafeArea(.container, edges: .bottom)
                    .navigationBarHidden(true)
                
                
                NavigationLink(
                    destination: productDestination,
                    isActive: $showProductDestination,
                    label: {
                        EmptyView()
                    })
            }
                        
            
            
            

                
        }
        .colorScheme(.light)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
