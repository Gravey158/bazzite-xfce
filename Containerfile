# --- Stage 1: xorg-x11-nvidia-RPM aus negativo17-lts laden (dnf kommt mit der Repo klar,
#     rpm-ostree nicht: sed-enable wird ignoriert, --enablerepo deaktiviert fedora/updates) ---
FROM ghcr.io/ublue-os/bazzite-nvidia:stable AS base
FROM registry.fedoraproject.org/fedora:44 AS dl
COPY --from=base /etc/yum.repos.d/negativo17-fedora-nvidia-lts.repo /etc/yum.repos.d/
RUN sed -i 's/^enabled=0/enabled=1/' /etc/yum.repos.d/negativo17-fedora-nvidia-lts.repo \
 && dnf -y download --destdir=/rpms xorg-x11-nvidia \
 && ls -l /rpms

# --- Stage 2: finales Image ---
FROM ghcr.io/ublue-os/bazzite-nvidia:stable
COPY --from=dl /rpms/xorg-x11-nvidia-*.rpm /tmp/

# Bazzite legt diese Wallpaper-Dateien herrenlos (ohne RPM-Zugehoerigkeit) ab -> Konflikt
# mit desktop-backgrounds-compat (Dep von xfdesktop) beim Layern. Vorher entfernen.
RUN rm -f /usr/share/backgrounds/default*.jxl \
          /usr/share/backgrounds/default*.png \
          /usr/share/backgrounds/default*.jpg 2>/dev/null || true

# NVIDIA-Xorg-DDX (lokales RPM, exakt passend zum gebackenen Kernelmodul) + XFCE +
# LightDM (X11-Greeter) + flatpak-builder. Deps des DDX (nvidia-driver-libs etc.) sind
# im Base-Image bereits vorhanden.
RUN rpm-ostree install \
      /tmp/xorg-x11-nvidia-*.rpm \
      xorg-x11-server-Xorg xorg-x11-xinit \
      xfce4-session xfwm4 xfce4-panel xfdesktop xfce4-settings xfce4-terminal \
      Thunar thunar-volman xfce4-appfinder xfce4-whiskermenu-plugin xfce4-notifyd \
      xfce4-pulseaudio-plugin xfce4-power-manager network-manager-applet \
      xfce4-screenshooter x11vnc arc-theme papirus-icon-theme feh \
      lightdm lightdm-gtk-greeter \
      flatpak-builder \
 && rm -f /tmp/xorg-x11-nvidia-*.rpm \
 && rpm-ostree cleanup -m \
 && ostree container commit
