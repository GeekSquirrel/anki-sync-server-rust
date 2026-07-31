# anki-sync-server-rust

This repository builds and publishes a Docker image for the Rust-based Anki sync server.

The automation polls the latest release from `ankitects/anki`. When a new Anki version appears, GitHub Actions builds an image from this repository's Dockerfile, tags it with the matching Anki version, and updates `latest` to point at that version.

Published images are pushed to GHCR as `ghcr.io/GeekSquirrel/anki-sync-server-rust:<version>` and `ghcr.io/GeekSquirrel/anki-sync-server-rust:latest`.

At runtime, configure at least one sync user, for example:

```bash
docker run -d \
	-e SYNC_USER1=user:pass \
	-p 8080:8080 \
	--mount type=volume,src=anki-sync-server-data,dst=/anki_data \
	ghcr.io/GeekSquirrel/anki-sync-server-rust:latest
```

For Docker Compose, copy `.env.example` to `.env`, fill in the values, and run:

```bash
docker compose up -d
```