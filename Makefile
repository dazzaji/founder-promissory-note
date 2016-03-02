BASENAME=promissory-note board-consent
TARGETS=$(addprefix build/,$(BASENAME:=.docx) $(BASENAME:=.pdf))
CF=node_modules/.bin/commonform

all: $(TARGETS)

build:
	mkdir build

build/promissory-note.docx: promissory-note.cform blanks.json promissory-note.json $(CF) build
	$(CF) render \
		-f docx \
		-n outline \
		-t "Promissory Note" \
		-b blanks.json \
		-s promissory-note.json \
		$< > $@

build/board-consent.docx: board-consent.cform blanks.json board-consent.json $(CF) build
	$(CF) render \
		-f docx \
		-n rse \
		-t "Action by Unanimous Written Consent of the Board of Directors" \
		-b blanks.json \
		-s board-consent.json \
		$< > $@

build/%.pdf: build/%.docx
	doc2pdf $<

$(CF):
	npm i

.PHONY: clean docker

clean:
	rm -rf build

docker:
	docker build -t promissory-note .
	docker run -v $(shell pwd)/build:/app/build promissory-note
	sudo chown `whoami`:`whoami` build

