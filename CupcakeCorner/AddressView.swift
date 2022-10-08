//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Николай Никитин on 08.10.2022.
//

import SwiftUI

struct AddressView: View {

  @ObservedObject var order: Order

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
      AddressView(order: Order())
    }
}
