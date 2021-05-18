//
//  ProductScroll.swift
//  ProductScrollExample
//
//  Created by JoeShon Monroe on 5/8/21.
//

import SwiftUI

/**
    Presents a scroll view of products with the model ProductScrollItem.
 */
struct ProductScroll: View {
    
    /// A Binding array of ProductScrollItem.
    @Binding var items:[ProductScrollItem]
    
    /// The starting width of the price button.
    @State var normalWidth:CGFloat = 120
    
    /// The expanded width of the price button when tapped.
    @State var expandedWidth:CGFloat = 160
    
    /// The base font size for product information.
    @State var fontSize:CGFloat = 12
    
    /// The scroll item height.
    @State var itemHeight:CGFloat = 200
    
    /// The price shown in the price button.
    @State var price:String = "N/a"
    
    /// Boolean to toggle the price button width.
    @State private var priceButtonExpanded:Bool = false
    
    /// Boolean to toggle the price info showing.
    @State private var priceInfoExpanded:Bool = false
    
    /// The current ProductScrollItem title shown in the info tab.
    @State private var itemTitle:String = ""
    
    /// The destination view of the buy now button.
    @State private var destination:AnyView = AnyView(EmptyView())
    
    
    /// The function that returns the destination view in a closure to the parent view.
    @State var destinationView:(AnyView) -> ()
    
    /// Detect if the user has accessiblity enabled to enable helpful features.
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    
    var body: some View {
        GeometryReader { wrapView in
            ZStack {
                GeometryReader { fullView in
                    
                    if items.count > 0 {
                        ScrollView(.vertical) {
                            ScrollViewReader { value in
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
                                                        .accessibility(label: Text("The \(item.title)"))
                                                }
                                                
                                                Rectangle()
                                                    .fill(Color.white)
                                                    .opacity(getOpacity(fullProxy: fullView, itemProxy: geo, product: item))
                                                
                                            }
                                            
                                        }
                                        .frame(width: fullView.size.width, height: fullView.size.height/1.7)
                                        .id(item.id)
                                        .onTapGesture {
                                            
                                            // double tap to scroll to item when in voice over mode
                                            if accessibilityEnabled {
                                                value.scrollTo(item.id)
                                            }
                                        }
                                    }
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
                                .accessibility(label: Text("No Products Available"))
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
                    .accessibility(label: Text("The \(itemTitle) has a price of \(price)"))
                    
                    
                    
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
    
    /**
     This function returns the item opacity and sets the item info for the price button.
        - Parameter fullProxy: The GeometryProxy of the scroll view.
        - Parameter itemProxy: The GeometryProxy of the ProductScrollItem in the scroll view.
        - Parameter product: The ProductScrollItem data.
        - Returns: The opacity as a Double.
     */
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


