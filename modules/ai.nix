{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.claude-code
    unstable.antigravity-ide
    (writeShellScriptBin "agy" ''
      export GEMINI_API_KEY=`gpg -d ~/.authinfo.gpg | sed -n '/generativelanguage.googleapis.com/ s/.*password //p'`
      ${unstable.antigravity-cli}/bin/agy $@
    '')
  ];
}
