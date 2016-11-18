import { Component, OnInit, AfterViewInit } from '@angular/core';

@Component({
  selector: 'app-search-visualization',
  templateUrl: './search-visualization.component.html',
  styleUrls: ['./search-visualization.component.css']
})
export class SearchVisualizationComponent implements OnInit, AfterViewInit {

  collapsed = true;

  projectsByCountry: any = {
    labels: [],
    datasets: []
  }

  projectsByCategory: any = {
    labels: [],
    datasets: []
  }

  topCancerSites: any = {
    labels: [],
    datasets: []
  }

  fundingAmounts: any = {
    labels: [],
    datasets: []
  }

  options = {
    projectsByCountry: {
      title: {
        display: true,
        text: 'Projects by country'
      },

      legend: {
        display: false
      }

    },

    projectsByCategory: {
      title: {
        display: true,
        text: 'Projects by CSO category'
      },

      legend: {
        display: false
      }
    },

    topCancerSites: {
      title: {
        display: true,
        text: 'Top five cancer types'
      },


      legend: {
        display: false,
      }
    },

    fundingAmounts: {
      title: {
        display: true,
        text: 'Funding amounts by year'
      },

      legend: {
        display: false
      }

    }
  }

  

  a = [{ "country": "country", "count": "(No column name)" }, { "country": "HK", "count": "7" }, { "country": "UG", "count": "1" }, { "country": "ZA", "count": "17" }, { "country": "BR", "count": "12" }, { "country": "US", "count": "143742" }, { "country": "BE", "count": "35" }, { "country": "CL", "count": "7" }, { "country": "AS", "count": "11" }, { "country": "SG", "count": "7" }, { "country": "TH", "count": "4" }, { "country": "TW", "count": "3" }, { "country": "SN", "count": "3" }, { "country": "NG", "count": "1" }, { "country": "CR", "count": "9" }, { "country": "FI", "count": "31" }, { "country": "AU", "count": "1121" }, { "country": "SE", "count": "127" }, { "country": "GR", "count": "40" }, { "country": "AT", "count": "13" }, { "country": "NZ", "count": "11" }, { "country": "FR", "count": "711" }, { "country": "CH", "count": "97" }, { "country": "KR", "count": "8" }, { "country": "GA", "count": "1" }, { "country": "RU", "count": "2" }, { "country": "IN", "count": "34" }, { "country": "MX", "count": "11" }, { "country": "AR", "count": "16" }, { "country": "ES", "count": "89" }, { "country": "PR", "count": "3" }, { "country": "IL", "count": "235" }, { "country": "MW", "count": "1" }, { "country": "DK", "count": "31" }, { "country": "CA", "count": "30224" }, { "country": "CZ", "count": "9" }, { "country": "IE", "count": "30" }, { "country": "PT", "count": "12" }, { "country": "", "count": "1998" }, { "country": "JP", "count": "102" }, { "country": "EE", "count": "9" }, { "country": "NL", "count": "810" }, { "country": "DE", "count": "92" }, { "country": "GM", "count": "28" }, { "country": "IS", "count": "22" }, { "country": "TR", "count": "1" }, { "country": "CN", "count": "20" }, { "country": "EG", "count": "4" }, { "country": "IT", "count": "223" }, { "country": "JM", "count": "2" }, { "country": "GB", "count": "24877" }, { "country": "PL", "count": "4" }, { "country": "HU", "count": "13" }, { "country": "GT", "count": "1" }, { "country": "PE", "count": "1" }, { "country": "SZ", "count": "3" }];


  visualizationParameters = [
    1, 2, 3, 4
  ]

  toggleCollapse() {
    this.collapsed = !this.collapsed
  }


  constructor() { }

  ngOnInit() {
  }

  initialize() {


    this.projectsByCountry = {
      labels: ['US', 'GB', 'CA', 'NL', 'FR', 'AU', 'JP', 'Other'],
      datasets: [
        {
          data: [143742, 24877, 30224, 810, 711, 1121, 102, 3339], // total 201587
          backgroundColor: [
            "#FF6384",
            "#4BC0C0",
            "#FFCE56",
            "#36A2EB",
            "#D98B3A",
            "#9C215F",
            "#C878AB"
          ],
          hoverBackgroundColor: [
            "#FF6384",
            "#4BC0C0",
            "#FFCE56",
            "#36A2EB",
            "#D98B3A",
            "#9C215F",
            "#C878AB"
          ],

        }
      ]
    }

    this.projectsByCategory = {
      labels: ["Biology", "Causes of Cancer Etiology", "Prevention", "Early Detection, Diagnosis, and Prognosis", "Treatment", "Cancer Control, Survivorship and Outcomes Research", "Scientific Model Systems", "Uncoded"],
      datasets: [
        {
          data: [98570, 48816, 20411, 39719, 70281, 33871, 7908, 1678],
          backgroundColor: [
            "#FF6384",
            "#4BC0C0",
            "#FFCE56",
            "#36A2EB",
            "#D98B3A",
            "#9C215F",
            "#C878AB"
          ],
          hoverBackgroundColor: [
            "#FF6384",
            "#4BC0C0",
            "#FFCE56",
            "#36A2EB",
            "#D98B3A",
            "#9C215F",
            "#C878AB"
          ],

        }
      ]      
    }

    this.topCancerSites = {
      labels: ["Breast Cancer", "Not Site-Specific Cancer", "Gastrointestinal Tract", "Prostate Cancer", "Genital System, Male"],
      datasets: [
        {
          data: [63488, 51818, 29211, 27544, 27526],
          backgroundColor: [
            "#FF6384",
            "#4BC0C0",
            "#FFCE56",
            "#36A2EB",
            "#D98B3A",
            "#9C215F",
            "#C878AB"
          ],
          hoverBackgroundColor: [
            "#FF6384",
            "#4BC0C0",
            "#FFCE56",
            "#36A2EB",
            "#D98B3A",
            "#9C215F",
            "#C878AB"
          ],

        }
      ]      
    }

    this.fundingAmounts = {
      labels: [1953, 1954, 1965, 1969, 1970, 1971, 1972, 1973, 1974, 1975, 1976, 1977, 1978, 1979, 1980, 1981,
        1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998,
        1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010].splice(20, 25),//.map((val, ind) => ind % 5 ? val : ""),
      datasets: [
        {
          data: [468821,523431,7866378,4560824,26585033,10117058,3753403,2222863,6082487,47781525,176300066,305512843,278087402,173561552,164562995,179681493,147229884,450322766,113175903,171911458,122129512,188984391,180910145,139141607,162284941,220343918,520884374,237553410,383208094,426689418,569650787,1516465436,824056540,1311361300,1663344769,2305077363,3914772201,5950730546,5206183479,4662091707,4006119447,4883491339,5472401712,4359176653,4062682961].splice(20, 25),
          borderColor: "#FF6384",
          fill: false,
          pointRadius: 0,
          borderWidth: 2,
        }
      ]      
    }

  }


  ngAfterViewInit() {

    setTimeout(e => this.initialize(), 1000);

  }

}
