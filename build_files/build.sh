#!/bin/bash

set -ouex pipefail

rpm -i https://eid.belgium.be/sites/default/files/software/eid-archive-fedora-2026-1.noarch.rpm
dnf -y install firefox eid-viewer eid-mw
