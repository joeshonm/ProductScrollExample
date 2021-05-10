# Product Scroll Example

Re-creating the product scroll on the shop tab of the Adidas Confirmed iOS app in SwiftUI.

## Summary

The inspiration for this example comes from the Adidas Confirmed app. I challenged myself to recreate the product scroll functionality on the shop tab completely in SwiftUI.

One of the main features I used was GeometryReader which returns the size and coordinates of the views it encapsulates. This allows me to calculate when the next product is reaching the desired trigger point. Once that point is reached the that product had 100% opacity and the others 50% to make it stand out.

The next key item was the price tab that is stationary on the left side. The price changes as a new product scrolls into the trigger area. It also updates the title and product destination that can be viewed when clicking the price tab. This also utilizes SwiftUI animations to mimic the animations in the Adidas Confirmed app.

I used a custom model call ProductScrollItem to add products to the Binding array for the custom ProductScroll view. You can also add a destination view by wrapping it with AnyView() to allow the main ContentView to navigate to the product's page. In the example I'm only passing the title of the shoes as a Text view.

```swift
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
```

The example contains photos of Adidas shoes I downloaded from their website. I do not own the rights to these images and they are used purely for example purposes.

Feel free to copy and reuse!

Enjoy!
