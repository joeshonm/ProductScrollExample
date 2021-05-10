//
//  ProductScroll.swift
//  ProductScrollExample
//
//  Created by JoeShon Monroe on 5/8/21.
//

import SwiftUI

struct ProductScroll: View {
    
    @Binding var items:[ProductScrollItem]
    @State var normalWidth:CGFloat = 120
    @State var expandedWidth:CGFloat = 160
    @State var fontSize:CGFloat = 12
    @State var itemHeight:CGFloat = 200
    @State var price:String = "N/a"
    @State private var priceButtonExpanded:Bool = false
    @State private var priceInfoExpanded:Bool = false
    @State private var itemTitle:String = ""
    @State private var destination:AnyView = AnyView(EmptyView())
    
    @State var destinationView:(AnyView) -> ()
    
    var body: some View {
        GeometryReader { wrapView in
            ZStack {
                GeometryReader { fullView in
                    
                    if items.count > 0 {
                        ScrollView(.vertical) {
                            VStack(spacing: 0) {
                                
                                ForEach(items) { item in
                                    GeometryReader { geo in
                                        ZStack {
                                            Rectangle()
                                                .fill(item.backgroundColor)
                                            
                                            if item.image != nil {
                                                item.image!
                                                    .resizable()
                                                    .aspectRatio(contentMode: item.imageMode)
                                                    .frame(width: fullView.size.width)
                                            }
                                            
                                            Rectangle()
                                                .fill(Color.white)
                                                .opacity(getOpacity(fullProxy: fullView, itemProxy: geo, product: item))
                                            
                                        }
                                        
                                    }
                                    .frame(width: fullView.size.width, height: fullView.size.height/1.7)
                                }
                                
                            }
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        VStack(alignment: .center) {
                            Text("NO PRODUCTS")
                                .font(.system(size: fontSize))
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    }
                }
                
                if items.count > 0 {
                    Button(action: {
                        
                        
                        if priceButtonExpanded == false {
                            withAnimation(.easeIn(duration: 0.2)) {
                                priceButtonExpanded.toggle()
                            }
                            withAnimation(.easeIn(duration: 0.2).delay(0.2)) {
                                priceInfoExpanded.toggle()
                            }
                        } else {
                            withAnimation(.easeIn(duration: 0.2)) {
                                priceInfoExpanded.toggle()
                            }
                            withAnimation(.easeIn(duration: 0.2).delay(0.2)) {
                                priceButtonExpanded.toggle()
                            }
                        }
                        
                        
                    }, label: {
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                            
                            
                            HStack {
                                Text("$\(price)")
                                    .font(.system(size: fontSize))
                                    .tracking(1)
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 12)
                                    .rotationEffect(priceButtonExpanded ? .degrees(180) : .zero)
                            }
                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                            
                            
                        }
                        .frame(width: priceButtonExpanded ? expandedWidth : normalWidth, height: 40)
                        
                        
                        
                    })
                    .buttonStyle(PlainButtonStyle())
                    .position(x: priceButtonExpanded ? expandedWidth/2 : normalWidth/2, y: wrapView.size.height/2)
                    
                    
                    
                    
                    ZStack {
                        Color.white
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(itemTitle)
                                .tracking(1)
                                .multilineTextAlignment(.leading)
                                .textCase(.uppercase)
                                .font(.system(size: fontSize).weight(.medium))
                            
                            Spacer()
                            
                            Button(action: {
                                destinationView(AnyView(destination))
                            }, label: {
                                Text("BUY NOW")
                                    .tracking(2)
                                    .multilineTextAlignment(.leading)
                                    .textCase(.uppercase)
                                    .font(.system(size: fontSize))
                                    .accentColor(.black)
                                    .overlay(Rectangle().frame(height: 1).offset(y: 4), alignment: .bottom)
                                
                            })
                            .buttonStyle(PlainButtonStyle())
                            
                            
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                        .padding(EdgeInsets(top: 15, leading: 15, bottom: 19, trailing: 15))
                    }
                    .opacity(priceInfoExpanded ? 1 : 0)
                    .frame(maxWidth: expandedWidth, maxHeight: normalWidth)
                    .scaleEffect(x: 1, y: priceInfoExpanded ? 1 : 0, anchor: .top)
                    .position(x: 80, y: wrapView.size.height/2 + 80)
                }
                
            }
        }
        
    }
    
    private func getOpacity(fullProxy:GeometryProxy, itemProxy:GeometryProxy, product:ProductScrollItem) -> Double {
        
        let middle = fullProxy.size.height/2 + 40
        
        let opacity = middle > itemProxy.frame(in: .global).minY && middle < itemProxy.frame(in: .global).maxY ? 0 : 0.5
        
        DispatchQueue.main.async {
            
            if opacity == 0 {
                if let unwrappedPrice = product.price {
                    price = String(format: "%.2f", unwrappedPrice)
                } else {
                    price = "N/a"
                }
                itemTitle = product.title
                destination = product.destination
            }
            
        }
        
        
        
        return opacity
    }
    
}

//struct ProductScroll_Previews: PreviewProvider {
//    @State static var products = [
//        ProductScrollItem(price: 100),
//        ProductScrollItem(price: 100)
//    ]
//    static var previews: some View {
//        ProductScroll(items: $products)
//    }
//}