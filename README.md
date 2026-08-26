# bazzite-xfce

Personalisiertes [Bazzite](https://bazzite.gg/)-Image (`bazzite-nvidia`) mit einer
vollstaendigen **XFCE-Sitzung auf X11** zusaetzlich zum KDE-Plasma-Standard.

## Warum

- **XFCE laeuft schlanker** als Plasma und dient als leichter Zweit-/Wartungsdesktop.
- **X11 statt Wayland** ermoeglicht Remote-Zugriff **schon am Login-Bildschirm** via `x11vnc`
  (unter Wayland technisch nicht moeglich, da sich kein Prozess an den Greeter-Compositor haengen kann).
- Gaming bleibt auf der KDE-Plasma-Wayland-Sitzung.

## Was drin ist

- XFCE-Kern: `xfce4-session`, `xfwm4`, `xfce4-panel`, `xfdesktop`, `xfce4-settings`,
  `xfce4-terminal`, `Thunar`, `xfce4-appfinder`, `xfce4-whiskermenu-plugin` (Kali-Stil),
  `xfce4-notifyd`, `xfce4-power-manager`, `xfce4-screenshooter`, Pulseaudio-Plugin, NM-Applet
- X11: `xorg-x11-server-Xorg`, `x11vnc`, `feh`
- Optik: `arc-theme` (Arc-Dark), `papirus-icon-theme`

Die von Bazzite herrenlos abgelegten `default*`-Wallpaper in `/usr/share/backgrounds/`
werden im Build entfernt, weil sonst `desktop-backgrounds-compat` (Dep von `xfdesktop`)
beim Paket-Layer mit ihnen kollidiert.

## Update-Pfad

Das Image wird per GitHub Actions **taeglich neu gebaut** (gegen `bazzite-nvidia:stable`)
und nach `ghcr.io/gravey158/bazzite-xfce:latest` gepusht. Ein darauf rebasetes System
zieht Updates wie gewohnt automatisch — nur eben von diesem Image.

## Rebase

```bash
sudo rpm-ostree reset   # etwaige lokale Layer/Overrides entfernen
sudo bootc switch ghcr.io/gravey158/bazzite-xfce:latest
# oder: sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/gravey158/bazzite-xfce:latest
systemctl reboot
```

Zurueck zu Upstream-Bazzite:

```bash
sudo bootc switch ghcr.io/ublue-os/bazzite-nvidia:stable
systemctl reboot
```
