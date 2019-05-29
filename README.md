
# macOS 10.14.5 Mojave on Acer Swift 3 SF315-51-518S

## Specs

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

## What is working

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
    - PhotoBooth works fine, lol

- Sleep/Wake
    - Lid also working
    - To my knowledge, no weird things after sleep/wake
        - If you disable the wifi with Acer's keyboard shortcut (Fn+F3) and go to sleep, wifi won't be able to be enable. You'll have to reboot the laptop.
    - At least 6 hours battery life
        - Tested with 10.13.4 (max brightness, 720p on safari, USB wifi dongle)

## What is NOT working

- Built-in Wifi
    - Must be replaced

- Built-in SD card reader
- Fingerprint
    - It's detected but it is useless (can't authenticate on lockscreen or in password manager), so I decided to disable that port (I got shitloads of BiometricKit errors)
- SSD. I had kernel panics with Intel 660p, I don't know if it works now, but 10.13.4 and lower certainly had problems with it.
    - Replaced with Samsung EVO970 250GB

**What was not tested**

- HDMI

## What must be done

- Replace Wi-Fi module
    - I've installed DW1560 which is based on Broadcom BCM94352Z, all is working great

- Replace SSD (stock one may or may not work fine, you should note that it can cause kernel panics)
    - Replaced with EVO970 250GB

- Follow my guide

## 1. Updating BIOS to the latest version and BIOS configuration

Install
 latest BIOS with fixes for your laptop, it can be found in "Support" 
tab on official Acer website (I have 1.05 at the moment)

Once the update is done, go in your BIOS setup. For my model, I must press F2 at boot. Press F9 to reset default settings. Enable "F12 Boot Menu" in Main tab. Set Supervisor Password in Security tab. Disable "Secure Boot" in Boot tab. Save changes.

## 2. Clover EFI bootloader installation

Install Clover

- Choose the drive you need as destination
- Select the following in the customize installation
    - Install for UEFI booting only
    - Install Clover in the ESP
    - Drivers64UEFI/AptioMemoryFix-64
    - Check that ApfsDriverLoader is going to be installed too
- Click Install

## 3. Installation guide
- Create an installation USB drive with any convenient method (BDU\UniBeast\createinstallmedia\restore HFS file\etc.)
- Install Clover on the USB drive (as shown above)
- Replace EFI/CLOVER folder on your USB's EFI partition with CLOVER folder from my repository
- Shutdown the laptop
- You must press F12 for this Acer laptop at boot to select USB flash drive. 
- Maybe you wouldn't be able to use trackpad on installation and for several boot cycles, it's normal, just get a USB mouse to use it. If the installed system wouldn't have trackpad do this in terminal: `sudo kextcache -i /`
- Boot from USB again, choose your SSD boot option now. System may reboot several times, it's fine, always boot with USB until you'll install clover on your SSD.
- That's pretty much it! Install Clover on your laptop, replace with my folder for kexts, SSDT and themes (feel free to DIY it, I'm just describing the easy way).
 

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

**Messages and FaceTime fix**

The simplest guide I found was the one here : [https://www.tonymacx86.com/threads/simple-imessage-guide-for-yosemite-and-el-capitan.186276/](https://www.tonymacx86.com/threads/simple-imessage-guide-for-yosemite-and-el-capitan.186276/) , but I didn't have any problems from start.

**P.S**
Feel free to create issues to fix or suggest my guide, you're welcome! Also, more comprehensive and descriptive guide can be found [here](https://www.tonymacx86.com/threads/guide-acer-swift-3-i5-8250u-mojave.249160/)

**Credits:**

[**Apple**](http://apple.com) for macOS

[**Acer**](http://acer.com) for laptop

[**RehabMan**](https://github.com/RehabMan) for great guides and useful files

[**alex.daoud**](https://github.com/alexandred) for VoodooI2C kext and hints for making it work with the trackpad.

[**ioreknanou**](https://www.tonymacx86.com/threads/guide-acer-swift-3-macos-sierra-10-12-2.210393/members/ioreknanou.80739/)** **for making guide for older model, this one is edit of [this](https://www.tonymacx86.com/threads/guide-acer-swift-3-macos-sierra-10-12-2.210393/)

[**acidanthera**](https://github.com/acidanthera) for awesome kexts and first-class support for hackintosh enthusiasts

**Other Useful Links**

[https://www.tonymacx86.com/threads/faq-read-first-laptop-frequent-questions.164990/](https://www.tonymacx86.com/threads/faq-read-first-laptop-frequent-questions.164990/)

[http://www.insanelymac.com/forum/topic/312759-fix-macos-sierra-dp1-bcm94532z-wifi/](http://www.insanelymac.com/forum/topic/312759-fix-macos-sierra-dp1-bcm94532z-wifi/)

[https://www.tonymacx86.com/threads/guide-patching-dsdt-ssdt-for-laptop-backlight-control.152659/](https://www.tonymacx86.com/threads/guide-patching-dsdt-ssdt-for-laptop-backlight-control.152659/)
