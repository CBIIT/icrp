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

        let margin = {top: 20, right: 20, bottom: 40, left: 110};
        let width = 1000 - margin.left - margin.right;
        let height = 300 - margin.top - margin.bottom;

        let g = host
            .attr('width', '100%')
            .attr('viewBox', `0 0 ${width + margin.left + margin.right} ${height + margin.top + margin.bottom}` )
            .append('g')
            .attr("transform", `translate(${margin.left}, ${margin.top})`);
        
        var x = d3.scaleLinear()
            .rangeRound([0, width])
            .domain(d3.extent(parsedData, (d: any) => d.label));

        var y = d3.scaleLinear()
            .rangeRound([height, 0])
            .domain(d3.extent(parsedData, (d: any) => d.value));
        
        var line: any = d3.area()
            .x(d => x(+d['label']))
            .y0(height)
            .y1(d => y(+d['value']));

        g.append("g")
            .attr("transform", `translate(0, ${height})`)
            .call(d3.axisBottom(x).tickFormat(d3.format('d')))
            .append("text")
            .attr("fill", "#000")
            .attr("x", width / 2)
            .attr("y", 30)
            .attr("dy", "0.71em")
            .attr("text-anchor", "middle")
            .text("Year");

        g.append("g")
            .call(d3.axisLeft(y).ticks(5))
            .append("text")
            .attr("fill", "#000")
            .attr("transform", "rotate(-90)")
            .attr("x", height / -2)
            .attr("y", -100)
            .attr("dy", "0.71em")
            .attr("text-anchor", "middle")
            .text("Funding Amount (USD)");

        g.append("path")
            .datum(parsedData)
            .attr("fill", "#3498DB")
            .attr('opacity', '0.75')
            .attr("stroke", "#263545")
            .attr("stroke-opacity", "0.8")
            .attr("stroke-linejoin", "round")
            .attr("stroke-linecap", "round")
            .attr("stroke-width", '1px')
            .attr("d", line);


        parsedData.forEach(point => {
            g.append('circle')
                .attr('fill', '#34495E')
                .attr('stroke', '#34495E')
                .attr('opacity', '0.65')
                .attr('r', '4px')
                .attr('cx', x(point['label']))
                .attr('cy', y(point['value']))
                .on('mouseover', d => {
                    let label = point.label;
                    let value = point.value;
                    tooltip.html(`
                        <b>${label}</b>
                        <hr style="margin: 2px"/>
                         ${Number(value).toLocaleString()} USD`)
                    tooltip.transition()
                        .duration(200)
                        .style('opacity', .9);
                
                })
                .on('mousemove', d => {
                    var xoffset = (d3.event.pageX / window.outerWidth > 0.7) ? -165 : 5;
                    tooltip
                        .style('left', (d3.event.pageX + 10) + 'px')
                        .style('top', (d3.event.pageY + 10 - window.scrollY) + 'px')
                })
                .on('mouseout', d => {
                    tooltip.transition()
                        .duration(300)
                        .style('opacity', 0);
                })
        })

/*
        x.ticks().forEach(tick => {
            g.append('line')
                .attr('x1', x(tick))
                .attr('y1', height)
                .attr('x2', x(tick))
                .attr('y2', 0)
                .attr('stroke', 'black')
                .attr('opacity', '0.05')
        })
*/
        y.ticks(5).forEach(tick => {
            g.append('line')
                .attr('x1', 0)
                .attr('y1', y(tick))
                .attr('x2', width)
                .attr('y2', y(tick))
                .attr('stroke', 'black')
                .attr('opacity', '0.04')
            .attr("stroke-linejoin", "round")
            .attr("stroke-linecap", "round")
                
        })

    }

    /**
     * Exports a base64-encoded png 
     */
    export(data: any[]): string {
        return '';
    }
}
