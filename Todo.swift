//
//  Todo.swift
//  Todo
//
//  Created by 鏡秀明 on 2025/01/31.
//
import Foundation

struct Todo: Hashable, Codable {
    let id: UUID
    let value: String
}
