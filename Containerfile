FROM ghcr.io/ublue-os/bazzite-nvidia:stable

# Bazzite legt diese Wallpaper-Dateien herrenlos (ohne RPM-Zugehoerigkeit) ab.
# Beim Layern von desktop-backgrounds-compat (harte Dep von xfdesktop) kollidiert
# das -> vorher entfernen, dann installiert xfdesktop sauber.
RUN rm -f /usr/share/backgrounds/default*.jxl \
          /usr/share/backgrounds/default*.png \
          /usr/share/backgrounds/default*.jpg 2>/dev/null || true

# bazzite-nvidia ist Wayland-only und laesst den NVIDIA-Xorg-DDX weg -> Xorg crasht
# (modesetting faellt auf nouveau zurueck). Wir ruesten xorg-x11-nvidia in EXAKT der
# Version des im Base-Image gebackenen Kernelmoduls aus negativo17-lts nach (kein
# Kernel-Rebuild, kein Treiber-Tausch). Dazu XFCE + LightDM (X11-Greeter) + flatpak-builder.
#
# negativo17-lts ist im Base-Image enabled=0 -> temporaer aktivieren, damit fedora+updates
# +nvidia-lts GLEICHZEITIG aktiv sind (--enablerepo wuerde die anderen Repos deaktivieren),
# danach wieder auf enabled=0 zuruecksetzen.
RUN sed -i 's/^enabled=0/enabled=1/' /etc/yum.repos.d/negativo17-fedora-nvidia-lts.repo \
 && rpm-ostree install \
      xorg-x11-nvidia \
      xorg-x11-server-Xorg xorg-x11-xinit \
      xfce4-session xfwm4 xfce4-panel xfdesktop xfce4-settings xfce4-terminal \
      Thunar thunar-volman xfce4-appfinder xfce4-whiskermenu-plugin xfce4-notifyd \
      xfce4-pulseaudio-plugin xfce4-power-manager network-manager-applet \
      xfce4-screenshooter x11vnc arc-theme papirus-icon-theme feh \
      lightdm lightdm-gtk-greeter \
      flatpak-builder \
 && sed -i 's/^enabled=1/enabled=0/' /etc/yum.repos.d/negativo17-fedora-nvidia-lts.repo \
 && rpm-ostree cleanup -m \
 && ostree container commit
