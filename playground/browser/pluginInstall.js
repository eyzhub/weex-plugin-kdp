import WeexKdp from "../../js/src";

if (window.Weex) {
  Weex.install(WeexKdp);
} else if (window.weex) {
  weex.install(WeexKdp);
}