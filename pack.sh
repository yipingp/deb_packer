#! /bin/bash
################      Parameters       ####################
EXE="useQt" # Executable file from your source code
ICON_NAME="Recognition" # Name of icon in applications
PACK_DIR="/home/username/Desktop/$ICON_NAME" # The output directory of packing
INSTALL_DIR="/opt/$ICON_NAME" # The installation directory of deb package

VERSION_MAJOR="1"
VERSION_MINOR="0"
VERSION_PATCH="0"
CONTACT="you@yourdomain.com "

################      Files to be packed are copied to $PACK_DIR       ####################
mkdir $PACK_DIR

# Copy shared libraries
LIB_OUTPUT_DIR="$PACK_DIR/lib"
FILES=`ldd bin/$EXE | awk '{ if(match($3,"^/"))printf("%s "),$3 }'`
mkdir $LIB_OUTPUT_DIR
cp $FILES $LIB_OUTPUT_DIR

# Copy EXE (Make sure your binaries in ./bin)
EXE_OUTPUT_DIR="$PACK_DIR/bin"
FILES="./bin/$EXE"
mkdir $EXE_OUTPUT_DIR
cp $FILES $EXE_OUTPUT_DIR

# Copy config folder (Make sure your config folder is ./config)
cp -r ./config $PACK_DIR

# Copy icon.jpg
cp ./icon.jpg $PACK_DIR

################      Generate $EXE.sh       ####################
gedit $PACK_DIR/$EXE.sh
echo "#!/bin/sh" >> $PACK_DIR/$EXE.sh
echo "# Set installation directory" >> $PACK_DIR/$EXE.sh
echo "DIR="$INSTALL_DIR"" >> $PACK_DIR/$EXE.sh
echo "# Add shared library path" >> $PACK_DIR/$EXE.sh
echo "LD_LIBRARY_PATH=\$DIR/lib" >> $PACK_DIR/$EXE.sh
echo "export LD_LIBRARY_PATH" >> $PACK_DIR/$EXE.sh
echo "# \"\$@\" Parameters" >> $PACK_DIR/$EXE.sh
echo "\$DIR/bin/$EXE \"\$@\" " >> $PACK_DIR/$EXE.sh

################      Generate $EXE.desktop       ####################
gedit $PACK_DIR/$ICON_NAME.desktop
echo "[Desktop Entry]" >> $PACK_DIR/$ICON_NAME.desktop
echo "Type=Application" >> $PACK_DIR/$ICON_NAME.desktop
echo "Name=$ICON_NAME" >> $PACK_DIR/$ICON_NAME.desktop
echo "Icon=$INSTALL_DIR/icon.jpg" >> $PACK_DIR/$ICON_NAME.desktop
echo "Exec=$INSTALL_DIR/$EXE.sh" >> $PACK_DIR/$ICON_NAME.desktop
echo "Terminal=false" >> $PACK_DIR/$ICON_NAME.desktop

################      Generate CMakeLists.txt for packing deb package       ####################
gedit $PACK_DIR/CMakeLists.txt
echo "set(CPACK_GENERATOR "DEB")" >> $PACK_DIR/CMakeLists.txt
echo "" >> $PACK_DIR/CMakeLists.txt

echo "# Set deb package name: packagename-version-linux.deb" >> $PACK_DIR/CMakeLists.txt
echo "set(CPACK_PACKAGE_NAME "$ICON_NAME")" >> $PACK_DIR/CMakeLists.txt
echo "# Set version" >> $PACK_DIR/CMakeLists.txt
echo "set(CPACK_PACKAGE_VERSION_MAJOR "$VERSION_MAJOR")" >> $PACK_DIR/CMakeLists.txt
echo "set(CPACK_PACKAGE_VERSION_MINOR "$VERSION_MINOR")" >> $PACK_DIR/CMakeLists.txt
echo "set(CPACK_PACKAGE_VERSION_PATCH "$VERSION_PATCH")" >> $PACK_DIR/CMakeLists.txt
echo "# Set contact information" >> $PACK_DIR/CMakeLists.txt
echo "set(CPACK_PACKAGE_CONTACT "$CONTACT")" >> $PACK_DIR/CMakeLists.txt
echo "# Description" >> $PACK_DIR/CMakeLists.txt
echo "SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Workpiece Recognition")" >> $PACK_DIR/CMakeLists.txt

echo "" >> $PACK_DIR/CMakeLists.txt

echo "file(GLOB bins "bin/*")" >> $PACK_DIR/CMakeLists.txt
echo "file(GLOB config "config/config.yaml")" >> $PACK_DIR/CMakeLists.txt
echo "file(GLOB obj "config/obj/*")" >> $PACK_DIR/CMakeLists.txt
echo "file(GLOB libs "lib/*")" >> $PACK_DIR/CMakeLists.txt
echo "" >> $PACK_DIR/CMakeLists.txt

echo "install (FILES \${bins} DESTINATION $INSTALL_DIR/bin PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_WRITE GROUP_EXECUTE WORLD_READ WORLD_WRITE WORLD_EXECUTE)" >> $PACK_DIR/CMakeLists.txt
echo "install (FILES \${config} DESTINATION $INSTALL_DIR/config PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_WRITE GROUP_EXECUTE WORLD_READ WORLD_WRITE WORLD_EXECUTE)" >> $PACK_DIR/CMakeLists.txt
echo "install (FILES \${obj} DESTINATION $INSTALL_DIR/config/obj PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_WRITE GROUP_EXECUTE WORLD_READ WORLD_WRITE WORLD_EXECUTE)" >> $PACK_DIR/CMakeLists.txt
echo "install (FILES \${libs} DESTINATION $INSTALL_DIR/lib PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_WRITE GROUP_EXECUTE WORLD_READ WORLD_WRITE WORLD_EXECUTE)" >> $PACK_DIR/CMakeLists.txt
echo "install (FILES "$EXE.sh" DESTINATION $INSTALL_DIR PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_WRITE GROUP_EXECUTE WORLD_READ WORLD_WRITE WORLD_EXECUTE)" >> $PACK_DIR/CMakeLists.txt
echo "install (FILES "$ICON_NAME.desktop" DESTINATION /usr/share/applications PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_WRITE GROUP_EXECUTE WORLD_READ WORLD_WRITE WORLD_EXECUTE)" >> $PACK_DIR/CMakeLists.txt
echo "install (FILES "icon.jpg" DESTINATION $INSTALL_DIR PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_WRITE GROUP_EXECUTE WORLD_READ WORLD_WRITE WORLD_EXECUTE)" >> $PACK_DIR/CMakeLists.txt
echo "include(CPack)" >> $PACK_DIR/CMakeLists.txt


