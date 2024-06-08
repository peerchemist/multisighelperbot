FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /src
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/multisighelper.dart -o bin/multisighelper

FROM debian:bookworm-slim
RUN useradd -m -U -s /usr/sbin/nologin helperbot
COPY --from=build /src/build/libsecp256k1.so /home/helperbot/bin/
COPY --from=build /src/bin/musighelperbot.app /home/helperbot/bin/
RUN chown -R helperbot:helperbot /home/helperbot
USER helperbot
CMD ["/home/helperbot/bin/musighelperbot.app"]
