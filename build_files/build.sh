#!/bin/bash

set -ouex pipefail

dnf -y copr enable scottames/ghostty
dnf -y install ghostty

# Disable COPRs so they don't end up enabled on the final image:
dnf -y copr disable scottames/ghostty
