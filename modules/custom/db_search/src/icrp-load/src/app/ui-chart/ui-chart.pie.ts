import * as d3 from 'd3';


export class PieChart {

    draw(element: HTMLElement, tooltipEl: HTMLElement, data: { value: number, label: string, count?: number }[]) {
        
        let host = d3.select(element);
        let tooltip = d3.select(tooltipEl)
            .attr('class', 'd3-tooltip')
            .style('opacity', 0);

        let size = 400;
        let radius = size / 2;


        let arc: any = d3.arc().outerRadius(radius).innerRadius(radius/2);
        let pie = d3.pie();

        let color = d3.scaleOrdinal(d3.schemeCategory20c);

        let sum = data.map(e => +e.value || 0).reduce((a, b) => a + b, 0);
        let empty = data.length === 0;

        if (empty) {
            data = [{
                value: 1,
                label: ''
            }]
        }

        let svg = host
            .attr('width', '100%')
            .attr('viewBox', `0 0 ${size} ${size}` )
            .append('g')
            .attr('transform', `translate(${size / 2}, ${size / 2})`);
        
        // append individual pieces
        let path = svg.selectAll('path')
            .data(pie(data.map(e => e.value || 1)))
            .enter().append('path')
            .on('mouseover', d => {
                let index = d.index;
                let label = data[index].label;
                let value = data[index].value || 0;
                let count = data[index].count;

                let html = `
                <b>${label}</b>
                <hr style="margin: 2px"/>
                `;

                if (empty) {
                    html = 'No Data Available';
                }

                else if (count === undefined) {
                    html += `Projects: ${Number(value).toLocaleString()} (${(100 * value/sum).toFixed(2)}%)`;
                }

                else {
                    html += `Relevance: ${(+Number(value).toFixed(2)).toLocaleString()} (${(100 * value/sum || 0).toFixed(2)}%)`;
                    html += `<br>`
                    html += `Projects: ${Number(count).toLocaleString()}`;
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
                empty ? '#ddd' : color(d.index.toString()))
    }

    /**
     * Exports a base64-encoded png 
     */
    export(data: any[]): string {
        return '';
    }
}