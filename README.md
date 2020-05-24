# deb_packer
A simple debian packer for C++ applications.

Use it:
1. Copy pack.sh to your C++ workspace folder
2. Set parameters in pack.sh, for instance, your executable files and libraries path.
3. Run
```
./pack.sh
```
4. Change directory to output folder of pack.sh, run
```
mkdir build
cd build
cmake ..
make package
```
