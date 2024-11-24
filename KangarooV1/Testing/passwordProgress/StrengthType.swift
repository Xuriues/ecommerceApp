//
//  StrengthType.swift
//  KangarooV1
//
//  Created by Shaun on 10/12/20.
//

import Foundation
enum StrengthType {
    case weak
    case medium
    case strong
    case veryStrong
}

public enum ValidationRequiredRule {
    case lowerCase
    case uppercase
    case digit
    case specialCharacter
    case oneUniqueCharacter
    case minmumLength
}
