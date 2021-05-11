//
//  SwiftUIView.swift
//  standard-ios
//
//  Created by Work on 5/8/21.
//

import SwiftUI

struct OnboardingView: View {
    var formFields: [[String:String]] = [["name":"Name", "var":"name", "type":"string"],["name":"Email address", "var":"email", "type":"string"], ["name":"Phone Number", "var":"phone_number", "type":"number"]]
    
    @State private var formData : [String] = ["", "", ""]
    @State private var formStep: Int = 0
    var onboardComplete : (String, String, String) -> ()

    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            TextField(formFields[formStep]["name"]!, text:$formData[formStep] ).padding(.bottom, 20).textFieldStyle(RoundedRectangleTextFieldStyle())
            Button(formStep == formFields.count-1 ? "Let's Go" : "Continue"){
                if (formStep == formFields.count-1) {
                    onboardComplete(formData[0], formData[1], formData[2])
                }
                else {
                    formStep += 1
                    
                }
            }.buttonStyle(RoundedFilledButtonStyle())
            
        }).padding(20)
    }
}
