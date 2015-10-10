//
//  AKDistortion.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import AVFoundation

public class AKDistortion: AKOperation {

    var internalAU: AKDistortionAudioUnit?
    var token: AUParameterObserverToken?

    var pregainParameter:                AUParameter?
    var postiveShapeParameterParameter:  AUParameter?
    var negativeShapeParameterParameter: AUParameter?
    var postgainParameter:               AUParameter?

    public var pregain: Float = 2.0 {
        didSet {
            pregainParameter?.setValue(pregain, originator: token!)
        }
    }
    public var postiveShapeParameter: Float = 0.0 {
        didSet {
            postiveShapeParameterParameter?.setValue(postiveShapeParameter, originator: token!)
        }
    }
    public var negativeShapeParameter: Float = 0.0 {
        didSet {
            negativeShapeParameterParameter?.setValue(negativeShapeParameter, originator: token!)
        }
    }
    public var postgain: Float = 0.5 {
        didSet {
            postgainParameter?.setValue(postgain, originator: token!)
        }
    }

    public init(_ input: AKOperation) {
        super.init()

        var description = AudioComponentDescription()
        description.componentType         = kAudioUnitType_Effect
        description.componentSubType      = 0x64697374 /*'dist'*/
        description.componentManufacturer = 0x41754b74 /*'AuKt'*/
        description.componentFlags        = 0
        description.componentFlagsMask    = 0

        AUAudioUnit.registerSubclass(
            AKDistortionAudioUnit.self,
            asComponentDescription: description,
            name: "Local AKDistortion",
            version: UInt32.max)

        AVAudioUnit.instantiateWithComponentDescription(description, options: []) {
            avAudioUnit, error in

            guard let avAudioUnitEffect = avAudioUnit else { return }

            self.output = avAudioUnitEffect
            self.internalAU = avAudioUnitEffect.AUAudioUnit as? AKDistortionAudioUnit
            AKManager.sharedInstance.engine.attachNode(self.output!)
            AKManager.sharedInstance.engine.connect(input.output!, to: self.output!, format: nil)
        }

        guard let tree = internalAU?.parameterTree else { return }

        pregainParameter                = tree.valueForKey("pregain")                as? AUParameter
        postiveShapeParameterParameter  = tree.valueForKey("postiveShapeParameter")  as? AUParameter
        negativeShapeParameterParameter = tree.valueForKey("negativeShapeParameter") as? AUParameter
        postgainParameter               = tree.valueForKey("postgain")               as? AUParameter

        token = tree.tokenByAddingParameterObserver {
            address, value in

            dispatch_async(dispatch_get_main_queue()) {
                if address == self.pregainParameter!.address {
                    self.pregain = value
                }
                else if address == self.postiveShapeParameterParameter!.address {
                    self.postiveShapeParameter = value
                }
                else if address == self.negativeShapeParameterParameter!.address {
                    self.negativeShapeParameter = value
                }
                else if address == self.postgainParameter!.address {
                    self.postgain = value
                }
            }
        }

    }
}