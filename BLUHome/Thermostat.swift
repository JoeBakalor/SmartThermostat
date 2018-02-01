//
//  Thermostat.swift
//  BLUHome
//
//  Created by Joe Bakalor on 4/7/17.
//  Copyright © 2017 Joe Bakalor. All rights reserved.
//

import Foundation
import CoreBluetooth

/*THERMOSTAT SERVICE STRUCTURE
 <Thermostat Service UUID: 2F070118-4E7B-4ECE-A286-B15AEDA498D7>
 
    <Current Temperature Characteristic UUID: 6C893BAA-7689-4EF3-90F5-209656E8A858>
 
        </Properties Read:"TRUE" Write:"FALSE" Notify:"TRUE" Indicate:"TRUE" EncryptionRequired:"NO">
 
    </Current Temperature Characteristic>
 
 
    <Desired Temperature Characteristic UUID: C890465C-0CA0-4D1D-B188-D7850FCCFCC1>
 
        </Properties Read:"TRUE" Write:"TRUE" Notify:"YES" Indicate:"YES" EncryptionRequired:"YES">
 
    </Desired Temperature Characteristic>
 
 
    <Climate Control Setting Characteristic UUID: 13DD483E-541A-4A3E-A796-26287D6D46C3>
 
        </Properties Read:"TRUE" Write:"TRUE" Notify:"TRUE" Indicate:"TRUE" EncryptionRequired:"YES">
 
    </Climate Control Setting Characteristic>
 
 
    <Fan Setting Characteristic UUID: 63A3D3F6-AE79-42FB-9067-8CBE77847BEB>
 
        </Properties Read:"TRUE" Write:"TRUE" Notify:"TRUE" Indicate:"TRUE" EncryptionRequired:"YES">
 
    </Fan Setting Characteristic>
 
 
 </Thermostat Service>
 
 */

class Thermostat: NSObject
{
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    public enum climateControl
    {
        case on
        case off
        case auto
    }
    
    public enum fan
    {
        case on
        case off
        case auto
    }
    
    struct thermostatParameters
    {
        var currentTemperature = 0
        var desiredTemeprature = 0
        var climateControlSetting: climateControl = .auto
        var fanSetting: fan = .auto
    }
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    var thermostatState: thermostatParameters?
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    override init()
    {
        
        super.init()
        thermostatState = thermostatParameters()
    }
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    func changeDesiredTemperature(_ upOrDown: Bool)
    {
        if upOrDown{
            
            thermostatState?.desiredTemeprature += 1
        }else{
            
            thermostatState?.desiredTemeprature -= 1
        }
        
    }
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    func changeClimateControlSetting(to setting: climateControl)
    {
        switch setting{
            
        case .on: print("")
            thermostatState?.climateControlSetting = .on
        case .off: print("")
            thermostatState?.climateControlSetting = .off
        case .auto: print("")
            thermostatState?.climateControlSetting = .auto
        }
    }
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
    func changeFanSetting(to setting: fan)
    {
        switch setting{
            
        case .on: print("")
            thermostatState?.fanSetting = .on
        case .off: print("")
            thermostatState?.fanSetting = .off
        case .auto: print("")
            thermostatState?.fanSetting = .auto
            
        }
    }
    /*============================================================================*/
    //
    //
    //
    /*============================================================================*/
}
