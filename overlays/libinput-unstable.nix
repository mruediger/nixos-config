self: super:
let
  unstable = import <unstable> {};
in
{
  libinput = unstable.libinput;
}
