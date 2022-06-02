//
//  ViewModelBase.swift
//  Created by Artjoms Spole on 31/05/2022.
//

import Combine

class ViewModelBase<State, Input>: NSObject, ViewModelObject {
    
    @Published var state: State
    var bindings: [AnyCancellable] { [] }
    
    init(
        state: State
    ) {
        self.state = state
        super.init()
        bind()
        print("🐣 init \(String(describing: self))")
    }
    
    deinit {
        print("☠️ deinit \(String(describing: self))")
    }
    
    final func bind() {
        bindings.forEach { $0.store(in: &cancelables) }
    }
    
    func trigger(
        _ input: Input
    ) {
        fatalError("Override!")
    }
}
