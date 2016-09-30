// Generated by CoffeeScript 1.4.0
var DANViewExt;

DANViewExt = {
  paintMatrix: function() {
    var assayTestType2Color, assayType2Color, assays, color, color_value, colorise, column, draw_legend, elemWidth, fillRow, height, margin, matrix, max, mouseout, mouseover, n, nodes, numNodes, orders, row, scaleWidthFor, svg, tip, total, width, x, z;
    assays = this.model.get('graph');
    numNodes = assays.nodes.length;
    if (!(assays != null)) {
      return;
    }
    color_value = 'solid';
    assayType2Color = {
      'A': Color({
        r: 255,
        g: 0,
        b: 0
      }),
      'F': Color({
        r: 0,
        g: 255,
        b: 0
      }),
      'B': Color({
        r: 0,
        g: 0,
        b: 255
      }),
      'P': Color({
        r: 0,
        g: 255,
        b: 255
      }),
      'T': Color({
        r: 255,
        g: 0,
        b: 255
      }),
      'U': Color({
        r: 125,
        g: 125,
        b: 255
      }),
      "null": Color({
        r: 0,
        g: 0,
        b: 0
      })
    };
    assayTestType2Color = {
      'In vivo': Color({
        r: 255,
        g: 0,
        b: 0
      }),
      'In vitro': Color({
        r: 0,
        g: 255,
        b: 0
      }),
      'Ex vivo': Color({
        r: 0,
        g: 0,
        b: 255
      }),
      "null": Color({
        r: 0,
        g: 0,
        b: 0
      })
    };
    tip = d3.tip().attr('class', 'd3-tip').html(function(d) {
      if (typeof d === 'string' || d instanceof String) {
        return d;
      }
      return d.z;
    });
    mouseover = function(p) {
      tip.show(p);
      d3.selectAll(".dan-row text").classed("active", function(d, i) {
        return i === p.y;
      });
      return d3.selectAll(".dan-column text").classed("active", function(d, i) {
        return i === p.x;
      });
    };
    mouseout = function() {
      tip.hide();
      d3.selectAll("text").classed("active", false);
      return d3.selectAll("text").classed("linked", false);
    };
    fillRow = function(row) {
      var cell;
      return cell = d3.select(this).selectAll(".dan-cell").data(row).enter().append("rect").attr("class", "cell").attr("x", function(d) {
        return x(d.x);
      }).attr("width", x.rangeBand()).attr("height", x.rangeBand()).style("fill-opacity", function(d) {
        return d.z / max;
      }).style("fill", colorise).on("mouseover", mouseover).on("mouseout", mouseout);
    };
    colorise = function(d) {
      var as1, as2, color1, color2;
      color1 = null;
      color2 = null;
      if (color_value === 'solid') {
        return '#4caf50';
      }
      if (color_value === 'assay_type') {
        as1 = nodes[d.x].assay_type;
        as2 = nodes[d.y].assay_type;
        console.log('as1: ', as1);
        color1 = assayType2Color[as1].clone();
        color2 = assayType2Color[as2].clone();
      } else {
        as1 = nodes[d.x].assay_test_type;
        as2 = nodes[d.y].assay_test_type;
        color1 = assayTestType2Color[as1].clone();
        color2 = assayTestType2Color[as2].clone();
      }
      if (color1.hexString() !== color2.hexString()) {
        color1.mix(color2);
      }
      return color1.hexString();
    };
    margin = {
      top: 70,
      right: 0,
      bottom: 10,
      left: 90
    };
    elemWidth = $(this.el).width();
    scaleWidthFor = d3.scale.linear().domain([1, 20]).range([0.1 * elemWidth, 0.8 * elemWidth]).clamp(true);
    width = scaleWidthFor(numNodes);
    console.log('scale: ', scaleWidthFor);
    console.log('width: ', width);
    console.log('elem width: ', elemWidth);
    height = width;
    x = d3.scale.ordinal().rangeBands([0, width]);
    z = d3.scale.linear().domain([0, 4]).clamp(true);
    svg = d3.select('#' + this.$vis_elem.attr('id')).append('svg').attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    svg.call(tip);
    matrix = [];
    nodes = assays.nodes;
    total = 0;
    n = nodes.length;
    nodes.forEach(function(node, i) {
      node.index = i;
      node.count = 0;
      return matrix[i] = d3.range(n).map(function(j) {
        return {
          x: j,
          y: i,
          z: 0
        };
      });
    });
    console.log('Matrix!:');
    console.log(matrix);
    assays.links.forEach(function(link) {
      matrix[link.source][link.target].z = link.value;
      matrix[link.target][link.source].z = link.value;
      nodes[link.source].count += link.value;
      nodes[link.target].count += link.value;
      return total += link.value;
    });
    orders = {
      group: d3.range(n).sort(function(a, b) {
        return nodes[b].group - nodes[a].group;
      }),
      name: d3.range(n).sort(function(a, b) {
        return d3.ascending(nodes[a].name, nodes[b].name);
      }),
      count: d3.range(n).sort(function(a, b) {
        return nodes[b].count - nodes[a].count;
      }),
      assay_type: d3.range(n).sort(function(a, b) {
        return d3.ascending(nodes[a].assay_type, nodes[b].assay_type);
      }),
      assay_test_type: d3.range(n).sort(function(a, b) {
        return d3.ascending(nodes[a].assay_test_type, nodes[b].assay_test_type);
      })
    };
    console.log('Nodes:');
    console.log(nodes);
    console.log('Orders:');
    console.log(orders);
    max = d3.max(assays.links, function(d) {
      return d.value;
    });
    x.domain(orders.count);
    console.log('Orders count:');
    console.log(orders);
    svg.append("rect").attr("class", "background").style("fill", "white").attr("width", width).attr("height", height);
    row = svg.selectAll('.dan-row').data(matrix).enter().append('g').attr('class', 'dan-row').attr('transform', function(d, i) {
      return 'translate(0,' + x(i) + ')';
    }).each(fillRow);
    row.append("line").attr("x2", width);
    row.append("text").attr("x", -6).attr("y", x.rangeBand() / 2).attr("dy", ".32em").attr("text-anchor", "end").attr('style', 'font-size:8px;').attr('text-decoration', 'underline').attr('cursor', 'pointer').attr('fill', '#1b5e20').attr('class', 'tooltipped').attr('data-position', 'bottom').attr('data-delay', '50').attr('data-tooltip', function(d, i) {
      return nodes[i].description;
    }).text(function(d, i) {
      return nodes[i].name + '.' + nodes[i].assay_type;
    }).on("mouseover", function(row, j) {
      return d3.selectAll(".row text").classed("linked", function(d, i) {
        return i === j;
      });
    }).on("mouseout", mouseout).on("click", function(d, i) {
      return window.location = "/assay_report_card/" + nodes[i].name;
    });
    column = svg.selectAll(".dan-column").data(matrix).enter().append("g").attr("class", "dan-column").attr("transform", function(d, i) {
      return "translate(" + x(i) + ")rotate(-90)";
    });
    column.append("line").attr("x1", -width);
    column.append("text").attr("x", 0).attr("y", x.rangeBand() / 2).attr("dy", ".32em").attr("text-anchor", "start").attr('style', 'font-size:8px;').attr('text-decoration', 'underline').attr('cursor', 'pointer').attr('fill', '#1b5e20').attr('class', 'tooltipped').attr('data-position', 'bottom').attr('data-delay', '50').attr('data-tooltip', function(d, i) {
      return nodes[i].description;
    }).text(function(d, i) {
      return nodes[i].name + '.' + nodes[i].assay_type;
    }).on("mouseover", function(col, j) {
      return d3.selectAll(".column text").classed("linked", function(d, i) {
        return i === j;
      });
    }).on("mouseout", mouseout).on("click", function(d, i) {
      return window.location = "/assay_report_card/" + nodes[i].name;
    });
    $('.tooltipped').tooltip();
    $(this.el).find(".select-colours").on("change", function() {
      var palette;
      if (!(this.value != null)) {
        return;
      }
      color_value = this.value;
      color();
      $('.legend-container').empty();
      if (color_value === 'solid') {
        return;
      }
      if (color_value === 'assay_type') {
        palette = assayType2Color;
      } else {
        palette = assayTestType2Color;
      }
      $('.legend-container').append('<div class="legend">Legend:</div>');
      return draw_legend(palette);
    });
    color = function() {
      var t;
      t = svg.transition().duration(2500);
      return t.selectAll(".cell").style("fill", colorise);
    };
    return draw_legend = function(data) {
      var legend;
      console.log('drawing legend');
      legend = d3.selectAll(".legend-container").append("svg").attr("class", "legend").attr("width", 100).attr("height", 150).selectAll("g").data($.map(data, function(val, key) {
        return {
          label: key,
          color: val
        };
      })).enter().append("g").attr("transform", function(d, i) {
        return "translate(0," + i * 20 + ")";
      });
      legend.append("rect").attr("width", 18).attr("height", 18).style("fill", function(d) {
        return d.color.hexString();
      });
      return legend.append("text").attr("x", 24).attr("y", 9).attr("dy", ".35em").text(function(d) {
        return d.label;
      });
    };
  }
};
