
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NATIVE PICO-8 FOR MINUI ON ANBERNIC H700 DEVICES (AND PK RGB30)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                           ~by Ry~

==============
 INSTALLATION
============== 

1) Install MinUI itself the standard way, per the instructions in its readme. Make sure to include the folders from the "Extras" archive.

2) Copy the Emus, Roms, and Tools folders from this release and paste them onto the root of your second SD card (the one where "MinUI.zip" was put on), merging them with the folders you already have. Allow them to overwrite files if prompted.

3) Add your own copies of pico8_dyn and pico8.dat from the most recent Raspberry Pi version of Pico-8 to the Tools/rg35xxplus/Splore.pak/pico8/ folder or the Tools/rg40xxcube/Splore.pak/pico8/ folder, depending on your preference. If you plan to use your SD card across multiple devices, you do not need to add the files to both locations. For the RGB30, you will need pico8_64 instead of or in addition to pico8_dyn.

4) In the Tools/rg40xxcube/Wi-Fi.pak/, and Tools/rgb30/Wi-Fi.pak/ folders, there is a wifi.txt. On the first line, add the SSID (name of your wifi network). On the second line, add the PSK (password of that network). Do this for each of the devices you wish to connect to your network - unlike the Splore paks, these are platform specific, so you must make sure to add your network in this way to each of the three platforms you wish to connect to the internet.

ATTENTION: for RG 35XX Plus devices (including the RG CUBEXX) the configuration file is Tools/rg40xxcube/Wi-Fi.pak/wifi.conf and is structured differently. Just open it in a text editor and overwrite the entries for "Your Wi-fi" and "Your password". Make sure to preserve the quotation marks.

5) Add any Pico-8 carts you wish to play offline to the Roms/Pico-8 (P8-NATIVE) folder.


=======
 USAGE
=======

If you wish to use Splore to browse and play free Pico-8 games directly over the internet, make sure to connect beforehand by either logging into your network in the stock OS before installing MinUI, or by running the Wi-Fi tool inside MinUI after following the instructions in 4) above.

Games you have added to Roms/Pico-8 (P8-NATIVE) will open in native Pico-8 when launched from MinUI. Splore itself can be launched from the Tools menu in MinUI.

To exit Pico-8 at any time, simply tap the power button to close it and return to MinUI.


===========
 CHANGELOG
===========

v1.0.0 - first release

v1.0.1 - fixed wget.log bug causing interdependency between platforms' paks (thanks Shaun for reporting the bug!)

v1.1.0 - added power button as hotkey to exit Pico-8 at any time (All H700 devices)

Forked by Krystman
v1.1.1 - replaced the Wifi script to work on the RG CUBEXX

=========
 CREDITS
=========

Ryan "Ry" Sartor - coding these paks.

Shaun Inman - creating the excellent MinUI on which this mod is built.

Sundowner Sport and tenlevels - encouragement and support.
