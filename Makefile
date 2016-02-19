BASENAME=promissory-note
TARGETS=$(addprefix build/,$(BASENAME:=.docx) $(BASENAME:=.pdf))
CF=node_modules/.bin/commonform

all: $(TARGETS)

build:
	mkdir build

build/%.docx: promissory-note.cform signatures.json $(CF) build
	$(CF) render -f docx -n outline -t "Promissory Note" -s signatures.json promissory-note.cform > $@

build/%.pdf: build/%.docx
	doc2pdf $<

$(CF):
	npm i

.PHONY: clean docker

clean:
	rm -f $(TARGETS)

docker:
	docker build -t promissory-note .
	docker run -v $(shell pwd)/build:/app/build promissory-note
	sudo chown `whoami`:`whoami` build

