#!/usr/bin/env bash

set -euo pipefail

###############################################################################
# Default packages and services
###############################################################################
# This phase owns RPM and COPR installation. Packages are installed here, never
# in 10-overlay.sh, so a filesystem-overlay change cannot invalidate the
# expensive package layer above it.
#
# The default set keeps the reference image functional on first boot:
#   just  - the ujust entry point; base Fedora ships no just binary
#   gum   - interactive prompts used by the shared and custom ujust recipes
#   fzf   - ujust --choose, without a first-use Homebrew download
#   jq    - the ublue setup hooks and several recipes
#   uupd  - background update policy, from the ublue-os/packages COPR
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

# Enable nullglob for all glob operations to prevent failures on empty matches
shopt -s nullglob

echo "::group:: Install Default Packages"

dnf5 install -y just gum fzf jq

echo "::endgroup::"

echo "::group:: Install uupd"

# uupd owns the update policy. Its binary comes from the ublue-os/packages
# COPR; Common's shared layer (already overlaid) supplies /etc/uupd/config.json,
# the AC-connect udev rule and service, the post-suspend timer, and the
# ConditionACPower drop-in — so a desktop updates on schedule and a laptop
# updates once it is on AC.
copr_install_isolated "ublue-os/packages" uupd

echo "::endgroup::"

echo "::group:: Install Belgian eID"

# The eid-archive release package installs the repo definition and signing
# key, so it must be installed before the packages that come from that repo.
# dnf5 install on a URL replaces the manual `rpm -i`.
dnf5 install -y https://eid.belgium.be/sites/default/files/software/eid-archive-fedora-2026-1.noarch.rpm
dnf5 install -y firefox eid-viewer eid-mw

echo "::endgroup::"

echo "::group:: Enable update services"

# Enable explicitly rather than relying on the shipped preset, matching how
# 10-overlay.sh enables the Brew and Flatpak units.
systemctl enable uupd.timer
systemctl enable uupd-resume.timer

# Smart card daemon, needed for the eID reader. Socket-activated, so it only
# starts when something talks to the card reader.
systemctl enable pcscd.socket

echo "::endgroup::"

# Restore default glob behavior
shopt -u nullglob
