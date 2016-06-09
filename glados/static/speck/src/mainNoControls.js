"use strict";

var fs = require("fs");
var kb = require("keyboardjs");
var lz = require("lz-string");
var $ = require("jquery");

var Renderer = require("./renderer");
var View = require("./view");
var System = require("./system");
var xyz = require("./xyz");
var samples = require("./samples");
var elements = require("./elements");
var presets = require("./presets");
var mimetypes = require("./mimetypes");


kb.active = function (key) {
  var keys = kb.activeKeys();
  for (var i = 0; i < keys.length; i++) {
    if (key === keys[i]) {
      return true;
    }
  }
  return false;
}

var system = System.new();
var view = View.new();
var renderer = null;
var needReset = false;

var renderContainer;

function loadStructure(data) {
  system = System.new();
  for (var i = 0; i < data.length; i++) {
    var a = data[i];
    var x = a.position[0];
    var y = a.position[1];
    var z = a.position[2];
    System.addAtom(system, a.symbol, x, y, z);
  }
  System.center(system);
  System.calculateBonds(system);
  renderer.setSystem(system, view);
  View.center(view, system);
  needReset = true;
}

function loadSample() {

  $.ajax({
    url: "static/samples/testosterone.xyz",
    success: function (data) {
      loadStructure(xyz(data)[0]);
    }
  });
}

function loadDataDirectly(data) {

  loadStructure(xyz(data)[0]);

}

var startVisualisation = function (rendererContainerID, canvasID, data) {

  renderContainer = document.getElementById(rendererContainerID);

  var imposterCanvas = document.getElementById(canvasID);

  console.log('resolution:')
  console.log(view.resolution)
  console.log($('#' + canvasID).width())
  //renderer = new Renderer(imposterCanvas, view.resolution, view.aoRes);
  renderer = new Renderer(imposterCanvas, 400, view.aoRes);

  loadDataDirectly(data);

  var lastX = 0.0;
  var lastY = 0.0;
  var buttonDown = false;

  renderContainer.addEventListener("mousedown", function (e) {
    document.body.style.cursor = "none";
    if (e.button == 0) {
      buttonDown = true;
    }
    lastX = e.clientX;
    lastY = e.clientY;
  });

  renderContainer.addEventListener("mouseup", function (e) {
    document.body.style.cursor = "";
    if (e.button == 0) {
      buttonDown = false;
    }
  });

  setInterval(function () {
    if (!buttonDown) {
      document.body.style.cursor = "";
    }
  }, 10);

  renderContainer.addEventListener("mousemove", function (e) {
    if (!buttonDown) {
      return;
    }
    var dx = e.clientX - lastX;
    var dy = e.clientY - lastY;
    if (dx == 0 && dy == 0) {
      return;
    }
    lastX = e.clientX;
    lastY = e.clientY;
    if (e.shiftKey) {
      View.translate(view, dx, dy);
    } else {
      View.rotate(view, dx, dy);
    }
    needReset = true;
  });

  renderContainer.addEventListener("wheel", function (e) {
    var wd = 0;
    if (e.deltaY < 0) {
      wd = 1;
    }
    else {
      wd = -1;
    }

    view.zoom = view.zoom * (wd === 1 ? 1 / 0.9 : 0.9);
    View.resolve(view);
    needReset = true;

    e.preventDefault();
  });


  function loop() {

    if (needReset) {
      renderer.reset();
      needReset = false;
    }
    renderer.render(view);
    requestAnimationFrame(loop);
  }

  loop();

}


var MoleculeVisualisator = (function () {

  function MoleculeVisualisator() {
  };

  MoleculeVisualisator.initVsualisation = function (rendererContainerId, rendererCanvasId, xyzUrl) {

      $.ajax({
        url: xyzUrl,
        success: function (data) {
          startVisualisation(rendererContainerId, rendererCanvasId, data);
        }
      });



  }

  MoleculeVisualisator.initVsualisationFromData = function (rendererContainerId, rendererCanvasId, xyzData) {

    startVisualisation(rendererContainerId, rendererCanvasId, xyzData);


  }

  return MoleculeVisualisator;

})();

window.MoleculeVisualisator = MoleculeVisualisator;


