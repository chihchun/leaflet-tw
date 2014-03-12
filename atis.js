L.ATIS = {};
L.ATIS.WMS = L.TileLayer.WMS.extend({
    // _url: "http://gis.sinica.edu.tw/googlemap/afasi_wms.php?",
    // _url: "http://ngis.afasi.gov.tw/asofb/wms?",
    _url: "http://whgis.nlsc.gov.tw/WMSProxy.ashx?",
    defaultWmsParams: {                                                                                                                                                                                                                
        service: 'WMS',
        request: 'GetMap',
        version: '1.1.0',
        layers: '',
        styles: '',
        format: 'image/gif',
        transparent: true,
    },

    options: {
        attribution: '© <a target="_target" href="http://www.afasi.gov.tw/">農林航空測量所</a>',
    },

    initialize: function (options) {                                                                                                                                                                                              

        this.defaultWmsParams['layers'] = this.layerid;
        var wmsParams = L.extend({}, this.defaultWmsParams);

        // all keys that are not TileLayer options go to WMS params
        for (var i in options) {
            if (!this.options.hasOwnProperty(i) && i !== 'crs') {
                wmsParams[i] = options[i];
            }
        }

        options = L.setOptions(this, options);

        wmsParams.width = wmsParams.height =
                options.tileSize * (options.detectRetina && L.Browser.retina ? 2 : 1);

        this.wmsParams = wmsParams;
    },
});

L.ATIS.MNC = L.ATIS.WMS.extend({
    name: "農航所航照",
    layerid: 'ATIS_MNC',
});

L.ATIS.ATIS_2010 = L.ATIS.WMS.extend({
    name: "農航所航照 2010 航照圖",
    layerid: 'ATIS_2010',
});

L.ATIS.Taiwan5k_96 = L.ATIS.WMS.extend({
    name: "農航所航照97 五千分之一航照基本圖",
    layerid: 'Taiwan5k_97',
});

L.ATIS.Frames = L.ATIS.WMS.extend({
    name: "農航所航照圖框",
    layerid: 'ATIS_frames',
});
