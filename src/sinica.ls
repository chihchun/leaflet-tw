L.SINICA = {}

L.SINICA.WMS = L.TileLayer.WMS.extend do
  _url: 'http://gis.sinica.edu.tw/tileserver/wmts'
  defaultWmsParams: do
    service: 'WMS'
    request: 'GetMap'
    version: '1.1.0'
    layers: ''
    styles: ''
    format: 'image/jpeg'
    transparent: true
  
  options: {attribution: '© <a target="_target" href="http://gis.sinica.edu.tw/">中央研究院地理資訊科技研發與應用</a>'}
  initialize: (options) ->
    @defaultWmsParams.'layers' = @layerid
    wmsParams = L.extend {}, @defaultWmsParams
    for i of options
      wmsParams[i] = options[i] if (not @options[i]?) && i isnt 'crs'
    options = L.setOptions @, options
    wmsParams.width = wmsParams.height = options.tileSize * if options.detectRetina && L.Browser.retina then 2 else 1
    @wmsParams = wmsParams

L.SINICA.TM25K_2001 = L.SINICA.WMS.extend do
  name: '2001-臺灣經建3版地形圖-1:25,000'
  layerid: 'TM25K_2001'

