//
//  TuningSystem.swift
//  Pitch
//
//  Created by James Bean on 8/19/18.
//

/// Interface for tuning systems.
public protocol TuningSystem { }

protocol EDO: TuningSystem { }

protocol EDO12: EDO { }
protocol EDO24: EDO { }
protocol EDO48: EDO { }
