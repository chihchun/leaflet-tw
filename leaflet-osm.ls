L.OSM = {}

L.OSM.TileLayer = L.TileLayer.extend do
  options: do
    url: if document.location.protocol is 'https:' then 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png' else 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
    attribution: '© <a target="_parent" href="http://www.openstreetmap.org">OpenStreetMap</a> and contributors, under an <a target="_parent" href="http://www.openstreetmap.org/copyright">open license</a>'
  
  initialize: (options) ->
    options = L.Util.setOptions @, options
    L.TileLayer::initialize.call @, options.url

L.OSM.Mapnik = L.OSM.TileLayer.extend do 
  options: do
   url: if document.location.protocol is 'https:' then 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png' else 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
   maxZoom: 19

L.OSM.CycleMap = L.OSM.TileLayer.extend do
  options: do
    url: 'http://{s}.tile.opencyclemap.org/cycle/{z}/{x}/{y}.png'
    attribution: 'Tiles courtesy of <a href=\'http://www.opencyclemap.org/\' target=\'_blank\'>Andy Allan</a>'

L.OSM.TransportMap = L.OSM.TileLayer.extend do 
  options: do 
    url: 'http://{s}.tile2.opencyclemap.org/transport/{z}/{x}/{y}.png'
    attribution: 'Tiles courtesy of <a href=\'http://www.opencyclemap.org/\' target=\'_blank\'>Andy Allan</a>'

L.OSM.MapQuestOpen = L.OSM.TileLayer.extend do 
  options: do
    url: if document.location.protocol is 'https:' then 'https://otile{s}-s.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png' else 'http://otile{s}.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png'
    subdomains: '1234'
    attribution: if document.location.protocol is 'https:'
      'Tiles courtesy of <a href=\'http://www.mapquest.com/\' target=\'_blank\'>MapQuest</a> <img src=\'https://developer.mapquest.com/content/osm/mq_logo.png\'>'
    else
      'Tiles courtesy of <a href=\'http://www.mapquest.com/\' target=\'_blank\'>MapQuest</a> <img src=\'http://developer.mapquest.com/content/osm/mq_logo.png\'>'

L.OSM.HOT = L.OSM.TileLayer.extend do 
  options: do
    url: 'http://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png'
    maxZoom: 20
    subdomains: 'abc'
    attribution: 'Tiles courtesy of <a href=\'http://hot.openstreetmap.org/\' target=\'_blank\'>Humanitarian OpenStreetMap Team</a>'

L.OSM.DataLayer = L.FeatureGroup.extend do
  options: do
    areaTags: 
      'area'
      'building'
      'leisure'
      'tourism'
      'ruins'
      'historic'
      'landuse'
      'military'
      'natural'
      'sport'
    uninterestingTags: 
      'source'
      'source_ref'
      'source:ref'
      'history'
      'attribution'
      'created_by'
      'tiger:county'
      'tiger:tlid'
      'tiger:upload_uuid'
    styles: {}

  initialize: (xml, options) ->
    L.Util.setOptions @, options
    L.FeatureGroup::initialize.call @
    @addData xml if xml
  addData: (features) ->
    features = @buildFeatures features if features not instanceof Array
    i = 0
    while i < features.length
      feature = features[i]
      layer = void
      if feature.type is 'changeset'
        layer = L.rectangle feature.latLngBounds, @options.styles.changeset
      else
        if feature.type is 'node'
          layer = L.circleMarker feature.latLng, @options.styles.node
        else
          latLngs = new Array feature.nodes.length
          j = 0
          while j < feature.nodes.length
            latLngs[j] = feature.nodes[j].latLng
            j++
          if @isWayArea feature
            latLngs.pop!
            layer = L.polygon latLngs, @options.styles.area
          else
            layer = L.polyline latLngs, @options.styles.way
      layer.addTo @
      layer.feature = feature
      i++
  buildFeatures: (xml) ->
    features = L.OSM.getChangesets xml
    nodes = L.OSM.getNodes xml
    ways = L.OSM.getWays xml, nodes
    relations = L.OSM.getRelations xml, nodes, ways
    for node_id of nodes
      node = nodes[node_id]
      features.push node if @interestingNode node, ways, relations
    i = 0
    while i < ways.length
      way = ways[i]
      features.push way
      i++
    features
  isWayArea: (way) ->
    return false if not (way.nodes.0 is way.nodes[way.nodes.length - 1])
    [return true if ~@options.areaTags.indexOf key for key of way.tags]
    false
  interestingNode: (node, ways, relations) ->
    used = false
    i = 0
    while i < ways.length
      if (ways[i].nodes.indexOf node) >= 0
        used = true
        break
      i++
    if not used then return true
    i = 0
    while i < relations.length
      return true if (relations[i].members.indexOf node) >= 0
      i++
    [return true if (@options.uninterestingTags.indexOf key) < 0 for key of node.tags]
    false

L.Util.extend L.OSM, do
  getChangesets: (xml) ->
    result = []
    nodes = xml.getElementsByTagName 'changeset'
    i = 0
    while i < nodes.length
      node = nodes[i]
      id = node.getAttribute 'id'
      result.push do
        id: id
        type: 'changeset'
        latLngBounds: L.latLngBounds [(node.getAttribute 'min_lat'), node.getAttribute 'min_lon'], [(node.getAttribute 'max_lat'), node.getAttribute 'max_lon']
        tags: @getTags node
      i++
    result
  getNodes: (xml) ->
    result = {}
    nodes = xml.getElementsByTagName 'node'
    i = 0
    while i < nodes.length
      node = nodes[i]
      id = node.getAttribute 'id'
      result[id] = do
        id: id
        type: 'node'
        latLng: L.latLng (node.getAttribute 'lat'), (node.getAttribute 'lon'), true
        tags: @getTags node
      i++
    result
  getWays: (xml, nodes) ->
    result = []
    ways = xml.getElementsByTagName 'way'
    i = 0
    while i < ways.length
      way = ways[i]
      nds = way.getElementsByTagName 'nd'
      way_object = do
        id: way.getAttribute 'id'
        type: 'way'
        nodes: new Array nds.length
        tags: @getTags way
      j = 0
      while j < nds.length
        way_object.nodes[j] = nodes[nds[j].getAttribute 'ref']
        j++
      result.push way_object
      i++
    result
  getRelations: (xml, nodes, ways) ->
    result = []
    rels = xml.getElementsByTagName 'relation'
    i = 0
    while i < rels.length
      rel = rels[i]
      members = rel.getElementsByTagName 'member'
      rel_object = {
        id: rel.getAttribute 'id'
        type: 'relation'
        members: new Array members.length
        tags: @getTags rel
      }
      j = 0
      while j < members.length
        if (members[j].getAttribute 'type') is 'node' then rel_object.members[j] = nodes[members[j].getAttribute 'ref'] else rel_object.members[j] = null
        j++
      result.push rel_object
      i++
    result
  getTags: (xml) ->
    result = {}
    tags = xml.getElementsByTagName 'tag'
    j = 0
    while j < tags.length
      result[tags[j].getAttribute 'k'] = tags[j].getAttribute 'v'
      j++
    result