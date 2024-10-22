//
// Copyright Opus Software. All rights reserved.
// https://www.opus-software.com.br/
//
// Opus Open Banking Handoff library v1
// --- MOCK VERSION ---
//
(function () {
  var root = this;

  var oobHandoff = function (obj) {
    if (obj instanceof oobHandoff) return obj;
    if (!(this instanceof oobHandoff)) return new oobHandoff(obj);
    this.oobHandoffwrapped = obj;
    this.src = document.currentScript.src;
  };

  root.oobHandoff = oobHandoff;

  let fetchTimer, timeoutTimer, myConfig;
  var step = 1, finished = false;

  var defaultConfig = {
    onHandoffReady(args) { },
    onHandoffQRRead() { },
    onHandoffTimedOut() { },
    onHandoffCompleted(args) { },
    onHandoffError(args) { }
  };

  oobHandoff.VERSION = '1.0.0-MOCKED';

  oobHandoff.init = function (config) {
    if(!config.oobStartCode) throw 'Missing oobStartCode';

    myConfig = {
      ...defaultConfig,
      ...config, 
      oobStartCode: atob(config.oobStartCode)
    };
    fetchTimer = setTimeout(oobFetchEvent, 10);
  };

  function oobHandoffTimeout() {
    if (finished) return;
    finished = true;
    myConfig.onHandoffTimedOut();
  }

  function oobFetchEvent() {
    if (finished) return;

    fetch(`${myConfig.oobStartCode}/step${step}.json`,
      {
        method: 'GET',
        mode: 'cors'
      })
      .then(response => response.json())
      .then(oobStatusResult);
  }

  function oobStatusResult(data) {
    console.log(data);

    // MOCK
    if (data && data.next) {
      setTimeout(oobFetchEvent, data.next.interval);
      step = data.next.step;
    }

    if (data && data.events) {
      data.events.map((e) => {
        if (e.type == "ready") {
          if (e?.args?.timeoutSeconds) timeoutTimer = setTimeout(oobHandoffTimeout, e.args.timeoutSeconds * 1000);
          myConfig.onHandoffReady(e.args);
        } else if (e.type == "read") {
          myConfig.onHandoffQRRead();
        } else if (e.type == "completed") {
          finished = true;
          if (timeoutTimer) clearTimeout(timeoutTimer);
          myConfig.onHandoffCompleted(e.args);
        } else if (e.type == "error") {
          finished = true;
          if (timeoutTimer) clearTimeout(timeoutTimer);
          myConfig.onHandoffError(e.args);
        } else {
          throw new 'Unknown event' + e.type;
        }
      });
    }
  }

  // AMD registration
  if (typeof define === 'function' && define.amd) {
    define('oobHandoff', [], function () {
      return oobHandoff;
    });
  };
}.call(this));