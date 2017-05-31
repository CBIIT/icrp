import * as d3 from 'd3';

export class PieChart {

    draw(
        el: HTMLElement,
        tooltipEl: HTMLElement,
        data: { label: string, data: any }[],
        primaryKey: string) {

        let host = d3.select(el);
        let tooltip = d3.select(tooltipEl)
            .attr('class', 'd3-tooltip')
            .style('opacity', 0);

        let size = 400;
        let radius = size / 2;

        let arc: any = d3.arc().outerRadius(radius).innerRadius(radius/2);
        let pie = d3.pie();

        let color = d3.scaleOrdinal(d3.schemeCategory20c);

        let empty = !data || data.length === 0;
        if (empty) {
            data = [{
                label: '',
                data: {
                    [primaryKey]: 1
                },
            }]
        }

        let sum = data.map(e => parseFloat((e.data[primaryKey]).toString()) || 0).reduce((a, b) => a + b, 0);

        let svg = host
            .attr('width', '100%')
            .attr('viewBox', `0 0 ${size} ${size}` )
            .append('g')
            .attr('transform', `translate(${size / 2}, ${size / 2})`);

        // append individual pieces
        let path = svg.selectAll('path')
            .data(pie(data.map(e => parseFloat(e.data[primaryKey].toString()) || 1)))
            .enter().append('path')
            .on('mouseover', d => {
                let index = d.index;
                let label = data[index].label;
                let entry = data[index].data;
                let value = data[index].data[primaryKey] || 0;
                let keys = Object.keys(data[index].data).sort((a, b) => {
                  if (a == primaryKey)
                    return -1;
                  else if (b == primaryKey)
                    return 1;
                  return 0;
                });

                let html = empty
                  ? 'No Data Available'
                  : `<b>${label}</b>
                    <hr style="margin: 2px"/>`;

                if (!empty) {
                  let rows = [];
                  for (let key of keys) {
                    let displayKey = {
                      count: 'Total',
                      relevance: 'Relevance',
                      amount: 'Amount'
                    }[key] || key;

                    let value = parseFloat(entry[key]);
                    let displayValue = '';

                    if (key === 'amount') {
                        displayValue = value.toLocaleString('en-US', {
                            style: 'currency',
                            currency: 'USD',
                        })
                    }

                    else {
                        displayValue = value.toLocaleString();
                    }

                    let row = [
                        displayKey,
                        displayValue,
                    ].join(': ');


                    if (key === primaryKey) {
                      row += ` (${(100 * entry[key]/sum).toFixed(2)}%)`
                    }
                    rows.push(row);
                  }

                  html += rows.join('<br>');
                }

                tooltip.html(html)
                tooltip.transition()
                    .duration(200)
                    .style('opacity', .9);

            })
            .on('mousemove', d => {
                var xoffset = (d3.event.pageX / window.outerWidth > 0.7) ? -165 : 5;
                tooltip
                    .style('left', (d3.event.pageX + 10) + 'px')
                    .style('top', (d3.event.pageY + 10 - (window.scrollY || window.pageYOffset)) + 'px')
            })
            .on('mouseout', d => {
                tooltip.transition()
                    .duration(300)
                    .style('opacity', 0);
            })
            .each(e => e)
            .attr('d', arc)
            .style('fill', d =>
                empty || !parseFloat(data[d.index].data[primaryKey].toString()) ? '#ddd' : color(d.index.toString()))
    }

    /**
     * Exports a base64-encoded png
     */
    export(data: any[]): string {
        return '';
    }
}
