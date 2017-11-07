

const WeexKdp = {
  show() {
      alert("module WeexKdp is created sucessfully ")
  }
};


var meta = {
   WeexKdp: [{
    name: 'show',
    args: []
  }]
};



if(window.Vue) {
  weex.registerModule('WeexKdp', WeexKdp);
}

function init(weex) {
  weex.registerApiModule('WeexKdp', WeexKdp, meta);
}
module.exports = {
  init:init
};
