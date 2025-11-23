# gle-manual

GLE Manual - The reference manual for [GLE](https://github.com/vlabella/gle).  Written in LaTeX.  Requires LaTeX and GLE for building.  This manual comes bundled with the GLE distribution. However, it may get updated prior to the next release. This repo makes it available separately for users to modify and/or update outside of the GLE release schedule.

## Build Instructions

To build the manual, GLE and supporting programs such as GhostScript and LaTeX must be installed.

### Windows

```
 cd gle-library
 nmake -f Makefile.vc
```

### Linux / macOS

```
cd gle-library
make -f Makefile.gcc
```

