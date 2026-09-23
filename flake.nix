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

            # 1. compile_flags.txt (sem indentação nos itens)
            cat << EOF > compile_flags.txt
-nostdinc
-I$WATCOM/h
-I$WATCOM/h/dos
-D__DOS__
-D__WATCOMC__=1200
-D__SW_MS
-D__far=
-D_far=
-Dfar=
-Wno-implicit-function-declaration
EOF

            # 2. .clangd limpo (sem 'Compiler: wcl')
            cat << EOF > .clangd
CompileFlags:
  Add:
    - -nostdinc
    - -I$WATCOM/h
    - -I$WATCOM/h/dos
    - -D__DOS__
    - -D__WATCOMC__=1200
    - -D__SW_MS
    - -D__far=
    - -D_far=
    - -Dfar=
    - -Wno-implicit-function-declaration
EOF

            echo "⚡ Neovim LSP anchors (.clangd & compile_flags.txt) updated!"
          '';

         };
      });
}

