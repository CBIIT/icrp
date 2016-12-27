import * as d3 from 'd3';


export class PieChart {




    draw(element: HTMLElement, data: { value: number, label: string }[]) {
        
        let host = d3.select(element);

        let size = element.clientWidth;
        let radius = size / 2;

        let arc: any = d3.arc().outerRadius(radius).innerRadius(radius/2);
        let pie = d3.pie();

        let color = d3.scaleOrdinal(d3.schemeCategory20c);

        let svg = host
            .attr('width', size)
            .attr('height', size)
            .append('g')
            .attr('transform', `translate(${size / 2}, ${size / 2})`);
        
        // append individual pieces
        let path = svg.selectAll('path')
        .data(pie(data.map(e => e.value)))
            .enter().append('path')
            .transition().duration(500)
        .each(e => e)
            .attr('d', arc)
        .style('fill', d => color(d.value.toString()))
    }

    /**
     * Exports a base64-encoded png 
     */
    export(data: any[]): string {
        return '';
    }
}