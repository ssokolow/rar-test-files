# Makefile to regenerate test RAR files if you have a valid RAR/WinRAR license
#
# Setup:
# 1. Unpack https://www.rarlab.com/rar/rarlinux-x64-6.0.2.tar.gz to ~/bin
#    (So `~/bin/rar/rar` and `~/bin/rar/default.sfx` exist)
# 2. Copy your RAR/WinRAR registration key to ~/.rarreg.key
# 3. Unpack http://www.rarlab.com/rar/rarx393.exe to ./dosbox/rar
#    (If you ran it inside DOSBox, rename the `RAR` folder to `rar`)
# 4. Copy your RAR/WinRAR registration key to ./dosbox/RAR/rarreg.key
# 5. Install https://www.rarlab.com/rar/wrar602.exe into the default Wine
#    prefix at C:\Program Files (x86)\WinRAR\Rar.exe
# 6. Install http://www.rarlab.com/rar/wrar393.exe into the default Wine prefix
#    at C:\Program Files (x86)\WinRAR393\Rar.exe
# 6. Copy rarreg.key into both WinRAR installation directories.
#
# WARNING: Parallel make is not currently supported because the DOSBox
#          invocations all share the same virtual drive and temporary 8.3
#          filenames.

RAR := $(HOME)/bin/rar/rar
LIN_SFX_PATH := $(HOME)/bin/rar/default.sfx

DOSBOX := dosbox
DOS_RAR := C:\RAR\RAR32.EXE
DOS_ROOT := ./dosbox
DOS_RAR_DIR := $(DOS_ROOT)/rar
WINE_ROOT := $(HOME)/.wine/drive_c
WINE_RAR3_DIR := $(WINE_ROOT)/Program Files (x86)/WinRAR393
WINE_RAR3 := $(WINE_RAR3_DIR)/Rar.exe
WINE_RAR5_DIR := $(WINE_ROOT)/Program Files (x86)/WinRAR
WINE_RAR5 := $(WINE_RAR5_DIR)/Rar.exe

LIN_RARKEY := $(HOME)/.rarreg.key
DOS_RARKEY := $(DOS_RAR_DIR)/rarreg.key
WINE_RAR3KEY := $(WINE_RAR3_DIR)/rarreg.key
WINE_RAR5KEY := $(WINE_RAR5_DIR)/rarreg.key
RAR_OPTS := -m5 -ep1 -t -ai -cl -tl

BUILD_DIR := build
SRC_DIR := sources
PREBUILT_DIR := prebuilt

# Artifacts which are built using RAR 3.93 for DOS inside DOSBox
dos_artifacts = \
  $(BUILD_DIR)/testfile.rar3.av.cbr \
  $(BUILD_DIR)/testfile.rar3.av.rar \
  $(BUILD_DIR)/testfile.rar3.cbr \
  $(BUILD_DIR)/testfile.rar3.dos_sfx.exe \
  $(BUILD_DIR)/testfile.rar3.locked.cbr \
  $(BUILD_DIR)/testfile.rar3.locked.rar \
  $(BUILD_DIR)/testfile.rar3.rar \
  $(BUILD_DIR)/testfile.rar3.rr.cbr \
  $(BUILD_DIR)/testfile.rar3.rr.rar \
  $(BUILD_DIR)/testfile.rar3.solid.cbr \
  $(BUILD_DIR)/testfile.rar3.solid.rar \

# Artifacts which can be rebuilt natively using the Linux version of RAR
local_artifacts = \
  $(BUILD_DIR)/testfile.rar5.cbr \
  $(BUILD_DIR)/testfile.rar5.rar \
  $(BUILD_DIR)/testfile.rar5.locked.cbr \
  $(BUILD_DIR)/testfile.rar5.locked.rar \
  $(BUILD_DIR)/testfile.rar5.rr.cbr \
  $(BUILD_DIR)/testfile.rar5.rr.rar \
  $(BUILD_DIR)/testfile.rar5.solid.cbr \
  $(BUILD_DIR)/testfile.rar5.solid.rar \
  $(BUILD_DIR)/testfile.rar5.linux_sfx.bin

# Artifacts which are built using WinRAR 3.93 and WinRAR 6.01 beta 1 in Wine
wine_artifacts = \
  $(BUILD_DIR)/testfile.rar3.wincon.sfx.exe \
  $(BUILD_DIR)/testfile.rar3.wingui.sfx.exe \
  $(BUILD_DIR)/testfile.rar5.wincon.sfx.exe \
  $(BUILD_DIR)/testfile.rar5.wingui.sfx.exe


.PHONY: all clean

all: all-pre $(prebuilt_artifacts) $(local_artifacts) $(wine_artifacts) $(dos_artifacts)

all-pre: $(BUILD_DIR)
	@# Improve reproducibility of builds (paired with -tl in RAR_OPTS)
	touch -t 200101010000 $(SRC_DIR)/*

clean:
	rm -rf $(BUILD_DIR)/* $(DOS_RAR_DIR)/testfile.*

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# --== Helpers ==--

# Variables set by individual make rules
extra_args =
dos_outname = OUTFILE.RAR

define make-rar =
[ -f "$(LIN_RARKEY)" ]
rm -f $@
$(RAR) a -ma5 $(RAR_OPTS) $(extra_args) $@ $^
endef

define make-dosbox-rar =
[ -f "$(DOS_RARKEY)" ]
rm -f $@
cp -p $^ $(DOS_RAR_DIR)
dosbox -conf $(DOS_ROOT)/dosbox-0.74.conf -c "$(DOS_RAR) a $(RAR_OPTS) $(extra_args) $(dos_outname) $(notdir $^)" -c "exit"
mv $(DOS_RAR_DIR)/$(dos_outname) $@
rm $(addprefix $(DOS_RAR_DIR)/,$(notdir $^))
endef

define make-wine-rar3 =
[ -f "$(WINE_RAR3KEY)" ]
rm -f $@
wine "$(WINE_RAR3)" a -sfx$(sfx_stub) $(RAR_OPTS) $(extra_args) $@ $^
endef

define make-wine-rar5 =
[ -f "$(WINE_RAR5KEY)" ]
rm -f $@
wine "$(WINE_RAR5)" a -ma5 -sfx$(sfx_stub) $(RAR_OPTS) $(extra_args) $@ $^
endef

# --== DOSBox Artifacts ==--

$(BUILD_DIR)/testfile.rar3.cbr: $(SRC_DIR)/testfile.jpg $(SRC_DIR)/testfile.png
	$(make-dosbox-rar)

$(BUILD_DIR)/testfile.rar3.rar: $(SRC_DIR)/testfile.txt
	$(make-dosbox-rar)

$(BUILD_DIR)/testfile.rar3.av.cbr: extra_args=-av
$(BUILD_DIR)/testfile.rar3.av.cbr: $(SRC_DIR)/testfile.jpg $(SRC_DIR)/testfile.png
	$(make-dosbox-rar)

$(BUILD_DIR)/testfile.rar3.av.rar: extra_args=-av
$(BUILD_DIR)/testfile.rar3.av.rar: $(SRC_DIR)/testfile.txt
	$(make-dosbox-rar)

$(BUILD_DIR)/testfile.rar3.locked.cbr: extra_args=-k
$(BUILD_DIR)/testfile.rar3.locked.cbr: $(SRC_DIR)/testfile.jpg $(SRC_DIR)/testfile.png
	$(make-dosbox-rar)

$(BUILD_DIR)/testfile.rar3.locked.rar: extra_args=-k
$(BUILD_DIR)/testfile.rar3.locked.rar: $(SRC_DIR)/testfile.txt
	$(make-dosbox-rar)

$(BUILD_DIR)/testfile.rar3.rr.cbr: extra_args=-rr
$(BUILD_DIR)/testfile.rar3.rr.cbr: $(SRC_DIR)/testfile.jpg $(SRC_DIR)/testfile.png
	$(make-dosbox-rar)

$(BUILD_DIR)/testfile.rar3.rr.rar: extra_args=-rr
$(BUILD_DIR)/testfile.rar3.rr.rar: $(SRC_DIR)/testfile.txt
	$(make-dosbox-rar)

$(BUILD_DIR)/testfile.rar3.solid.cbr: extra_args=-s
$(BUILD_DIR)/testfile.rar3.solid.cbr: $(SRC_DIR)/testfile.jpg $(SRC_DIR)/testfile.png
	$(make-dosbox-rar)

$(BUILD_DIR)/testfile.rar3.solid.rar: extra_args=-s
$(BUILD_DIR)/testfile.rar3.solid.rar: $(SRC_DIR)/testfile.txt
	$(make-dosbox-rar)

$(BUILD_DIR)/testfile.rar3.dos_sfx.exe: extra_args=-sfx
$(BUILD_DIR)/testfile.rar3.dos_sfx.exe: dos_outname=OUTFILE.EXE
$(BUILD_DIR)/testfile.rar3.dos_sfx.exe: $(SRC_DIR)/testfile.txt $(SRC_DIR)/acknow.txt
	$(make-dosbox-rar)

# --== Local Artifacts ==--

$(BUILD_DIR)/testfile.rar5.cbr: $(SRC_DIR)/testfile.jpg $(SRC_DIR)/testfile.png
	$(make-rar)

$(BUILD_DIR)/testfile.rar5.rar: $(SRC_DIR)/testfile.txt
	$(make-rar)

$(BUILD_DIR)/testfile.rar5.locked.cbr: extra_args=-k
$(BUILD_DIR)/testfile.rar5.locked.cbr: $(SRC_DIR)/testfile.jpg $(SRC_DIR)/testfile.png
	$(make-rar)

$(BUILD_DIR)/testfile.rar5.locked.rar: extra_args=-k
$(BUILD_DIR)/testfile.rar5.locked.rar: $(SRC_DIR)/testfile.txt
	$(make-rar)

$(BUILD_DIR)/testfile.rar5.rr.cbr: extra_args=-rr
$(BUILD_DIR)/testfile.rar5.rr.cbr: $(SRC_DIR)/testfile.jpg $(SRC_DIR)/testfile.png
	$(make-rar)

$(BUILD_DIR)/testfile.rar5.rr.rar: extra_args=-rr
$(BUILD_DIR)/testfile.rar5.rr.rar: $(SRC_DIR)/testfile.txt
	$(make-rar)

$(BUILD_DIR)/testfile.rar5.solid.cbr: extra_args=-s
$(BUILD_DIR)/testfile.rar5.solid.cbr: $(SRC_DIR)/testfile.jpg $(SRC_DIR)/testfile.png
	$(make-rar)

$(BUILD_DIR)/testfile.rar5.solid.rar: extra_args=-s
$(BUILD_DIR)/testfile.rar5.solid.rar: $(SRC_DIR)/testfile.txt
	$(make-rar)

$(BUILD_DIR)/testfile.rar5.linux_sfx.bin: extra_args=-sfx$(LIN_SFX_PATH)
$(BUILD_DIR)/testfile.rar5.linux_sfx.bin: $(SRC_DIR)/testfile.txt $(SRC_DIR)/acknow.txt
	$(make-rar)
	mv $@.sfx $@

# --== Wine Artifacts ==--

$(BUILD_DIR)/testfile.rar3.wincon.sfx.exe: sfx_stub=WinCon.SFX
$(BUILD_DIR)/testfile.rar3.wincon.sfx.exe: $(SRC_DIR)/testfile.txt $(SRC_DIR)/acknow.txt
	$(make-wine-rar3)

$(BUILD_DIR)/testfile.rar3.wingui.sfx.exe: sfx_stub=Default.SFX
$(BUILD_DIR)/testfile.rar3.wingui.sfx.exe: $(SRC_DIR)/testfile.txt $(SRC_DIR)/acknow.txt
	$(make-wine-rar3)

$(BUILD_DIR)/testfile.rar5.wincon.sfx.exe: sfx_stub=WinCon.SFX
$(BUILD_DIR)/testfile.rar5.wincon.sfx.exe: $(SRC_DIR)/testfile.txt $(SRC_DIR)/acknow.txt
	$(make-wine-rar5)

$(BUILD_DIR)/testfile.rar5.wingui.sfx.exe: sfx_stub=Default.SFX
$(BUILD_DIR)/testfile.rar5.wingui.sfx.exe: $(SRC_DIR)/testfile.txt $(SRC_DIR)/acknow.txt
	$(make-wine-rar5)
