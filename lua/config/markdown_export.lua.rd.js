var config = {
  theme:'forest',
  logLevel: 5, // corresponds with "fatal"
  securityLevel:'strict',
  startOnLoad:true,
  arrowMarkerAbsolute:false,

  er:{
    diagramPadding:20,
    layoutDirection:'TB',
    minEntityWidth:100,
    minEntityHeight:75,
    entityPadding:15,
    stroke:'gray',
    fill:'honeydew',
    fontSize:24,
    useMaxWidth:true,
  },
  flowchart:{
    diagramPadding:8,
    htmlLabels:true,
    curve:'basis',
  },
  sequence:{
    diagramMarginX:50,
    diagramMarginY:10,
    actorMargin:50,
    width:150,
    height:65,
    boxMargin:10,
    boxTextMargin:5,
    noteMargin:10,
    messageMargin:35,
    messageAlign:'center',
    mirrorActors:true,
    bottomMarginAdj:1,
    useMaxWidth:true,
    rightAngles:false,
    showSequenceNumbers:false,
  },
  gantt:{
    titleTopMargin:25,
    barHeight:20,
    barGap:4,
    topPadding:50,
    leftPadding:75,
    gridLineStartPadding:35,
    fontSize:24,
    fontFamily:'"Open-Sans", "sans-serif"',
    numberSectionStyles:4,
    axisFormat:'%Y-%m-%d',
    topAxis:false,
  }
};
mermaid.initialize(config);

