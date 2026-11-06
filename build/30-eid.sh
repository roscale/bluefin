#!/usr/bin/env bash

set -euo pipefail

###############################################################################
# Belgian eID
###############################################################################
# Kept out of 20-packages-and-services.sh on purpose: the template's tests
# assert the exact set of dnf5 and systemctl calls that script makes, so
# personal additions live in their own phase.
###############################################################################

echo "::group:: Install Belgian eID"

# The eid-archive release package installs the repo definition and signing
# key, so it must be installed before the packages that come from that repo.
dnf5 install -y https://eid.belgium.be/sites/default/files/software/eid-archive-fedora-2026-1.noarch.rpm
dnf5 install -y firefox eid-viewer eid-mw

echo "::endgroup::"

echo "::group:: Enable smart card daemon"

# Needed for the eID reader. Socket-activated, so it only starts when
# something talks to the card reader.
systemctl enable pcscd.socket

echo "::endgroup::"
