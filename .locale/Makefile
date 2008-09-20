SHELL = /bin/bash -eu
.DELETE_ON_ERROR:
.SECONDARY:
.SUFFIXES:

TARGET = en_CA.UTF-8@iso8601

${TARGET}: en_CA@iso8601
	localedef -f UTF-8 -i ${<} "${PWD}/${@}"

.PHONY: clean
clean:
	rm -rf "${TARGET}"
