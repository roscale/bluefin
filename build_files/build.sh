#!/bin/bash

set -ouex pipefail

# The eID server sometimes does not answer. Try again before we stop the build.
curl --fail --silent --show-error --location \
    --connect-timeout 20 --retry 10 --retry-delay 10 --retry-all-errors \
    -o /tmp/eid-archive.rpm \
    https://eid.belgium.be/sites/default/files/software/eid-archive-fedora-2026-1.noarch.rpm
# This RPM contains the eID signing key, so rpm cannot check its signature yet.
# dnf uses that key to check the eID packages that we install next.
rpm -i --nosignature /tmp/eid-archive.rpm
dnf -y install firefox eid-viewer eid-mw
