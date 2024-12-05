//
//  PromoCodesViewModel.swift
//  PromoKit
//
//  Created by Jan Armbrust on 05.12.2024.
//

import SwiftUI

@Observable
class PromoCodesViewModel {
    var promoCodes: [PromoCode] = []

    func readPromoCodes(from fileURL: URL) {
        do {
            guard fileURL.startAccessingSecurityScopedResource() else {
                print("Unable to access the file at \(fileURL.path).")
                return
            }
            defer { fileURL.stopAccessingSecurityScopedResource() }

            let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
            let lines = fileContents.split(separator: "\n")

            promoCodes =
                lines
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
                .map { PromoCode(code: $0) }
        } catch {
            print("Error reading file: \(error)")
        }
    }
}
