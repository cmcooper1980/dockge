<div align="center" width="100%">
    <img src="./frontend/public/icon.svg" width="128" alt="" />
</div>

# Dockge

A fancy, easy-to-use and reactive self-hosted docker compose stack-oriented manager forked from louislam/dockge that has had several Pull Requests merged.

[![GitHub Repo stars](https://img.shields.io/github/stars/cmcooper1980/dockge?logo=github&style=flat)](https://github.com/cmcooper1980/dockge) [![Docker Pulls](https://img.shields.io/docker/pulls/cmcooper1980/dockge?logo=docker)](https://hub.docker.com/r/cmcooper1980/dockge/tags) [![Docker Image Version (latest semver)](https://img.shields.io/docker/v/cmcooper1980/dockge/latest?label=docker%20image%20ver.)](https://hub.docker.com/r/cmcooper1980/dockge/tags) [![GitHub last commit (branch)](https://img.shields.io/github/last-commit/cmcooper1980/dockge/master?logo=github)](https://github.com/cmcooper1980/dockge/commits/master/)

<img width="3840" height="1937" alt="image" src="https://github.com/user-attachments/assets/3bb5aec8-e17a-43cb-8f15-908047282043" />

View Video: https://youtu.be/AWAlOQeNpgU?t=48

# Available Architectures

<table>
  <thead>
    <tr>
      <th>Docker Tag</th>
      <th>Architecture</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>pinned version #</td>
      <td rowspan="2">amd64 / arm64 / armv7</td>
    </tr>
    <tr>
      <td>latest</td>
    </tr>
  </tbody>
</table>



## ⭐ Features

- 🧑‍💼 Manage your `compose.yaml` files
  - Create/Edit/Start/Stop/Restart/Delete
  - Update Docker Images
- ⌨️ Interactive Editor for `compose.yaml`
- 🦦 Interactive Web Terminal
- 🕷️ (1.4.0+) Multiple agents support - You can manage multiple stacks from different Docker hosts in one single interface
- 🏪 Convert `docker run ...` commands into `compose.yaml`
- 📙 File based structure - Dockge won't kidnap your compose files, they are stored on your drive as usual. You can interact with them using normal `docker compose` commands

<img src="https://github.com/louislam/dockge/assets/1336778/cc071864-592e-4909-b73a-343a57494002" width=300 />

- 🚄 Reactive - Everything is just responsive. Progress (Pull/Up/Down) and terminal output are in real-time
- 🐣 Easy-to-use & fancy UI - If you love Uptime Kuma's UI/UX, you will love this one too

![](https://github.com/louislam/dockge/assets/1336778/89fc1023-b069-42c0-a01c-918c495f1a6a)

## ⭐ Pull Requests Merged:
- PR  #[23](https://github.com/louislam/dockge/pull/23) Compose override editor (by [eliasfloreteng](https://github.com/eliasfloreteng))
- PR #[387](https://github.com/louislam/dockge/pull/387) Global.env editor and usage in docker operations (by [syko9000](https://github.com/syko9000))
- PR #[414](https://github.com/louislam/dockge/pull/414) Set/Update Friendly Name (by [lohrbini](https://github.com/lohrbini))
- PR #[575](https://github.com/louislam/dockge/pull/575) Theme Options Enabled in Settings (by [CampaniaGuy](https://github.com/CampaniaGuy))
- PR #[582](https://github.com/louislam/dockge/pull/582) Remove logging of terminal buffer to console (by [black-dragon74](https://github.com/black-dragon74))
- PR #[593](https://github.com/louislam/dockge/pull/593) Group stacks by [](its agent (by [ESPGranEdu](https://github.com/ESPGranEdu))
- PR #[634](https://github.com/louislam/dockge/pull/634) Build Frontend During Docker Build (by [Jamie-](https://github.com/Jamie-))
- PR #[637](https://github.com/louislam/dockge/pull/637) Implement RIGHT and LEFT KEYS terminal navigation (by [lukasondrejka](https://github.com/lukasondrejka))
- PR #[649](https://github.com/louislam/dockge/pull/649) Add Container Control Buttons (by [mizady](https://github.com/mizady))
- PR #[700](https://github.com/louislam/dockge/pull/700) Add Resource Usage Stats (by [justwiebe](https://github.com/justwiebe))
- PR #[714](https://github.com/louislam/dockge/pull/714) Conditional stack files deletion (by [husa](https://github.com/husa))
- PR #[724](https://github.com/louislam/dockge/pull/724) Adds force delete button when the delete option has failed (by [DomiiBunn](https://github.com/DomiiBunn))
- PR #[730](https://github.com/louislam/dockge/pull/730) Add an Update All Button (by [DomiiBunn](https://github.com/DomiiBunn))
- PR #[785](https://github.com/louislam/dockge/pull/785) Add Cloudflare Turnstile captcha (by [Kambaa](https://github.com/Kambaa))
- PR #[786](https://github.com/louislam/dockge/pull/786) Replace editor with Codemirror (by [andersmmg](https://github.com/andersmmg))
- PR #[800](https://github.com/louislam/dockge/pull/800) Improved stack list ui when using agents (by [maca134](https://github.com/maca134))
    - with QOL Commit [ef7225a](https://github.com/louislam/dockge/commit/ef7225a333225d17d3fc92852226989973ec5aee) (by [Dracrius](https://github.com/Dracrius))
- PR #[813](https://github.com/louislam/dockge/pull/813) Fix "Exited" Status when Expected (by [Aymendje](https://github.com/Aymendje))
- PR #[822](https://github.com/louislam/dockge/pull/822) Add clipboard copy/paste support to terminal component (by [Dimariqe](https://github.com/Dimariqe))  
	- be sure to allow the permission in the browser to take effect
- PR #[827](https://github.com/louislam/dockge/pull/827) Fullscreen yaml editor (by [Joshua-Beatty](https://github.com/Joshua-Beatty))
- PR #[834](https://github.com/louislam/dockge/pull/834) Add prune image on update process (by [MazziaRick](https://github.com/MazziaRick))
- PR #[863](https://github.com/louislam/dockge/pull/863) Add Docker Images Management Feature (by [felix068](https://github.com/felix068))
	- Currently under [feature/image-management](https://github.com/cmcooper1980/dockge/tree/feature/image-management) branch use docker tag `image-management`  
	  to test
- Commit [fc96f4e](https://github.com/louislam/dockge/commit/fc96f4edadcebe28eaf223c0a853261e908072a5) (by [Dracrius](https://github.com/Dracrius))
	- switch to a button group and matched existing UI style (no more eye searing stop and restart buttons)
	- Fixed message output to include a space after Service
	- Added Processing prop and Start,Stop,Restart events
- Commit [789f25a](https://github.com/louislam/dockge/commit/789f25a83c3eaed093f2a62e5a9477753d974524) (by [Dracrius](https://github.com/Dracrius))
	- Hide container controls if there is only one container  
      Final change to PR #[649](https://github.com/louislam/pull/649) as there is no need for the container controls if there is only a single container.
   
## 🔧 How to Install

Requirements:
- [Docker](https://docs.docker.com/engine/install/) 20+ / Podman
- (Podman only) podman-docker (Debian: `apt install podman-docker`)
- OS:
  - Major Linux distros that can run Docker/Podman such as:
     - ✅ Ubuntu
     - ✅ Debian (Bullseye or newer)
     - ✅ Raspbian (Bullseye or newer)
     - ✅ CentOS
     - ✅ Fedora
     - ✅ ArchLinux
  - ❌ Debian/Raspbian Buster or lower is not supported
  - ❌ Windows (Will be supported later)
- Arch: armv7, arm64, amd64 (a.k.a x86_64)

### Basic

- Default Stacks Directory: `/opt/stacks`
- Default Port: `5001`

```
# Create directories that store your stacks and stores Dockge's stack
mkdir -p /opt/stacks /opt/dockge
cd /opt/dockge

# Download the compose.yaml
curl https://raw.githubusercontent.com/cmcooper1980/dockge/master/compose.yaml --output compose.yaml

# Start the server
docker compose up -d

# If you are using docker-compose V1 or Podman
# docker-compose up -d
```

Dockge is now running on http://localhost:5001

### Advanced

If you want to store your stacks in another directory, you can generate your compose.yaml file by using the following URL with custom query strings and change the image from `louislam/dockge:1` to `cmcooper1980/dockge` after downloading if you want to use this fork; or see and update the example docker-compose.yml file at the bottom of this page.

### Download your compose.yaml
(in the link, change 5001 to your custom port and the /opt/stacks portion to your custom stack location)

`curl "https://dockge.kuma.pet/compose.yaml?port=5001&stacksPath=/opt/stacks" --output compose.yaml`

- port=`5001`
- stacksPath=`/opt/stacks`

Interactive compose.yaml generator is available on: 
`https://dockge.kuma.pet`

## How to Update

```
bash
cd /opt/dockge
docker compose pull && docker compose up -d
```

## Screenshots

<img width="3840" height="1039" alt="image" src="https://github.com/user-attachments/assets/6712e0ff-5853-4618-8d8e-7e06fb7375f4" />

<img width="2365" height="1205" alt="image" src="https://github.com/user-attachments/assets/eb4ef916-3793-4113-a8a3-7a7552e7869e" />

<img width="3838" height="821" alt="image" src="https://github.com/user-attachments/assets/c649b376-4d2a-4913-99f7-4e7ecb655e09" />

<img width="3172" height="1360" alt="image" src="https://github.com/user-attachments/assets/6fd78c58-7a45-460c-8702-020083477203" />






## Others

Dockge is built on top of [Compose V2](https://docs.docker.com/compose/migrate/). `compose.yaml`  also known as `docker-compose.yml`.

`compose.yaml` file above is great if cloning and building locally, otherwise, you can use this `docker-compose.yml` file to run docker command:
`docker compose up -d` just edit the appropriate field, `[CONFIG_LOCATION_FOR_DOCKGE]` (difference from compose.yaml is it does not have the build parameter):
```
services:
  dockge:
    image: cmcooper1980/dockge:latest
    container_name: dockge
    restart: unless-stopped
    environment:
      # Tell Dockge where your stacks directory is
      DOCKGE_STACKS_DIR: /opt/stacks #must be the same as the source and target bind mounted volume
      # Uncomment the following and enter valid Cloudflare Turnstile keys to activate CAPTCHA
      # *NOTE*: Turnstile should only be enabled on the dockge instance you consider to be the
      #         master if using remote agents, otherwise remote agents will not be able to
      #         connect due to the CAPTCHA challenge and if you must, only expose the master
      #         to the internet for access.
      #- TURNSTILE_SITE_KEY=0x4AAAAAAXXXXXXXX # uncomment this line to activate
      #- TURNSTILE_SECRET_KEY=0x4AAAAAAXXXX   # uncomment this line to activate
    ports:
      # Host Port : Container Port
      - 5001:5001
    volumes:
      - type: bind
        source: /var/run/docker.sock
        target: /var/run/docker.sock
        bind:
          create_host_path: true
      - type: bind
        source: [CONFIG_LOCATION_FOR_DOCKGE] # or wherever you keep your app data
        target: /app/data
        bind:
          create_host_path: true
      # If you want to use private registries, you need to share the auth file with Dockge:
      # - /root/.docker/:/root/.docker

      # Stacks Directory
      # ⚠️ READ IT CAREFULLY. If you did it wrong, your data could end up writing into a WRONG PATH.
      # ⚠️ 1. FULL path only. No relative path (MUST)
      # ⚠️ 2. source: and target: can be your preference but have to match, the environment variable
      #       DOCKGE_STACKS_DIR also has to match and is what tells dockge where your stacks
      #       directory is in the container
      - type: bind
        source: /opt/stacks
        target: /opt/stacks
        bind:
          create_host_path: true
