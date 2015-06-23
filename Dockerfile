FROM grams/jenkins-slave-android

## Asciidoc
RUN apt-get update && apt-get install -y asciidoc source-highlight graphviz && apt-get clean
RUN sudo -u jenkins -i /bin/bash -c "mkdir -p ~/.asciidoc/filters/plantuml ; cd ~/.asciidoc/filters/plantuml ; curl https://guillaume-plantuml-updates.googlecode.com/archive/f6dba6e5eab399c69514f4b5dc65c3615f8aa28a.zip > plantuml.zip ; unzip -j plantuml.zip \"*/source/*\" ; rm -f plantuml.zip"

## Ruby with rbenv
# Before installing Ruby, you’ll want to make sure you have a sane build environment. The following list of packages comes from
# the ruby-build wiki:https://github.com/sstephenson/ruby-build/wiki#wiki-suggested-build-environment
RUN apt-get update && apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev && apt-get clean
RUN sudo -u jenkins -i /bin/bash -c "git clone git://github.com/sstephenson/rbenv.git ~/.rbenv && git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build"
RUN /bin/echo -e '\nif [ -n "$BASH_VERSION" ]; then\n\texport PATH="$PATH:$HOME/.rbenv/bin"\n\teval "$(rbenv init -)"\nfi\n' >> /home/jenkins/.profile
RUN sudo -u jenkins -i /bin/bash -c "rbenv install 1.9.3-p484 && rbenv global 1.9.3-p484"

## Ruby gem asciidoctor
RUN sudo -u jenkins -i /bin/bash -c "gem install asciidoctor"

## Dart SDK : simplest way
RUN curl "http://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip" > dartsdk.zip && unzip -q dartsdk.zip && rm -f dartsdk.zip && chmod -R a+r dart-sdk && find dart-sdk -type d -exec chmod 755 {} \; && chmod -R a+x dart-sdk/bin && cp -R dart-sdk /usr/lib/dart-sdk && rm -rf dart-sdk

## Dart SDK : future clean way apt-get style
# https://www.dartlang.org/tools/debian.html#download-debian-package
# Get the Google Linux package signing key.
###RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
# Set up the location of the stable repository.
###RUN curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list
###RUN apt-get update && apt-get install dart && apt-get clean
# Workaround https://github.com/dart-lang/bleeding_edge/blob/master/dart/pkg/code_transformers/lib/src/dart_sdk.dart#L22
###RUN ln -s /usr/lib/dart /usr/lib/dart-sdk
###RUN /bin/echo -e "# add Dart SDK binaries to the path\nPATH=/usr/lib/dart-sdk/bin:$PATH" > /etc/profile.d/dart-path.sh

