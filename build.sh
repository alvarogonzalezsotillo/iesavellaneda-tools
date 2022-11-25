#!/bin/bash
DATE=$(date +%Y.%m.%d.%H.%M)
VERSION="$DATE-$(hostname)"
echo "Versión creada: $VERSION"
sed -i "s/Version:.*/Version: $VERSION/g" ./ROOT/DEBIAN/control
dpkg-deb --root-owner-group --build ROOT iesavellaneda-tools.deb
