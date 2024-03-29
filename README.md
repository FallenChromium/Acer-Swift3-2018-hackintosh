[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=A2NSUEHT9PMQC&source=url)
# macOS 12 Monterey on Acer Swift 3 SF315-51

## Specs

- CPU : Intel Core i5-8250U (Kabylake-R)
- Graphics : Intel UHD 620 (+ NVidia GeForce MX150 in some models)
- RAM : 8 GB DDR4 2133 MHz (non-replaceable)
- SSD : 256 GB Intel 600p series (SSDPEKKW256G7) (M.2 2280 NVMe, replaceable. PCIe x2 speeds (1500MBs\540MBs) )
- Screen : 15-inch 1920 x 1080 glossy IPS
- Ports : 1xUSB 3.1 Gen-1 Type-C, 2xUSB 3.0, 1xUSB 2.0, 1xHDMI (full-size), 1xAudio jack
- Wifi/Bluetooth : Intel AC-7265, (M.2 NGFF)
- Audio : ALC255 (ven id:10ec, dev id:0255)
- SD Card Reader : Realtek USB2.0-CRW (ven id:0bda, dev id:0129)
- Back-lit keyboard
- I2C Trackpad + PS2 keyboard

## What is working

- Graphics  
Intel UHD Graphics 620 1536 МB
    - QE\CI, Final Cut X works just fine
    - SSDT is added to disable NVidia discrete GPU (not supported under macOS) 

- Audio
    - Speakers, headphones and internal mic

- Keyboard
    - Backlight is ACPI-managed so it works just fine too

- Trackpad
    - VoodooI2C makes it buttery-smooth, supports all the macOS gestures
    - Additional SSDT is added to use the trackpad  in a mode with bigger precision and less power consumption

- USB
    - Some injections has to be done and it may vary from model to model, more details below

- Webcam

- Sleep/Wake
    - Lid also working
    - To my knowledge, no weird things after sleep/wake (sound problems may occur, report an Issue if you have faced this problem)
        - If you disable the wifi with Acer's keyboard shortcut (Fn+F3) and go to sleep, wifi won't be able to be enable. You'll have to reboot the laptop.
    - At least 6 hours battery life
        - Tested with 10.13.4 (max brightness, 720p on safari, USB wifi dongle)

## What is NOT working

- Built-in Wifi\BT card
    - Stock Wi-Fi card can be used with [itlwm](https://github.com/OpenIntelWireless/itlwm) and [IntelBluetoothFirmware](https://github.com/OpenIntelWireless/IntelBluetoothFirmware), but because I don't have stock card anymore and I use Broadcom Wi-Fi for AirDrop and Continuity, if you want to use the stock wi-fi card, try to make it work yourself. On success, feel free to open an issue to describe your efforts and pull request to help other people!

- Built-in SD card reader


- Fingerprint
    - It's detected but it is useless (can't authenticate on lockscreen or in password manager), so I decided to disable that port.


- SSD. I had kernel panics with Intel 660p, I don't know if it works now, but 10.13.4 and lower certainly had problems with it. As far as I know, not a problem anymore with Catalina and up.
    - Replaced with Samsung EVO970 250GB
- NVidia GPU (not supported by macOS)

**What was not tested**

- HDMI

## Optional things to do

- Replace Wi-Fi module
    - I've installed DW1560 which is based on Broadcom BCM94352Z, all is working great

- Replace SSD (stock one may or may not work fine, you should note that it can cause kernel panics)
    - Replaced with EVO970 250GB

## 1. Updating BIOS to the latest version and BIOS configuration

Install
 latest BIOS with fixes for your laptop, it can be found in "Support" 
tab on official Acer website (I have 1.05 at the moment)

Once the update is done, go in your BIOS setup. For my model, I must press F2 at boot. Press F9 to reset default settings. Enable "F12 Boot Menu" in Main tab. Set Supervisor Password in Security tab. Disable "Secure Boot" in Boot tab. Save changes.

## 2. OpenCore EFI bootloader installation

Install OpenCore (the easy way)

- mount the EFI partition you need, for example on macOS it is `sudo mkdir /Volumes/*mountpointname*` (for example `sudo mkdir /Volumes/EFI`) and after that `sudo mount -t msdos /dev/diskXsY /Volumes/*mountpointname*` (in my case sudo `mount -t msdos /dev/disk0s1 /Volumes/EFI` if I want to mount SSD's first partition)
- Copy the EFI folder from [latest releases archive](https://github.com/FallenChromium/Acer-Swift3-2018-hackintosh/releases) to your drive
- Done!

## 3. Installation guide
- Create an installation USB drive with any convenient method (BDU\UniBeast\createinstallmedia\restore HFS file\etc.)
- Install OpenCore on the USB drive (as shown above). In case of UniBeast or BDU you might want to delete everything on USB EFI partition before installing
- Shutdown the laptop
- You must press F12 for this Acer laptop at boot to select USB flash drive. (Check if boot menu is enabled in BIOS, you can go to bios by pressing F2 on boot) 
- Maybe you wouldn't be able to use trackpad on installation and for several boot cycles, it's normal, just get a USB mouse to use it. If the installed system wouldn't have trackpad do this in terminal: `sudo kextcache -i /`
- Boot from USB again, choose your SSD boot option now. System may reboot several times, it's fine, always boot with USB until you'll install OpenCore on your SSD.
- That's pretty much it! Install latest release of this repository on your laptop (feel free to DIY it, I'm just describing the easy way).
 

**Allow apps downloaded from Anywhere and other useful configurations**

- In Terminal, type the following : 
`sudo spctl --master-disable`
- In Finder &gt; Preferences &gt; General &gt; Select to show hard disks on the desktop
- In System Preferences &gt; User and groups
    - Click on the lock and type your password
    - Click on Login Options and select your user in Automatic login

It just speeds up the configuration. You can put it back as it was after this guide.




**Optimize**


- You may change boot entries, timeout and add additional boot options if you want.
- ❗️ Make sure to generate proper SMBIOS, because all serial numbers are zeroed out in this repository. This is required to use Apple ID, iMessage and App Store. See [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS)
- If you use Intel SSD, make sure TRIM works, lack of it can lead to serious performance issues.
- You may remap brightness controls to F10-F11 as I did, stock keys require an SSDT patch which I didn't make at the moment.

At this point, you may eject your installation drive and reboot.

**Messages and FaceTime fix**

The simplest guide I found was the one here : [https://www.tonymacx86.com/threads/simple-imessage-guide-for-yosemite-and-el-capitan.186276/](https://www.tonymacx86.com/threads/simple-imessage-guide-for-yosemite-and-el-capitan.186276/) , but I didn't have any problems from start.

**P.S**
Feel free to create issues to fix my guide or give me some suggestions, you're welcome! Also, more comprehensive and descriptive guide can be found [here](https://www.tonymacx86.com/threads/guide-acer-swift-3-i5-8250u-mojave.249160/)

**Credits:**

[**Apple**](http://apple.com) for macOS

[**Acer**](http://acer.com) for laptop

[**RehabMan**](https://github.com/RehabMan) for great guides and useful files

[**alex.daoud**](https://github.com/alexandred) for VoodooI2C kext and hints for making it work with our trackpad.

[**ioreknanou**](https://www.tonymacx86.com/threads/guide-acer-swift-3-macos-sierra-10-12-2.210393/members/ioreknanou.80739/) for making guide for older model, this guide is an edit of [this](https://www.tonymacx86.com/threads/guide-acer-swift-3-macos-sierra-10-12-2.210393/)

[**acidanthera**](https://github.com/acidanthera) for awesome kexts and first-class support for hackintosh enthusiasts

[Daliansky](https://github.com/daliansky/XiaoMi-Pro-Hackintosh) for awesome reference "hackintosh setup for a laptop" repository

**Other Useful Links**

[https://www.tonymacx86.com/threads/faq-read-first-laptop-frequent-questions.164990/](https://www.tonymacx86.com/threads/faq-read-first-laptop-frequent-questions.164990/)

[http://www.insanelymac.com/forum/topic/312759-fix-macos-sierra-dp1-bcm94532z-wifi/](http://www.insanelymac.com/forum/topic/312759-fix-macos-sierra-dp1-bcm94532z-wifi/)

[https://www.tonymacx86.com/threads/guide-patching-dsdt-ssdt-for-laptop-backlight-control.152659/](https://www.tonymacx86.com/threads/guide-patching-dsdt-ssdt-for-laptop-backlight-control.152659/)
