FROM ubuntu:24.04

# Update and install sudo
RUN apt-get update && apt-get install -y sudo

# Allow ubuntu user to use sudo without password
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up Nix environment
ENV PATH="$PATH:/root/.nix-profile/bin/"
RUN apt-get update && apt-get install -y nix direnv git git-lfs && \
    git lfs install && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/* && \
    mkdir -p /etc/nix && \
    echo "trusted-users = root ubuntu " | tee -a /etc/nix/nix.conf && \
    echo "cores = 0" | tee -a /etc/nix/nix.conf && \
    echo "max-jobs = auto" | tee -a /etc/nix/nix.conf && \
    echo "experimental-features = nix-command flakes" | tee -a /etc/nix/nix.conf

# Ensure /root/.nix-profile is set up
RUN ln -s /nix/var/nix/profiles/per-user/root/profile /root/.nix-profile

# 🛠 **Fix: Preinstall devenv**
RUN . /root/.nix-profile/etc/profile.d/nix.sh && \
    nix-env -iA nixpkgs.devenv && \
    nix-env -q
