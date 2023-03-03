//
//  View.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 03/03/2023.
//

import SwiftUI

extension View {
    
    @ViewBuilder func isHidden(_ isHidden: Bool) -> some View {
        
        if isHidden {
            self.hidden()
            
        } else {
            self
        }
    }
}
