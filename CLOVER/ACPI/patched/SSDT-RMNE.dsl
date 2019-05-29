// Necessary hotpatch, pair with NullEthernet.kext
// Maintained by: Rehabman
// Reference: https://github.com/RehabMan/OS-X-Null-Ethernet/blob/master/SSDT-RMNE.dsl by Rehabman
// Fake an ethernet card to make the system still allow Mac App Store access, work with NullEthernet.kext.

DefinitionBlock ("", "SSDT", 2, "hack", "_RMNE", 0x00000000)
{
    External (DTGP, MethodObj)    // 5 Arguments

    Device (RMNE)
    {
        Name (_ADR, Zero)  // _ADR: Address
        Name (_HID, "NULE0000")  // _HID: Hardware ID
        Name (MAC, Buffer (0x06)
        {
             0x11, 0x22, 0x33, 0x44, 0x55, 0x66               // ."3DUf
        })
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
            Local0 = Package (0x0A)
                {
                    "built-in", 
                    Buffer (One)
                    {
                         0x00                                             // .
                    }, 

                    "IOName", 
                    "ethernet", 
                    "name", 
                    Buffer (0x09)
                    {
                        "ethernet"
                    }, 

                    "model", 
                    Buffer (0x15)
                    {
                        "RM-NullEthernet-1001"
                    }, 

                    "device_type", 
                    Buffer (0x09)
                    {
                        "ethernet"
                    }
                }
            DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
            Return (Local0)
        }
    }
}

