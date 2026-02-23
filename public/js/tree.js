function renderTreeFromJSON(jsonStr) {
  const plan = JSON.parse(jsonStr);
  if (plan.root) {
    renderTree(plan.root);
  }
}

function renderTree(data) {
  const container = document.getElementById('output');
  container.innerHTML = '';

  const width = container.clientWidth || 600;
  const height = container.clientHeight || 500;
  const nodeWidth = 180;
  const nodeHeight = 70;

  const svg = d3.select('#output')
    .append('svg')
    .attr('width', width)
    .attr('height', height);

  const g = svg.append('g')
    .attr('transform', `translate(40, 40)`);

  const root = d3.hierarchy(data, d => d.children);
  const treeLayout = d3.tree().nodeSize([nodeWidth + 20, nodeHeight + 40]);
  treeLayout(root);

  // Center the tree
  const nodes = root.descendants();
  const minX = d3.min(nodes, d => d.x);
  const maxX = d3.max(nodes, d => d.x);
  const offsetX = (width - (maxX - minX)) / 2 - minX - 40;

  g.attr('transform', `translate(${offsetX}, 40)`);

  // Links
  g.selectAll('.link')
    .data(root.links())
    .join('path')
    .attr('class', 'link')
    .attr('d', d3.linkVertical()
      .x(d => d.x)
      .y(d => d.y));

  // Nodes
  const node = g.selectAll('.node')
    .data(nodes)
    .join('g')
    .attr('class', 'node')
    .attr('transform', d => `translate(${d.x - nodeWidth/2}, ${d.y - nodeHeight/2})`);

  node.append('rect')
    .attr('class', 'node-box')
    .attr('width', nodeWidth)
    .attr('height', nodeHeight);

  node.append('text')
    .attr('class', 'node-type-text')
    .attr('x', 10)
    .attr('y', 20)
    .text(d => d.data.node_type);

  node.append('text')
    .attr('class', 'node-table-text')
    .attr('x', 10)
    .attr('y', 35)
    .text(d => d.data.table_name ? `on ${d.data.table_name}` : '');

  node.append('text')
    .attr('class', 'node-stats-text')
    .attr('x', 10)
    .attr('y', 50)
    .text(d => {
      const parts = [];
      if (d.data.actual_time_total) parts.push(`${d.data.actual_time_total}ms`);
      if (d.data.actual_rows) parts.push(`${d.data.actual_rows} rows`);
      return parts.join(' / ');
    });

  node.append('text')
    .attr('class', 'node-stats-text')
    .attr('x', 10)
    .attr('y', 62)
    .text(d => d.data.cost_total ? `cost: ${d.data.cost_total}` : '');

  // Zoom
  svg.call(d3.zoom()
    .scaleExtent([0.3, 3])
    .on('zoom', (e) => g.attr('transform', e.transform)));
}
