//
//  ViewModel.swift
//  MVVMTemplate

import Combine
import Foundation

protocol ViewModel: ObservableObject, HasDisposeBag where ObjectWillChangePublisher.Output == Void {
    associatedtype State
    associatedtype Input // If there is no events, just use `Never`

    var state: State { get set }
    func trigger(_ input: Input)
}

extension AnyViewModel: Identifiable where State: Identifiable {
    var id: State.ID {
        state.id
    }
}

@dynamicMemberLookup
final class AnyViewModel<State, Input>: ViewModel {

    private let wrappedObjectWillChange: () -> AnyPublisher<Void, Never>
    private let wrappedTrigger: (Input) -> Void
    private let wrappedStateGetter: () -> State
    private let wrappedStateSetter: (State) -> Void

    var objectWillChange: AnyPublisher<Void, Never> {
        wrappedObjectWillChange()
    }

    var state: State {
        get { wrappedStateGetter() }
        set { wrappedStateSetter(newValue) }
    }

    func trigger(_ input: Input) {
        wrappedTrigger(input)
    }

    subscript<Value>(dynamicMember keyPath: KeyPath<State, Value>) -> Value {
        state[keyPath: keyPath]
    }

    init<V: ViewModel>(_ viewModel: V) where V.State == State, V.Input == Input {
        self.wrappedObjectWillChange = { viewModel.objectWillChange.eraseToAnyPublisher() }
        self.wrappedTrigger = viewModel.trigger
        self.wrappedStateGetter = { viewModel.state }
        self.wrappedStateSetter = { state in viewModel.state = state }
    }

}
