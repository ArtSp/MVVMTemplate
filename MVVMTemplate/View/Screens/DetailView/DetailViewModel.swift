//
//  DetailViewModel.swift
//  Created by Artjoms Spole on 31/05/2022.
//

import Combine
import Foundation

// MARK: - DetailViewModelBase

class DetailViewModelBase: ViewModelBase<DetailView.ViewState, DetailView.ViewInput> {
    
    let timerSubject = CurrentValueSubject<TimeInterval, Never>(.zero)
    var appearDate: Date?
    
    init() {
        super.init(
            state: .init(
                displayTimePublisher: timerSubject.eraseToAnyPublisher()
            )
        )
    }
    
    override var bindings: [AnyCancellable] {
        [
            Timer.publish(every: 1, on: .main, in: .default)
                    .autoconnect()
                    .handleEvents(receiveOutput: { [weak self] date in
                        guard let appearDate = self?.appearDate else { return }
                        self?.timerSubject.send(date.timeIntervalSince(appearDate).rounded(.up))
                    })
                    .assignWeakly(to: \.state.date, on: self)
        ]
    }
    
    override func trigger(
        _ input: DetailView.ViewInput
    ) {
        switch input {
        case let .isVisible(visible):
            if visible && appearDate.isNil {
                appearDate = .init()
            }
            print("Details is \(visible ? "" : "not ")visible")
        }
    }
    
}

// MARK: - DetailViewModelImpl

final class DetailViewModelImpl: DetailViewModelBase { }

// MARK: - DetailViewModelFake

final class DetailViewModelFake: DetailViewModelBase { }
