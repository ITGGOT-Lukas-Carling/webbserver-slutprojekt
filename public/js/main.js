window.onload = function(){
    (function(){
      var show = function(el){
        return function(msg){ el.innerHTML = msg + '<br />' + el.innerHTML; }
      }(document.getElementById('msgs'));

      var ws = new WebSocket('ws://' + window.location.host + window.location.pathname);
      ws.onopen = function()  { show(''); };
      ws.onclose = function()  { show('chatt closed'); }
      ws.onmessage = function(m) { show(m.data); }; // { show(m.data); }; --> { show('websocket message: 'm.data); };

      var sender = function(f){
        var input = document.getElementById('input');
        input.onclick = function(){ input.value = "" };
        f.onsubmit = function(){
          ws.send(input.value);
          input.value = "";
          return false;
        }
      }(document.getElementById('form'));
    })();
  }