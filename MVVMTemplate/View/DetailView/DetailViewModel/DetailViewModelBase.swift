//
//  DetailViewModelBase.swift
//  Created by Artjoms Spole on 31/05/2022.
//

import Combine

class DetailViewModelBase: ViewModelBase<DetailView.ViewState, DetailView.ViewInput> {
    
    let diappearSubject = PassthroughSubject<Void, Never>()
    
    init() {
        super.init(
            state: .init(
                didDisappearPublisher: diappearSubject.eraseToAnyPublisher()
            )
        )
    }
    
    override var bindings: [AnyCancellable] {
        [
            Timer.publish(every: 1, on: .main, in: .default)
                    .autoconnect()
                    .assignWeakly(to: \.state.date, on: self)
        ]
    }
    
    override func trigger(
        _ input: DetailView.ViewInput
    ) {
        switch input {
        case .disappeared:
            diappearSubject.send()
        }
    }
    
}
