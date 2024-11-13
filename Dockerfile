ARG BASE_TAG="1.15.0"
ARG BASE_IMAGE="core-ubuntu-bionic"
FROM kasmweb/$BASE_IMAGE:$BASE_TAG
LABEL maintainer="prmiguel <miangel-pr@outlook.com>"
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# Install Apache JMeter Inspector
ARG VERSION
ENV VERSION=$VERSION
COPY ./install_apache_jmeter.sh $INST_SCRIPTS/jmeter/install_apache_jmeter.sh
RUN bash $INST_SCRIPTS/jmeter/install_apache_jmeter.sh && rm -rf $INST_SCRIPTS/jmeter/

COPY ./custom_startup.sh $STARTUPDIR/custom_startup.sh
RUN chmod +x $STARTUPDIR/custom_startup.sh
RUN chmod 755 $STARTUPDIR/custom_startup.sh

# Update the desktop environment to be optimized for a single application
RUN cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
RUN cp /usr/share/backgrounds/bg_kasm.png /usr/share/backgrounds/bg_default.png
RUN apt-get remove -y xfce4-panel

# Disable Basic Authentication
RUN sed -i 's/vncserver $DISPLAY /vncserver $DISPLAY -disableBasicAuth /' /dockerstartup/vnc_startup.sh

######### End Customizations ###########

RUN chown 1000:0 $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000