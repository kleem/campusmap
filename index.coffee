svg = d3.select 'svg'
width = svg.node().getBoundingClientRect().width
height = svg.node().getBoundingClientRect().height

svg.append 'circle'
  .attrs
    r: 200
    cx: width/2
    cy: height/2
    fill: 'teal'
    
svg.append 'circle'
  .attrs
    r: 60
    cx: 2*width/5
    cy: height/3
    fill: 'orange'
    
