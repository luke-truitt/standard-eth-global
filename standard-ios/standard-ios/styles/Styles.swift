//
//  Styles.swift
//  standard-ios
//
//  Created by Work on 5/8/21.
//

import SwiftUI

struct RoundedFilledButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Spacer()
      configuration.label.foregroundColor(.white)
      Spacer()
    }
    .padding()
    .background(Color.accentColor.cornerRadius(8))
    .scaleEffect(configuration.isPressed ? 0.95 : 1)
  }
}
struct RoundedOutlinedButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Spacer()
        configuration.label.foregroundColor(Color.accentColor)
      Spacer()
    }
    .padding()
    .background(
        RoundedRectangle(cornerRadius: 8)
            .strokeBorder(Color.accentColor, lineWidth: 1))
    .scaleEffect(configuration.isPressed ? 0.95 : 1)
  }
}
 struct RoundedRectangleTextFieldStyle : TextFieldStyle {
        public func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding() // Set the inner Text Field Padding
                //Give it some style
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.primary.opacity(0.2), lineWidth: 1))
        }}

struct AmountTextFieldStyle : TextFieldStyle {
       public func _body(configuration: TextField<Self._Label>) -> some View {
           configuration
               .padding()
            .font(.system(size: 70, weight: .regular, design: .default)).multilineTextAlignment(.center)// Set the inner Text Field Padding
               //Give it some style
       }}
    
