L.SINICA = {}
L.SINICA.TileLayer = L.TileLayer.extend do
  options: {attribution: '© <a target="_target" href="http://gis.sinica.edu.tw/">Sinica</a>'}
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

layers = do
    "1956_Landuse": do
      name: "1956-臺灣土地利用及林型圖"
      ext: 'png'
    "AM50K_1944": do
      name: "1944-美軍地形圖-1:50,000"
      ext: 'png'
    "AMCityPlan_1945": do
      name: "1945-美軍繪製臺灣城市地圖"
      maxZoom: 17
      minZoom: 12
      ext: 'png'
#    "Admin_1901a": do
#      name: "1901-日治行政區_廳(1900年代)"
#    "Admin_1901b": do
#      name: "1901-日治行政區_堡里(1900年代)"
#    "Admin_1901c": do
#      name: "1901-日治行政區_街庄(1900年代)"
#    "Admin_1930a": do
#      name: "1930-日治行政區_州廳(1930年代)"
#    "Admin_1930b": do
#      name: "1930-日治行政區_郡市(1930年代)"
#    "Admin_1930c": do
#      name: "1930-日治行政區_街庄(1930年代)"
    "JM100K_1905": do
      name: "1905-日治臺灣圖-1:100,000"
    "JM200K_1897": do
      name: "1897-日治臺灣假製二十萬分一圖-1:200,000"
    "JM200K_1932": do
      name: "1932-二十萬分一帝國圖(臺灣部分)"
    'JM20K_1904': do 
      name: "1904-日治臺灣堡圖(明治版)-1:20,000"
      ext: 'jpg'
#     "JM20K_1904_Redraw": do
#       name: "1904-日治臺灣堡圖(重繪版)-1:20,000"
    "JM20K_1921": do
      name: "1921-日治臺灣堡圖(大正版)-1:20,000"
      ext: 'jpg'
    "JM25K_1921": do
      name: "1921-日治地形圖-1:25,000"
    "JM25K_1944": do
      name: "1944-日治地形圖(航照修正版)-1:25,000"
    "JM300K_1924": do
      name: "1924-日治臺灣全圖(第三版)-1:300,000"
      ext: 'jpg'
    "JM300K_1939": do
      name: "1939-日治臺灣全圖(第五版)-1:300,000"
      ext: 'png'
    "JM400K_1899": do
      name: "1899-日治臺灣全圖-1:400,000"
    "JM500K_1936": do
      name: "1936-五十萬分一輿地圖(臺灣部分)-1:500,000"
    "JM50K_1916": do
      name: "1916-日治蕃地地形圖-1:50,000"
      ext: 'jpg'
    "JM50K_1920": do
      name: "1920-日治地形圖(總督府土木局)-1:50,000"
      maxZoom: 16
      minZoom: 5
    "JM50K_1924": do
      name: "1924-日治地形圖(陸地測量部)-1:50,000"
      ext: 'jpg'
    "TM100K_1987": do
      name: "1987-臺灣地形圖-1:100,000"
    "TM25K_1989": do
      name: "1989-臺灣經建1版地形圖-1:25,000"
      ext: 'jpg'
    "TM25K_1993": do
      name: "1993-臺灣經建2版地形圖-1:25,000"
      ext: 'jpg'
    "TM25K_2001": do
      name: "2001-臺灣經建3版地形圖-1:25,000"
      ext: 'jpg'
    "TM25K_2003": do
      name: "2003-臺灣經建4版地形圖-1:25,000"
      ext: 'jpg'
    "TM50K_1956": do
      name: "1956-臺灣地形圖-1:50,000"
      ext: 'jpg'
    "TM50K_1990": do
      name: "1990-臺灣經建1版地形圖-1:50,000"
    "TM50K_1996": do
      name: "1996-臺灣經建2版地形圖-1:50,000"
    "TM50K_2002": do
      name: "2002-臺灣經建3版地形圖-1:50,000"
    "Taipei_aerialphoto_1945": do
      name: "美軍航照影像(1945/6/17攝)"
      ext: 'jpg'
#    'Tainan_1875': do 
#      name: '1985-臺灣府城街道圖(1875)'
#      url: 'http://gis.sinica.edu.tw/tainan/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=Tainan_1875&STYLE=_null&TILEMATRIXSET= GoogleMapsCompatible &TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&FORMAT=image/png'
    'Tainan_1875B': do 
      name: '1875-臺灣府城並安平海口圖'
      minZoom: 12
      MaxZoom: 18
    'Tainan_1895': do 
      name: '1895-日治五萬分之一地形圖_臺南地區'
    'Tainan_1895c': do 
      name: '1895-日治五萬分之一地形圖_臺南地區'
    'Tainan_1896': do 
      name: '1896-臺南城圖'
    'Tainan_1900': do 
      name: '1900-臺南城圖'
    'Tainan_1907B': do 
      name: '市區改正臺南市街全圖(1907)'
    'Tainan_1911': do 
      name: '臺南市區改正計畫圖(1911)'
    'Tainan_1915': do 
      name: '臺南市全圖(1915)' 
    'Tainan_20K_1917': do 
      name: '1917-臺南市全圖' 
    'Tainan_1918': do 
      name: '臺南市全圖(1918)'
    'Tainan_1920': do 
      name: '臺南市全圖(1920)'
    'Tainan_1924B': do 
      name: '臺南市全圖(1924)'
    'Tainan_1935': do 
      name: '臺南市街圖(1935)'
    'Tainan_1936': do 
      name: '臺南職業別明細圖(1936)'
      ext: \jpg
    'Tainan_1939': do 
      name: '臺南市街略圖(1939)'
    'Tainan_1945': do 
      name: '臺南市新舊街路名圖(1945)'
    'Tainan_1946': do 
      name: '臺南市全圖(1946)'
    'Tainan_1951': do 
      name: '安平港海圖(1951)'
    'Tainan_1959': do 
      name: '臺南市街圖(1959)'
    'Tainan_1971': do
      name: '臺南市街詳細圖(1971)'
    'Tainan_1974': do 
      name: '1974-臺南市全圖'
    'Tainan_1982': do 
      name: '1982-臺南市圖'
    'Tainan_1984': do 
      name: '1984-臺南市街圖'
    'Tainan_1986': do 
      name: '1986-臺南市都市計畫圖(藍曬)'
    'Tainan_1K_2010': do
      name: '2010-臺南市航照影像'
#     'TainanDTM': do
#       name: '臺南數值高程圖'
#     'topographic_1921': do
#       name: '1921-日治二萬五千分之一地形圖(高精度)'

L.SINICA.TileLayers = []
for id, opts of layers
  ext = opts.ext? and opts.ext or 'png'
  opts['url'] = opts.url? and opts.url or "http://gis.sinica.edu.tw/googlemap/" + id + "/{z}/{x}/IMG_{x}_{y}_{z}." + ext;                                                                                                        
  L.SINICA.TileLayers[id] = L.SINICA.TileLayer.extend do
    name: opts.name
    options: opts
