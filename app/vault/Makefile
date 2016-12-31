include .deosrc

all: $(UI_GENERATED)

ui_%.py: templates/%.ui
	pyuic4 -o $@ $<

clean:
	rm -rf $(UI_GENERATED)
