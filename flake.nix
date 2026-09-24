{
  description = "DOS development environment with Open Watcom v2 and DOSBox-X";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.open-watcom-v2
            pkgs.dosbox-x
            pkgs.tmux
            pkgs.clang-tools
            pkgs.nasm
            pkgs.hyprshot
            pkgs.asm-lsp
          ];
shellHook = ''
            export WATCOM="${pkgs.open-watcom-v2}"
            export PATH="$WATCOM/binl64:$PATH"
            export EDPATH="$WATCOM/eddat"
            export WIPATH="$WATCOM/wipath"
            export INCLUDE="$WATCOM/h:$WATCOM/h/dos"

            echo "=== DOS Development Environment Loaded ==="
            echo "Compiler: $(wcl -? 2>&1 | head -n 1)"
            echo "Emulator: dosbox-x"

            # Remove conflicting legacy .clangd
            rm -f .clangd

            # Generate clean compile_flags.txt for clangd / Neovim LSP
            cat << 'EOF' > compile_flags.txt
--target=i386-pc-none-elf
-fms-extensions
-fdeclspec
-nostdinc
-D__DOS__
-D__WATCOMC__=1300
-D__386__
-D_M_I386
-D__interrupt=
-D__far=
-D__near=
-D__watcall=
-ferror-limit=0
EOF

            echo "-I$WATCOM/h" >> compile_flags.txt
            echo "-I$WATCOM/h/dos" >> compile_flags.txt

            echo "⚡ Neovim compile_flags.txt updated!"
          '';
         };
      });
}

