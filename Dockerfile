FROM ubuntu:24.04

# Update and install dependencies
RUN apt-get update && apt-get install -y sudo curl

# Allow 'ubuntu' user to use sudo without password
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# ✅ Install Nix the recommended way
RUN curl -L https://nixos.org/nix/install | sh

# ✅ Source Nix profile for subsequent commands
ENV PATH="/root/.nix-profile/bin:$PATH"

# ✅ Ensure Nix flakes and nix-command are enabled
RUN mkdir -p /etc/nix && \
    echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

# ✅ Add `nixpkgs` channel and update it
RUN nix-channel --add https://nixos.org/channels/nixos-unstable nixpkgs && \
    nix-channel --update

# ✅ Install `devenv` using nix-env (after ensuring nixpkgs is available)
RUN nix-env -iA nixpkgs.devenv && \
    nix-env -q

# ✅ Clean up unnecessary files to reduce image size
RUN nix-collect-garbage -d
