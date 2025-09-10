//
//  ActivitySpinner.swift
//  WeatherApp
//
//  Created by Sneha Jaiswal on 9/8/25.
//

import SwiftUI

struct ActivitySpinner: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let v = UIActivityIndicatorView(style: .medium)
        v.startAnimating()
        return v
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) { }
}
