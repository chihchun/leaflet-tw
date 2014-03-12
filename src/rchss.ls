L.RCHSS = {}

L.RCHSS.TileLayer = L.TileLayer.extend do
  options: {attribution: '© <a target="_target" href="http://gis.rchss.sinica.edu.tw/">GIS_RCHSS_AS</a>'}
  initialize: (options) ->
    options = L.Util.setOptions @, options
    L.TileLayer::initialize.call @, options.url
  getTileUrl: (tilePoint) ->
    L.Util.template @_url, L.extend {
      s: @_getSubdomain tilePoint
      z: 17 - tilePoint.z
      tilePoint.x
      tilePoint.y
    }, @options

L.RCHSS.Chiayi1900 = L.RCHSS.TileLayer.extend do
  name: '嘉義市街圖(1935)'
  options: do
    url: 'http://gis.sinica.edu.tw/googlemap/chiayi_1900/{z}/{x}/IMG_{x}_{y}_{z}.png'
    minZoom: 11
    maxZoom: 18

L.RCHSS.Chiayi1909 = L.RCHSS.TileLayer.extend do
  name: '嘉義市區改正圖(1909)'
  options: do
    url: 'http://gis.sinica.edu.tw/googlemap/chiayi_1909/{z}/{x}/IMG_{x}_{y}_{z}.png'
    minZoom: 11
    maxZoom: 18

L.RCHSS.Chiayi1931 = L.RCHSS.TileLayer.extend do
  name: '嘉義市街實測圖(1931)'
  options: do
    url: 'http://gis.sinica.edu.tw/googlemap/chiayi_1931/{z}/{x}/IMG_{x}_{y}_{z}.png'
    minZoom: 11
    maxZoom: 18

L.RCHSS.Chiayi1932 = L.RCHSS.TileLayer.extend do
  name: '嘉義市區計畫平面圖(1932)'
  options: do
    url: 'http://gis.sinica.edu.tw/googlemap/chiayi_1932/{z}/{x}/IMG_{x}_{y}_{z}.png'
    minZoom: 11
    maxZoom: 18

L.RCHSS.Chiayi1936 = L.RCHSS.TileLayer.extend do
  name: '嘉義市職業別明細圖(1936)'
  options: do
    url: 'http://gis.sinica.edu.tw/googlemap/chiayi_1936/{z}/{x}/IMG_{x}_{y}_{z}.png'
    minZoom: 12
    maxZoom: 17

L.RCHSS.Chiayi_12K_1926 = L.RCHSS.TileLayer.extend do
  name: '嘉義市內地圖(1940)'
  options: {url: 'http://gis.sinica.edu.tw/googlemap/Chiayi_12K_1926/{z}/{x}/IMG_{x}_{y}_{z}.png'}