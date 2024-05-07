FROM ubuntu:noble

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

ADD test/* /tmp/

# This will initialize and configure LyX and generate some Metafont files as well.
RUN (cd /tmp/; lyx --export pdflatex sofp)

RUN (cd /tmp/; pdflatex --interaction=batchmode sofp.tex || cat sofp.log)

# This will fail if PDF file was not created.
RUN rm /tmp/sofp.pdf
