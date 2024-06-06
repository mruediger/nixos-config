{ ... }:
{
  users.extraUsers.bag = {
    description = "Mathias Rüdiger";
    home = "/home/bag";
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "input" "video" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFsvZoC8Cl2by+hHJWhZYPLKGfM50Y6OgUXehSwFGVt1 bag@josephine"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0mY0TcE84d7TK5vHt8Fcekm8QBcMN0kA+WT+ED5XF3s87wIQGic/BUteT6At4cL728v7lzdHPTTqYqKLK9Q2vLfz31JhbVWcWwBptSJCjCuAnf7fN9QP+NJ3Bi+/MAlX8wQ7raRhmO2l2u6yL8SE9Ig4BPYwUf60dY97b1t3RXZEUYu1GR0lxpzjCJeER+c9JwczzkegwWa+NmajK2hVOBrbj+BXLiJOTUHVk0r7HU3hkt5YatTQSWAVrP/SY0pcrRidy5Eslyi/cszI6C4DApXAHH+vC6EdBjKL/B3IgujgU0GtVF5ec/Ta3zO09MO0YbKDUDMnRJJV9ruJnyVmCEYCd73E9FklL9Ki1zIPotsyTd/8+5gcoz+p7sNGV1NqtMOH8EEd5OpkDHr1Eyf0qUcZBS5sRb2dbf6p9plv6UuynXMfI+ldYXjB4nLOk3CnNM5RLDFZB4c7HTgp6dGnlBU14tnZ/s7e/Ph3DU/hUkWJ9a44+GEf529vjkMcKocM= bag@butterfly"
    ];
  };

  security = {
    sudo = {
      enable = true;
    };
  };

  home-manager.users.bag = { };
}
