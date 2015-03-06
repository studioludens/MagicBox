<?xml version="1.0" encoding="utf-8"?>
<parametricbox version="2.0">
  <info>
    <info>
      <info>
        <info>
          <info>
            <info>
              <title>Magic Box Design</title>
              <id>magicbox.empty</id>
              <author/>
              <website>http://magic-box.org/</website>
              <tutorial/>
              <description>A default design</description>
            </info>
          </info>
        </info>
      </info>
    </info>
  </info>
  <variables>
    <variable name="boxes" title="Test List" value="{756.6666666666667,1450,933.3333333333333,600},{1100,700,1200,600},{2076.666666666667,1450,933.3333333333333,600},{3160,1230,400,600},{2820,480,600,600}" type="list"/>
    <variable name="outline" type="list" min="0" max="100" value="{950,0},{1100,0},{1100,550},{2450,550},{2450,1300},{3010,1300},{3010,1230},{2670,1230},{2670,330},{2670,0},{2820,0},{2820,330},{3420,330},{3420,0},{3570,0},{3570,330},{3570,1080},{3710,1080},{3710,1980},{3160,1980},{3160,2200},{1926.666666666667,2200},{1926.666666666667,1450},{1840,1450},{1840,2200},{606.6666666666669,2200},{606.6666666666669,1300},{950,1300},{950,550},{950,0}" showSettings="false"/>
    <variable name="holes" type="list" min="0" max="100" value="{{0,0},{0,100},{100,100},{10,0},{0,0}},{{30,30},{30,40},{40,40},{40,30},{30,30}}" showSettings="true"/>
    <variable name="depth" type="slider" min="0" max="700" value="521.4285714285714" showSettings="false"/>
  </variables>
  <layers>
    <path id="pressfit" stroke="#DDDDDD" stroke-width="1" stroke-opacity="1" fill="#888888" fill-opacity="0.5" visibility="visible" d="" mb_x="0" mb_y="0" mb_d="# pressfit squares&#xA;each boxes [&#xA; Miso $.1 0 $.2&#xA; #circle 1&#xA; rectiso $.3 $.4 ISO_LEFT true&#xA;]" mb_stroke="#DDDDDD" mb_strokeWidth="1" mb_strokeOpacity="1" mb_fill="#888888" mb_fillOpacity="0.5" mb_visibility="visible" mb__showStroke="true" mb__showFill="false" mb__showTransform="false">
      <transforms/>
    </path>
    <path id="back" stroke="#DDDDDD" stroke-width="1" stroke-opacity="1" fill="#888888" fill-opacity="0.5" visibility="visible" d="" mb_x="0" mb_y="0" mb_d="polyiso2d outline ISO_LEFT depth&#xA;&#xA;# cutouts&#xA;each boxes [&#xA; Miso $.1 depth $.2&#xA; rectiso $.3 $.4 ISO_LEFT true&#xA;]" mb_stroke="#DDDDDD" mb_strokeWidth="0" mb_strokeOpacity="1" mb_fill="#333333" mb_fillOpacity="1" mb_visibility="visible" mb__showStroke="true" mb__showFill="true" mb__showTransform="false">
      <transforms/>
    </path>
    <path id="boxes" stroke="#DDDDDD" stroke-width="1" stroke-opacity="1" fill="#888888" fill-opacity="0.5" visibility="visible" d="" mb_x="0" mb_y="0" mb_d="each boxes [&#xA; Miso $.1 0 $.2&#xA; boxiso $.3 depth $.4 SEETHROUGH&#xA;]" mb_stroke="#DDDDDD" mb_strokeWidth="0" mb_strokeOpacity="1" mb_fill="#cccccc" mb_fillOpacity="0.2391304347826087" mb_visibility="visible" mb__showStroke="true" mb__showFill="true" mb__showTransform="false">
      <transforms/>
    </path>
    <path id="front" stroke="#DDDDDD" stroke-width="1" stroke-opacity="1" fill="#888888" fill-opacity="0.5" visibility="visible" d="" mb_x="0" mb_y="0" mb_d="polyiso2d outline&#xA;&#xA;# cutouts&#xA;each boxes [&#xA; Miso $.1 0 $.2&#xA; rectiso $.3 $.4 ISO_LEFT true&#xA;]&#xA;&#xA;# holes&#xA;&#xA;each holes [&#xA; polyiso2d $&#xA;]" mb_stroke="#DDDDDD" mb_strokeWidth="0" mb_strokeOpacity="1" mb_fill="#333333" mb_fillOpacity="1" mb_visibility="visible" mb__showStroke="true" mb__showFill="true" mb__showTransform="false">
      <transforms/>
    </path>
  </layers>
</parametricbox>