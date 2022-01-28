#imagem do ubuntu 
FROM ubuntu:18:04 

# definindo timezone
ENV TZ=America/Sao_Paulo
#setando time zone
RUN ln -snf /usr/share/zoneinfo/${TZ}/etc/localtime && echo ${TZ} > /etc/timezone

# setando requisitos para iniciar ambiente e baixando pacotes
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget

# Setando novo usuario
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# preparandano diretorio android e variaveis do sistema
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

#setando android sdk
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
# movendo para a pasta skk tools
RUN mv tools Android/sdk/tools
# aceitando as licencas do android necessarias
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
# definindo build tools do android
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
# setando path
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"

# baixando o flutter na imagem
RUN wget -O flutter.tar.gz https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_2.0.3-stable.tar.xz
RUN tar -xf flutter.tar.gz && rm flutter.tar.gz
# adicionando ao path
ENV PATH "$PATH:/home/developer/flutter/bin"

RUN flutter doctor

