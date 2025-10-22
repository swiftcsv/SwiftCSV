//
//  Array+duplicates.swift
//
//
//  Created by 胡逸飞 on 2024/4/26.
//

extension Array where Element: Hashable {
    func duplicates() -> [Element] {
        let counts = self.reduce(into: [:]) { counts, element in counts[element, default: 0] += 1 }
        return counts.filter { $0.value > 1 }.map { $0.key }
    }
}
