#!/bin/bash
DATE=$(date +%Y.%m.%d.%H.%M)
sed -i "s/Version:.*/Version: $DATE/g" ./ROOT/DEBIAN/control
dpkg-deb --root-owner-group --build ROOT iesavellaneda-tools.deb
