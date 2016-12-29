export MAKEFLAGS:=--no-print-directory
export VAULT_MACRO_BUILD:=build/%s.ui
export VAULT_MACRO_CONFIG:=config/%s.yml
export VAULT_MACRO_TEMPLATES:=templates/%s.xml
export VAULT_PATH_PARTIALS:=./templates/partials/
export VAULT_PATH_TEMPLATES:=./templates/
export VAULT_TEMPLATES:=add_password_dialog
export VAULT_TODO:=\
src/ui_addgroup_dialog.py\
src/ui_enter_pin_dialog.py\
src/ui_initialize_dialog.py\
src/ui_mainwindow.py\
src/ui_trezor_chooser_dialog.py\
src/ui_trezor_passphrase_dialog.py

all:
	@source .venv/bin/activate && python main.py render
	$(MAKE) build
	@source .venv/bin/activate && python main.py replace
	-rm dialogs.py && mv dialogs.swap.py dialogs.py
	-rm TrezorPass.py && mv TrezorPass.swap.py TrezorPass.py
	-$(MAKE) run

src/ui_%.py: src/%.ui
	mv $< $(patsubst src/%.ui,build/%.ui,$<)

run:
	-source .venv/bin/activate && python TrezorPass.py
	-rm *.pyc build/*.pyc

build: clone
	-cp -rf build/*.ui src
	source .venv/bin/activate && cd src && make
	$(MAKE) $(VAULT_TODO)
	@-mv src/Makefile docs/Makefile
	cp src/*.ui build/
	@-rm src/*.ui
	@-mv src/ui_*.py build/
	@-mv src/*.py .
	@-rm -rf src

clone: clean
	@-rm build/ui_*.py
	@-rm -rf src
	@-git clone git@github.com:hiviah/TrezorPass.git src
	@-cp -rf build/*.ui src
	@-rm -rf src/.git
	@-rm src/.gitignore
	@-mv src/README.md docs/README.md
	@-mv src/TrezorPass.pro docs/TrezorPass.pro
	@-mv src/COPYING docs/COPYING

clean:
	@-rm *.pyc
	@-rm -rf src/*.pyc
	@-rm src/COPYING

install: brew venv sip pyqt

brew:
	-brew install protobuf
	-brew install pyqt5
	-brew install sip

venv:
	#-rm -rf .venv
	#-virtualenv --always-copy --no-site-packages .venv
	source .venv/bin/activate && pip install web.py
	source .venv/bin/activate && pip install PyCrypto
	source .venv/bin/activate && pip install trezor
	source .venv/bin/activate && pip install simplejson
	source .venv/bin/activate && pip install ruamel.yaml
	source .venv/bin/activate && pip install jsonschema
	source .venv/bin/activate && pip install configobj

sip:
	-rm -rf ext/sip
	cp .cache/sip-4.18.1.tar.gz sip.tar.gz
	gunzip sip.tar.gz
	tar -xvf sip.tar
	rm -rf sip.tar
	mv sip-4.18.1 ext/sip
	source .venv/bin/activate && \
	cd ext/sip && \
	python configure.py --incdir=../../.venv/include/python2.7 && \
	make && \
	make install

pyqt:
	-rm -rf ext/pyqt
	cp .cache/PyQt-mac-gpl-4.11.4.tar.gz pyqt.tar.gz
	gunzip pyqt.tar.gz
	tar -xvf pyqt.tar
	rm -rf pyqt.tar
	mv PyQt-mac-gpl-4.11.4 ext/pyqt
	source .venv/bin/activate && \
	cd ext/pyqt && \
	python configure-ng.py --qmake=/usr/local/Cellar/qt5/5.7.0/bin/qmake && \
	make && \
	make install
