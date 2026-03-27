#!/bin/bash

set -ouex pipefail

dnf -y copr enable scottames/ghostty
dnf -y install ghostty

rpm -i https://eid.belgium.be/sites/default/files/software/eid-archive-fedora-2026-1.noarch.rpm
dnf -y install firefox eid-viewer eid-mw

# Disable COPRs so they don't end up enabled on the final image:
dnf -y copr disable scottames/ghostty
