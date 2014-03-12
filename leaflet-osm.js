// Generated by LiveScript 1.2.0
(function(){
  L.OSM = {};
  L.OSM.TileLayer = L.TileLayer.extend({
    options: {
      url: document.location.protocol === 'https:' ? 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png' : 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      attribution: '© <a target="_parent" href="http://www.openstreetmap.org">OpenStreetMap</a> and contributors, under an <a target="_parent" href="http://www.openstreetmap.org/copyright">open license</a>'
    },
    initialize: function(options){
      options = L.Util.setOptions(this, options);
      return L.TileLayer.prototype.initialize.call(this, options.url);
    }
  });
  L.OSM.Mapnik = L.OSM.TileLayer.extend({
    options: {
      url: document.location.protocol === 'https:' ? 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png' : 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      maxZoom: 19
    }
  });
  L.OSM.CycleMap = L.OSM.TileLayer.extend({
    options: {
      url: 'http://{s}.tile.opencyclemap.org/cycle/{z}/{x}/{y}.png',
      attribution: 'Tiles courtesy of <a href=\'http://www.opencyclemap.org/\' target=\'_blank\'>Andy Allan</a>'
    }
  });
  L.OSM.TransportMap = L.OSM.TileLayer.extend({
    options: {
      url: 'http://{s}.tile2.opencyclemap.org/transport/{z}/{x}/{y}.png',
      attribution: 'Tiles courtesy of <a href=\'http://www.opencyclemap.org/\' target=\'_blank\'>Andy Allan</a>'
    }
  });
  L.OSM.MapQuestOpen = L.OSM.TileLayer.extend({
    options: {
      url: document.location.protocol === 'https:' ? 'https://otile{s}-s.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png' : 'http://otile{s}.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png',
      subdomains: '1234',
      attribution: document.location.protocol === 'https:' ? 'Tiles courtesy of <a href=\'http://www.mapquest.com/\' target=\'_blank\'>MapQuest</a> <img src=\'https://developer.mapquest.com/content/osm/mq_logo.png\'>' : 'Tiles courtesy of <a href=\'http://www.mapquest.com/\' target=\'_blank\'>MapQuest</a> <img src=\'http://developer.mapquest.com/content/osm/mq_logo.png\'>'
    }
  });
  L.OSM.HOT = L.OSM.TileLayer.extend({
    options: {
      url: 'http://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
      maxZoom: 20,
      subdomains: 'abc',
      attribution: 'Tiles courtesy of <a href=\'http://hot.openstreetmap.org/\' target=\'_blank\'>Humanitarian OpenStreetMap Team</a>'
    }
  });
  L.OSM.DataLayer = L.FeatureGroup.extend({
    options: {
      areaTags: ['area', 'building', 'leisure', 'tourism', 'ruins', 'historic', 'landuse', 'military', 'natural', 'sport'],
      uninterestingTags: ['source', 'source_ref', 'source:ref', 'history', 'attribution', 'created_by', 'tiger:county', 'tiger:tlid', 'tiger:upload_uuid'],
      styles: {}
    },
    initialize: function(xml, options){
      L.Util.setOptions(this, options);
      L.FeatureGroup.prototype.initialize.call(this);
      if (xml) {
        return this.addData(xml);
      }
    },
    addData: function(features){
      var i, feature, layer, latLngs, j, results$ = [];
      if (!(features instanceof Array)) {
        features = this.buildFeatures(features);
      }
      i = 0;
      while (i < features.length) {
        feature = features[i];
        layer = void 8;
        if (feature.type === 'changeset') {
          layer = L.rectangle(feature.latLngBounds, this.options.styles.changeset);
        } else {
          if (feature.type === 'node') {
            layer = L.circleMarker(feature.latLng, this.options.styles.node);
          } else {
            latLngs = new Array(feature.nodes.length);
            j = 0;
            while (j < feature.nodes.length) {
              latLngs[j] = feature.nodes[j].latLng;
              j++;
            }
            if (this.isWayArea(feature)) {
              latLngs.pop();
              layer = L.polygon(latLngs, this.options.styles.area);
            } else {
              layer = L.polyline(latLngs, this.options.styles.way);
            }
          }
        }
        layer.addTo(this);
        layer.feature = feature;
        results$.push(i++);
      }
      return results$;
    },
    buildFeatures: function(xml){
      var features, nodes, ways, relations, node_id, node, i, way;
      features = L.OSM.getChangesets(xml);
      nodes = L.OSM.getNodes(xml);
      ways = L.OSM.getWays(xml, nodes);
      relations = L.OSM.getRelations(xml, nodes, ways);
      for (node_id in nodes) {
        node = nodes[node_id];
        if (this.interestingNode(node, ways, relations)) {
          features.push(node);
        }
      }
      i = 0;
      while (i < ways.length) {
        way = ways[i];
        features.push(way);
        i++;
      }
      return features;
    },
    isWayArea: function(way){
      var key;
      if (!(way.nodes[0] === way.nodes[way.nodes.length - 1])) {
        return false;
      }
      for (key in way.tags) {
        if (~this.options.areaTags.indexOf(key)) {
          return true;
        }
      }
      return false;
    },
    interestingNode: function(node, ways, relations){
      var used, i, key;
      used = false;
      i = 0;
      while (i < ways.length) {
        if (ways[i].nodes.indexOf(node) >= 0) {
          used = true;
          break;
        }
        i++;
      }
      if (!used) {
        return true;
      }
      i = 0;
      while (i < relations.length) {
        if (relations[i].members.indexOf(node) >= 0) {
          return true;
        }
        i++;
      }
      for (key in node.tags) {
        if (this.options.uninterestingTags.indexOf(key) < 0) {
          return true;
        }
      }
      return false;
    }
  });
  L.Util.extend(L.OSM, {
    getChangesets: function(xml){
      var result, nodes, i, node, id;
      result = [];
      nodes = xml.getElementsByTagName('changeset');
      i = 0;
      while (i < nodes.length) {
        node = nodes[i];
        id = node.getAttribute('id');
        result.push({
          id: id,
          type: 'changeset',
          latLngBounds: L.latLngBounds([node.getAttribute('min_lat'), node.getAttribute('min_lon')], [node.getAttribute('max_lat'), node.getAttribute('max_lon')]),
          tags: this.getTags(node)
        });
        i++;
      }
      return result;
    },
    getNodes: function(xml){
      var result, nodes, i, node, id;
      result = {};
      nodes = xml.getElementsByTagName('node');
      i = 0;
      while (i < nodes.length) {
        node = nodes[i];
        id = node.getAttribute('id');
        result[id] = {
          id: id,
          type: 'node',
          latLng: L.latLng(node.getAttribute('lat'), node.getAttribute('lon'), true),
          tags: this.getTags(node)
        };
        i++;
      }
      return result;
    },
    getWays: function(xml, nodes){
      var result, ways, i, way, nds, way_object, j;
      result = [];
      ways = xml.getElementsByTagName('way');
      i = 0;
      while (i < ways.length) {
        way = ways[i];
        nds = way.getElementsByTagName('nd');
        way_object = {
          id: way.getAttribute('id'),
          type: 'way',
          nodes: new Array(nds.length),
          tags: this.getTags(way)
        };
        j = 0;
        while (j < nds.length) {
          way_object.nodes[j] = nodes[nds[j].getAttribute('ref')];
          j++;
        }
        result.push(way_object);
        i++;
      }
      return result;
    },
    getRelations: function(xml, nodes, ways){
      var result, rels, i, rel, members, rel_object, j;
      result = [];
      rels = xml.getElementsByTagName('relation');
      i = 0;
      while (i < rels.length) {
        rel = rels[i];
        members = rel.getElementsByTagName('member');
        rel_object = {
          id: rel.getAttribute('id'),
          type: 'relation',
          members: new Array(members.length),
          tags: this.getTags(rel)
        };
        j = 0;
        while (j < members.length) {
          if (members[j].getAttribute('type') === 'node') {
            rel_object.members[j] = nodes[members[j].getAttribute('ref')];
          } else {
            rel_object.members[j] = null;
          }
          j++;
        }
        result.push(rel_object);
        i++;
      }
      return result;
    },
    getTags: function(xml){
      var result, tags, j;
      result = {};
      tags = xml.getElementsByTagName('tag');
      j = 0;
      while (j < tags.length) {
        result[tags[j].getAttribute('k')] = tags[j].getAttribute('v');
        j++;
      }
      return result;
    }
  });
}).call(this);