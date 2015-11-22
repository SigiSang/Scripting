# DarkMode #
The purpose of this script is to invert the screen colours, so I can easily switch between White-on-black and Black-on-white. In my case, my GNOME Terminal and editor (Atom) have a Dark theme set, so when inverting screen colors, these get a white background. I wrote this script to have both my editor and terminal switch to a light theme/profile when inverting the screen, and the other way around.

### GNOME Terminal profile change ###
I could barely find anything well-documented or self-explanatory to programmatically switch GNOME Terminal profiles, which is the main reason why I'm putting this script up here.
The code contained in the "change_profile" function is the closest I could get to programmatically switching between GNOME Terminal profiles. This can be easily done with Right-click > Profiles and selecting the desired profile, but to my surprise there is no straight-forward Linux command for this.
What "change_profile" basically does is load a configuration file for the given profile (only argument) and setting these values for the Default profile. So it doesn't actually switch profiles, but makes it seam like it did.

On first use, all profiles are exported to configuration files, which most importantly makes it possible to switch back to the original Default profile. Deleting these files while having "changed profile" would require you to manually reconfigure your Default profile.
