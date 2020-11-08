FROM ubuntu:focal

RUN apt update

RUN DEBIAN_FRONTEND=noninteractive apt install -q -y \
  lyx \
  texlive-pstricks \
  texlive-lang-chinese \
  texlive-lang-cyrillic \
  texlive-fonts-extra \
  git \
  texlive-humanities \
  pdftk \
  hunspell \
  bzip2

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

ADD test /tmp/test

# This will initialize and configure LyX and generate some Metafont files as well.
RUN (cd /tmp/test; lyx --export pdf sofp || cat sofp.log)

# This will fail if PDF file was not created.
RUN rm /tmp/test/sofp.pdf
