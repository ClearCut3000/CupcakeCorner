//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Николай Никитин on 09.10.2022.
//

import SwiftUI

struct CheckoutView: View {

  @ObservedObject var order: Order

  @State private var confirmationMessage = ""
  @State private var showingConfirmation = false

    var body: some View {
      ScrollView {
        VStack {
          AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"),
                     scale: 3) { image in
            image
              .resizable()
              .scaledToFit()
          } placeholder: {
            ProgressView()
          }
          .frame(height: 233)
          Text("Your total is: \(order.cost, format: .currency(code: "USD"))")
            .font(.title)
          Button("Place Order", action: {
            Task {
              await placeOrder()
            }
          })
            .padding()
        }
      }
      .navigationTitle("Check Out")
      .navigationBarTitleDisplayMode(.inline)
      .alert("Thanck you!", isPresented: $showingConfirmation) {
        Button("OK") { }
      } message: {
        Text(confirmationMessage)
      }
    }

  //MARK: - Methods
  func placeOrder() async {
    guard let encoded = try? JSONEncoder().encode(order) else {
      debugPrint("Failed to encode")
      return
    }
    let url = URL(string: "https://reqres.in/api/cupcakes")!
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    do {
      let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
      // handle result
      let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
      confirmationMessage = "Your order fom \(decodedOrder.quantity)x\(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
      showingConfirmation = true
    } catch {
      confirmationMessage = "Checkout failed!"
      showingConfirmation = true
    }
  }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
      CheckoutView(order: Order())
    }
}
