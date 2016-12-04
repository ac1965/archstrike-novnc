FROM ac1965/archstrike:latest
MAINTAINER ac1965 <https://github.com/ac1965>

# 
COPY ["packages/", "/tmp/packages/"]
USER root
WORKDIR /root
RUN pacman -Syu --noconfirm --needed $(egrep -v '^#|^$' /tmp/packages/base.txt) && pacman -Scc
RUN git clone https://github.com/kanaka/noVNC.git && \
	cd noVNC/utils && git clone https://github.com/kanaka/websockify websockify
ADD startup.sh /startup.sh
RUN chmod 0755 /startup.sh

CMD /startup.sh
