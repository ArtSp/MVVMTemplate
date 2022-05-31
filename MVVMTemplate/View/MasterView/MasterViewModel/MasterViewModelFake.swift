//
//  MasterViewModelFake.swift
//  Created by Artjoms Spole on 31/05/2022.
//

final class MasterViewModelFake: MasterViewModelBase {
    
    override func loadData() {
        print("Loading")
    }
    
    override func createDetailViewModel() -> DetailView.ViewModel {
        DetailViewModelFake().toAnyViewModel()
    }
    
}
