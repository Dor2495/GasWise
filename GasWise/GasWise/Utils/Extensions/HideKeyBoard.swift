//
//  HideKeyBoard.swift
//  GasWise
//
//  Created by Dor Mizrachi on 25/03/2025.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
