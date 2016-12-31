include .deosrc

all:
	@ $(MAKE) install
	@ $(MAKE) run

help:
	@ echo 'export PATH="$(BIN)/darwin:$(PATH)"'

run: build
	@ $(DEOS)

build:
	@-$(XMCC)
	@ $(CC) $(CFLAGS) $(CINCLUDE) $(CTARGET) -o $(CEXE) $(CLINK)
	@ $(XMOD) $(CEXE)
	@ clear

install: clean
	@-$(MKDIR) $(BIN) $(BIN)/darwin $(EXT) $(INCLUDE) $(LIB) $(MACRO)
	@ $(MAKE) $(VIRTUAL)
	@#$(MAKE) $(SIP)
	@#$(MAKE) $(PYQT)
	@ clear

uninstall: clean
	@-$(RM) $(PYQT) $(SIP) $(VENV)
	@ clear

clean:
	@-$(RM) $(CEXE)* $(MACRO)/*.def
	@ clear

$(VIRTUAL):
	@-$(MKDIR) venv $(VIRTUAL)
	@ $(NEWENV) $(VENV)
	@ $(SETENV) && \
	  $(PIP) install -r $(REQUIRE)
	@ clear

$(PYQT):
	@ cp $(EXT)/.cache/PyQt-mac-gpl-4.11.4.tar.gz $(EXT)/pyqt.tar.gz
	@ gunzip $(EXT)/pyqt.tar.gz
	@ tar -xvf $(EXT)/pyqt.tar
	@-$(RM) $(EXT)/pyqt.tar
	@ mv PyQt-mac-gpl-4.11.4 $(EXT)/pyqt
	@ $(SETENV) && cd $(EXT)/pyqt && \
	  python configure-ng.py --confirm-license --qmake=$(QMAKE) && \
	  make && make install
	@ clear

$(SIP):
	@ cp $(EXT)/.cache/sip-4.18.1.tar.gz $(EXT)/sip.tar.gz
	@ gunzip $(EXT)/sip.tar.gz
	@ tar -xvf $(EXT)/sip.tar
	@-$(RM) $(EXT)/sip.tar
	@ mv sip-4.18.1 $(EXT)/sip
	@ $(SETENV) && cd $(EXT)/sip && \
	  python configure.py --incdir=$(VENV)/include/python2.7 && \
	  make && make install
	@ clear
