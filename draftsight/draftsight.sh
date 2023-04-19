#!/usr/bin/env sh

unset XDG_CURRENT_DESKTOP
unset DESKTOP_SESSION
unset GNOME_DESKTOP_SESSION_ID
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export vblank_mode=0
export LD_LIBRARY_PATH=/opt/dassault-systemes/DraftSight/Libraries/:$LD_LIBRARY_PATH

cd /opt/dassault-systemes/DraftSight/Linux
firejail --net=none faketime '2020-02-29 08:15:42' /opt/dassault-systemes/DraftSight/Linux/DraftSight $@
