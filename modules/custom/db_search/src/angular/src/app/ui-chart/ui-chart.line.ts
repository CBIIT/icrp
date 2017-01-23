import * as d3 from 'd3';


export class LineChart {

    draw(element: HTMLElement, tooltipEl: HTMLElement, data: { value: number, label: string }[]) {

        let parsedData = data.map(el => ({
            value: +el.value,
            label: +el.label
        })).sort((a, b) => a.label - b.label);

        let host = d3.select(element);
        let tooltip = d3.select(tooltipEl)
            .attr('class', 'd3-tooltip')
            .style('opacity', 0);

        let margin = {top: 20, right: 20, bottom: 30, left: 50};
        let width = 1000 - margin.left - margin.right;
        let height = 300 - margin.top - margin.bottom;

        let g = host
            .attr('width', '100%')
            .attr('viewBox', `0 0 ${width + margin.left + margin.right} ${height + margin.top + margin.bottom}` )
            .append('g')
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
        
        var x = d3.scaleLinear()
            .rangeRound([0, width])
            .domain(d3.extent(parsedData, (d: any) => d.label));

        var y = d3.scaleLinear()
            .rangeRound([height, 0])
            .domain(d3.extent(parsedData, (d: any) => d.value));
        
        var line: any = d3.line()
            .x(d => x(+d['label']))
            .y(d => y(+d['value']));

        g.append("g")
            .attr("transform", "translate(0," + height + ")")
            .call(d3.axisBottom(x).tickFormat(d3.format('d')))
            .select(".domain")
            .remove();

        g.append("g")
            .call(d3.axisLeft(y))
            .append("text")
            .attr("fill", "#000")
            .attr("transform", "rotate(-90)")
            .attr("y", 6)
            .attr("dy", "0.71em")
            .attr("text-anchor", "end")
            .text("Number of Projects");

        g.append("path")
            .datum(data)
            .attr("fill", "none")
            .attr("stroke", "steelblue")
            .attr("stroke-linejoin", "round")
            .attr("stroke-linecap", "round")
            .attr("stroke-width", 1.5)
            .attr("d", line);
    }

    /**
     * Exports a base64-encoded png 
     */
    export(data: any[]): string {
        return '';
    }
}
