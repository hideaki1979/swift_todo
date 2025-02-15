//
//  ContentView.swift
//  Todo
//
//  Created by 鏡秀明 on 2025/01/31.
//

import SwiftUI

struct ContentView: View {
    @State var displayedTodos: [Todo] = []
    @State var todoValue = ""
    @State var showAlert: Bool = false
    let fileURL: URL = .documentsDirectory.appending(component: "todos.json")
//    let seasons = ["spring", "summer", "fall", "winter"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Todo", text: $todoValue) // 後ろ側追記: 同上
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                Button("Enter") {
                    let trimmedTodoValue = todoValue.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmedTodoValue.isEmpty {
                        showAlert = true
                        return
                    }
                    do {
                        try saveTodo(value: trimmedTodoValue) // tryをつけてメソッドを呼び出す
                        displayedTodos = try loadTodos()
                        todoValue = ""
                    } catch {
                        print(error.localizedDescription) //tryの処理が失敗したときの処理
                    }
                }
                .buttonStyle(.bordered)
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .padding()
            .background(.yellow)
//            Spacer()
            List(displayedTodos, id: \.self) { // 要素をtodoで指定
                todo in
                Text(todo.value)
            }
        }
        .onAppear {
            do {
                displayedTodos = try loadTodos()
            } catch {
                print(error.localizedDescription)
            }
        }
        .alert("入力エラー", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("タスク名を入力してください。")
        }
    }
    
    func saveTodo(value: String) throws {
        let todo = Todo(id: UUID(), value: value)
        displayedTodos.append(todo)
        let data = try JSONEncoder().encode(displayedTodos)
        try data.write(to: fileURL)
    }
    
    func loadTodos() throws -> [Todo] {
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([Todo].self, from: data)
    }
}

#Preview {
    ContentView()
}
