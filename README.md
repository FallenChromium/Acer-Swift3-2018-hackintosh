macOS 10.14.5 Mojave on Acer Swift 3 SF315-51-518S

**Specs**

- CPU : Intel Core i5-8250U (Kabylake-R)
- Graphics : Intel UHD 620
- RAM : 8 GB DDR4 2133 MHz (non-replaceable)
- SSD : 256 GB Intel 600p series (SSDPEKKW256G7) (M.2 2280 NVMe, replaceable. PCIe x2 speeds (1500MBs\540MBs) )
- Screen : 15-inch 1920 x 1080 glossy IPS
- Ports : 1xUSB 3.1 Gen-1 Type-C, 2xUSB 3.0, 1xUSB 2.0, 1xHDMI (full-size), 1xAudio jack
- Wifi/Bluetooth : Intel AC-7265, (M.2 NGFF)
- Audio : ALC255 (ven id:10ec, dev id:0255)
- SD Card Reader : Realtek USB2.0-CRW (ven id:0bda, dev id:0129)
- Back-lit keyboard
- I2C Trackpad + PS2 keyboard

**What is working**

- Graphics  
Intel UHD Graphics 620 1536 МB
    - QE\CI, Final Cut X works just fine

- Audio
    - Speakers, headphones and internal mic

- Keyboard
    - Backlight is ACPI-managed so it works just fine too

- Trackpad
    - VoodooI2C makes it buttery-smooth, supports all the macOS gestures

- USB
    - Some injections has to be done and it may vary from model to model, more details below

- Webcam
    - PhotoBooth works fine ![:D](data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7) "Big Grin    :D"

- Sleep/Wake
    - Lid also working
    - To my knowledge, no weird things after sleep/wake
        - If
 you disable the wifi with Acer's keyboard shortcut (Fn+F3) and go to 
sleep, wifi won't be able to be enable. You'll have to reboot the 
laptop.

- At least 6 hours battery life
    - Tested with 10.13.4 (max brightness, 720p on safari, USB wifi dongle)

**What is NOT working **

- Built-in Wifi
    - Must be replaced

- Built-in SD card reader
- Fingerprint. 
    - It's
 detected but it is useless (can't authenticate on lockscreen or in 
password manager), so I decided to disable that port (I got shitloads of
 BiometricKit errors)

- SSD. I had kernel panics with Intel 660p, I don't know if it works now, but 10.13.4 and lower certainly had problems with it.
    - Replaced with Samsung EVO970 250GB

**What was not tested **

- HDMI

**What must be done**

- Replace Wi-Fi module
    - I've installed DW1560 which is based on Broadcom BCM94352Z, all is working great

- Replace SSD (stock one may or may not work fine, you should note that it can cause kernel panics)
    - Replaced with EVO970 250GB

- Follow my guide

**Updating BIOS to the latest version and BIOS configuration **

Install
 latest BIOS with fixes for your laptop, it can be found in "Support" 
tab on official Acer website (I have 1.05 at the moment)

Once
 the update is done, go in your BIOS setup. For my model, I must presse 
F2 at boot. Press F9 to reset default settings. Enable "F12 Boot Menu" 
in Main tab. Set Supervisor Password in Security tab. Disable "Secure 
Boot" in Boot tab. Save changes.

**Create bootable USB**

[SPOILER="USB
 guide"]You'll need to make a bootable USB drive with macOS installer. 
There are plenty of methods, the one of popular ones is UniBeast, but it
 required internet connection on install, and it was a no-go for me. You
 can use anything, like BootDiskUtility a.k.a BDU if you're on Windows 
and so on. I decided to prepare Installer with "createinstallmedia" 
method. You may check it [here](https://support.apple.com/en-euro/HT201372),
 but in short, you need to format your flash drive to GUID partition 
table and JHFS+ filesystem, download latest installer from Mac App Store
 and rewrite your flash drive by that command

Code (Text):

sudo /Applications/Install\ macOS\ Mojave.app/Contents/Resources/createinstallmedia --volume /Volumes/***YOUR FLASH DRIVE NAME*** --applicationpath /Applications/Install\ macOS\ Mojave.app

Then,
 you'll have to instal Clover bootloader on your flash drive. Install it
 on ESP partition and in UEFI-only mode, and choose AptioMemoryFix 
UEFI64 driver to have native NVRAM working. You can read more about that
 in Clover guides section.

After that done, we will have to put some important kexts in the flash drive's EFI partition in folder EFI/CLOVER/kexts/Other.

Add the following kexts:

- [VirtualSMC.kext](https://github.com/acidanthera/VirtualSMC/releases)
- [VoodooPS2Controller.kext](https://bitbucket.org/RehabMan/os-x-voodoo-ps2-controller/downloads)
    - [https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller)
    - If
 you wouldn't have this, keyboard wouldn't work. We'll later add a 
VoodooI2C which will give us smooth trackpad experience, but for now 
you'll need to use this (works kinda jerky on trackpad), better connect 
external mouse

  
[/SPOILER]

**Download additional kexts, config.plist and other useful apps for post-install purposes **

On your flash drive, create a folder named "Post-Install". In that folder, copy the following files and applications :

Clover kexts

- [ACPIBatteryManager.kext](https://bitbucket.org/RehabMan/os-x-acpi-battery-driver/downloads)
    - For battery status showing.

- [AppleALC.kext](https://github.com/vit9696/AppleALC/releases)(release version)
    - To
 make audio work. I got ALC255, so with layout 3 all seems to work fine,
 you may try also 13, 17, 27 or 28(only by Clover injection in 
config.plist)

- [CodecCommander.kext](https://bitbucket.org/RehabMan/os-x-eapd-codec-commander/downloads)
    - Without it I didn't get audio after sleep, but I changed it a bit to fit better.

- [VoodooI2C.kext + VoodooI2CHID.kext](https://github.com/alexandred/VoodooI2C/releases)
- [Lilu.kext](https://github.com/vit9696/Lilu/releases) (for WhateverGreen and AppleALC, probably we'll add up more modules soon)
- [WhateverGreen.kext](https://github.com/acidanthera/WhateverGreen/releases) (can't be sure it's needed)
- [NoTouchID.kext](https://github.com/al3xtjames/NoTouchID/releases) can help with password input lags by making macOS not checking TouchID possibility
- [AirportBrcmFixup.kext](https://github.com/acidanthera/AirportBrcmFixup/releases)​​​ (if you changed the WiFi card) to enable WiFi on BCM94352Z
- ​[BrcmPatchRAM2.kext](https://bitbucket.org/RehabMan/os-x-brcmpatchram/downloads/)​​​ (if you changed the WiFi card) to enable Bluetooth on BCM94352Z  

- U  

Apps

- [Clover EFI bootloader](https://sourceforge.net/projects/cloverefiboot/)
- [Clover Configurator](http://mackie100projects.altervista.org/download-clover-configurator/) (I do not recommend using it, but for beginners it's simpler than text editor)
- [iasl](https://bitbucket.org/RehabMan/acpica/downloads)
- [MaciASL](https://bitbucket.org/RehabMan/os-x-maciasl-patchmatic/downloads)
- [Karabiner-Elements](https://github.com/tekezo/Karabiner-Elements) (optional)

Base config.plist

- I downloaded one from [RehabMan](https://github.com/RehabMan/OS-X-Clover-Laptop-Config), [this](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/config_HD615_620_630_640_650.plist) one. Also I've changed it, but we'll talk about it later.

You may need to download apfs.efi and HFSPlus.efi, it depends on your Clover installer.
 Install ApfsDriverLoader when you're installing Clover to USB or SSD, 
but mind that you will probably need HFSPlus.efi to search for 
installation media on installation step, or you may end up with empty 
Clover list, lul

Once all this is downloaded and copied to your flash drive, reboot the laptop.

**Installation**

- You must press F12 for this Acer laptop at boot to select USB flash drive. I plugged the flash drive in the USB3 port.
- When
 the installation is over and the laptop reboots, it will probably give 
you an error at boot (Default Boot Device Missing or Boot Failed). 
Select OK and, again, boot on your USB flash drive. At Clover 
bootloader, choose to boot on your newly installed macOS drive. This 
step is normal because there is no Clover bootloader yet on your SSD. 
Keep in mind this step because if you will have problems booting from 
your SSD in the future, this could be handy.

**Allow apps downloaded from Anywhere and other useful configurations**

- In Terminal, type the following :  
Code (Text):  
sudo spctl --master-disable
- In Finder&gt;Preferences&gt;General&gt;Select to show hard disks on the desktop
- In System Preferences&gt;User and groups
    - Click on the lock and type your password
    - Click on Login Options and select your user in Automatic login

It just speeds up the configuration. You can put it back as it was after this guide.

**Clover EFI bootloader installation**

Install Clover

- Choose your Mojave drive as destination
- Select the following in the customize installation
    - Install for UEFI booting only
    - Install Clover in the ESP
    - Drivers64UEFI/AptioMemoryFix-64

- Click Install

**Copy files to EFI partition**

After
 the Clover installation, a new volume named EFI will be on the desktop 
and in Finder. Copy the files and apps from your USB flash drive to the 
folowing locations :

- In EFI Volume, EFI/CLOVER/kexts/Other
    - All kexts you downloaded.

- In EFI Volume, EFI/CLOVER
    - Replace config.plist with the one on your USB flash drive.

- In EFI volume, EFI/CLOVER/Drivers64UEFI
    - Look for apfs.efi, HFSPlus.efi. If there are no ones, copy it from your USB flash drive.

**Configure config.plist in Clover Configurator **

- Copy Clover Configurator in Applications
- Open EFI/CLOVER/config.plist (it should open in Clover Configurator)
    - Config your boot volume

- You
 may delete all Nvidia-related patches from config.plist as I did, 
because I have only UHD 620. It needed by 51G model with MX150
- Graphics
    - ig-platform-id = 0x19168086

- KextsToPatch
    - Leave the basic ones patched on RehabMan's config

- SMBIOS
    - I used MacBookPro14,1 SMBIOS

- I
 additionally added "abm_firstpolldelay=6000" flag to boot options for 
ACPIBatteryManager, because it freezes sometimes on stock value. I can't
 be sure I did it right but after that my battery indicator works as it 
should. Don't enable if you're fine with stock one. Also I patched 
battery DSDT but it doesn't seem to help. I need advice on this one, so 
I'm waiting for your replies!

**More information about settings in config.plist **

- ACPI
    - DSDT Patches
        - Taken from RehabMan's "OS-X-Clover-Laptop-Config" for the UHD 620 at [https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/config_HD615_620_630_640_650.plist](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/config_HD615_620_630_640_650.plist)
        - Some patches, like "change GFX0 to IGPU" didn't seemed to work for me. I had to edit my DSDT.

Reboot the laptop. At Clover boot screen press F4. This will dump files in EFI/Clover/ACPI/origin.

- Boot into macOS
- Mount your EFI drive in Clover Configurator
- Copy DSDT.aml and all SSDT*.aml from EFI/Clover/ACPI/origin to a new folder named DSDT on your desktop.
- Copy MaciASL from your USB flash drive to Applications

The
 guide talks about duplicate SSDTs and comparing their size. I have two 
SSDTs with the same size but not the same content so there will be no 
problems later on.

- In Terminal:
    - [code]git clone https://github.com/RehabMan/Intel-iasl.git iasl.git [/code]
        - It should ask you to install git. Install git.

    - [code]git clone https://github.com/RehabMan/Intel-iasl.git iasl.git[/code]
        - Yes, you must do it again.

    - [code]cd iasl.git[/code]
    - [code]make[/code]
    - [code]sudo make install[/code]
    - [code]sudo cp /usr/bin/iasl /Applications/MaciASL.app/Contents/MacOS/iasl61[/code]
    - [code]cd *drag and drop your DSDT folder*[/code]
        - This will put you back to DSDT folder

    - [code]iasl -da -dl *.aml[/code]

- Open MaciASL
    - In preferences, sources tab
    - Add RehabMan's Laptop Patches
        - Site : [http://raw.github.com/RehabMan/Laptop-DSDT-Patch/master](http://raw.github.com/RehabMan/Laptop-DSDT-Patch/master)

    - Add VoodooI2C patch repo (needed for touchpad)
        - [https://github.com/alexandred/VoodooI2C-Patches](https://github.com/alexandred/VoodooI2C-Patches)

- Open all of your dsl files from your DSDT folder.

You should have pretty much the same files as me if you have the same laptop.

- For DSDT.dsl, wait for the file to load completely
    - Search and Replace all "GFX0" for "IGPU"
    - Search and Replace all "HDAS" for "HDEF"
    - Apply Brightness fix patch
    - Apply VoodooI2C GPIO Patch and Windows 10 Patch
    - Find your touchpad device (mine was TPL1), scroll to _INI section and replace  
[code]If (LEqual (SDM1, Zero))  
{  
SHPO (GPLI, One)  
}  
[/code] to  
[code]SHPO (GPLI, One)  
[/code]  
I.e delete If condition so it would load in any case
    - Additionally I had to add [code]\_SB.PCI0.I2C1.TPL1._INI ()[/code] to _WAK method to make touchpad work after sleep
    - Compile and if no errors, save the file as AML file (replace if needed).
    - I
 also applied some generic patches like "HPET patch" they can't harm but
 I don't sure is it needed, so I applied it and it's just working fine, 
it's up to you.

- For every other .dsl
    - Search and Replace all "GFX0" for "IGPU"
    - Compile and if no errors, save the file as AML file (replace if needed)

- Copy ONLY EDITED (don't copy if you didn't replace anything) files from DSDT folder to EFI/CLOVER/ACPI/patched

**Optimize**

- Kexts
    - In
 /ESP/EFI/CLOVER/Kexts/Other/VoodooPS2Controller/Contents/Plugins delete
 mouse and trackpad kexts, because it may interrupt VoodooI2C.

- config.plist
    - You
 may delete all DSDT patches related to Nvidia, disable "nv_disable=1" 
and disable Nvidia injecting if your laptop have only Intel GPU.
    - You may change boot entries, timeout and add additional bootlegs if you want.

**Reboot**

In
 System Preferences, Display, you should now see the Brightness slider. 
You may remap brightness change to F10-F11 as did I, anyway you can't 
use stock brightness shortcut without Karabiner.

**Fn Keyboard Shortcuts (same as on Windows)**

- F3
 : Disconnect from your wireless network. Pressing it again won't 
connect you back. You'll have to manually reselect your wireless 
network.
- F4 : Put laptop to sleep
- F5 : Switch between displays (when you have another monitor)
- F6 : Disable/Enable main display
- F7 (and also PrtSc) : Disable/Enable trackpad
- F9 : Disable/Enable keyboard's backlight
- Up/Down: Volume

**Messages and FaceTime fix **

The simplest guide I found was the one here : [https://www.tonymacx86.com/threads/simple-imessage-guide-for-yosemite-and-el-capitan.186276/](https://www.tonymacx86.com/threads/simple-imessage-guide-for-yosemite-and-el-capitan.186276/) , but I didn't have any problems from start.

**P.S**

I
 can be wrong! Maybe I forgot something writing the guide, maybe 
something is not right at all, please correct me if you found an error.

**Credits:**

[Apple](http://apple.com) for macOS

[Acer](http://acer.com) for laptop

[**RehabMan**](https://www.tonymacx86.com/threads/guide-creating-a-custom-ssdt-for-usbinjectall-kext.211311/members/rehabman.429483/) for great guides and useful files

[**alex.daoud**](https://www.tonymacx86.com/threads/voodooi2c-help-and-support.243378/members/alex-daoud.1269137/) for VoodooI2C kext and hints for making it work with the trackpad.

[**ioreknanou**](https://www.tonymacx86.com/threads/guide-acer-swift-3-macos-sierra-10-12-2.210393/members/ioreknanou.80739/)** **for making guide for older model, this one is edit of [this](https://www.tonymacx86.com/threads/guide-acer-swift-3-macos-sierra-10-12-2.210393/)

[**acidanthera**](https://github.com/acidanthera) for awesome kexts and first-class support for hackintosh enthusiasts

**Other Useful Links**

[https://www.tonymacx86.com/threads/faq-read-first-laptop-frequent-questions.164990/](https://www.tonymacx86.com/threads/faq-read-first-laptop-frequent-questions.164990/)

[http://www.insanelymac.com/forum/topic/312759-fix-macos-sierra-dp1-bcm94532z-wifi/](http://www.insanelymac.com/forum/topic/312759-fix-macos-sierra-dp1-bcm94532z-wifi/)

[https://www.tonymacx86.com/threads/guide-patching-dsdt-ssdt-for-laptop-backlight-control.152659/](https://www.tonymacx86.com/threads/guide-patching-dsdt-ssdt-for-laptop-backlight-control.152659/)
