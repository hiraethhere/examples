#!/bin/bash

set -ex

# Enter temporary directory.
pushd /tmp

# Install Homebrew
curl --location --output install-brew.sh "https://raw.githubusercontent.com/Homebrew/install/master/install.sh"
bash install-brew.sh
rm install-brew.sh

# Install Node.
version=14.15.4
curl --location --output node.pkg "https://nodejs.org/dist/v$version/node-v$version.pkg"
sudo installer -pkg node.pkg -store -target /
rm node.pkg

# Install DFINITY SDK.
version=0.8.5
curl --location --output install-dfx.sh "https://sdk.dfinity.org/install.sh"
DFX_VERSION=$version bash install-dfx.sh < <(yes Y)
rm install-dfx.sh

# Install Vessel and Alias Moc
curl --location --output vessel-macos "https://github.com/dfinity/vessel/releases/download/v0.6.2/vessel-macos"
chown -R "$(whoami)" ./vessel-macos && chmod -R +x ./vessel-macos

# Install cmake
brew install cmake

# Install rust
curl --location --output install-rustup.sh "https://sh.rustup.rs"
bash install-rustup.sh -y
rustup target add wasm32-unknown-unknown

# Exit temporary directory.
popd

# Set aliases
echo alias vessel="/tmp/vessel-macos" >> .bashrc
echo alias moc="$(vessel bin)/moc" >> .bashrc
echo alias mo-doc="$(vessel bin)/mo-doc" >> .bashrc
echo alias mo-ide="$(vessel bin)/mo-ide" >> .bashrc
