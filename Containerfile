FROM ghcr.io/ublue-os/bazzite-nvidia:stable

# Bazzite legt diese Wallpaper-Dateien herrenlos (ohne RPM-Zugehoerigkeit) ab.
# Beim Layern von desktop-backgrounds-compat (harte Dep von xfdesktop) kollidiert
# das -> vorher entfernen, dann installiert xfdesktop sauber.
RUN rm -f /usr/share/backgrounds/default*.jxl \
          /usr/share/backgrounds/default*.png \
          /usr/share/backgrounds/default*.jpg 2>/dev/null || true

RUN rpm-ostree install \
      xfce4-session xfwm4 xfce4-panel xfdesktop xfce4-settings xfce4-terminal \
      Thunar thunar-volman xfce4-appfinder xfce4-whiskermenu-plugin xfce4-notifyd \
      xfce4-pulseaudio-plugin xfce4-power-manager network-manager-applet \
      xfce4-screenshooter xorg-x11-server-Xorg x11vnc arc-theme papirus-icon-theme feh \
      flatpak-builder \
 && rpm-ostree cleanup -m \
 && ostree container commit
