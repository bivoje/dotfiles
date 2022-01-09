# first created 2021-05-30 14:50
#  last updated 2021-06-10 00:34
FROM alpine:latest
RUN apk add vim tmux curl python3
RUN mkdir ~/bin && \
    echo "export PATH=\$PATH:~/bin" >> ~/.profile && \
    curl -o ~/bin/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr && \
    chmod +x ~/bin/tldr
RUN curl -O http://www.catb.org/~esr/ascii/ascii-3.18.tar.gz && \
    tar xzf ascii-3.18.tar.gz && \
    cd tar xzf ascii-3.18 && \
    make && \
    mv ascii ../bin && \
    cd .. && \
    rm -rf ascii-3.18 ascii-3.18.tar.gz
