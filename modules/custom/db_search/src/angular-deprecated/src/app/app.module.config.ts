export let providedValues = {
  development: {
    live: [
      {
        provide: 'api_root',
        useValue: 'https://icrpartnership-dev.org',
      },
      {
        provide: 'api_type',
        useValue: 'live'
      }
    ],
    review: [
      {
        provide: 'api_root',
        useValue: 'https://icrpartnership-dev.org/load',
      },
      {
        provide: 'api_type',
        useValue: 'review'
      }
    ],
  },
  
  production: {
    live: [
      {
        provide: 'api_root',
        useValue: '',
      },
      {
        provide: 'api_type',
        useValue: 'live'
      }
    ],
    review: [
      {
        provide: 'api_root',
        useValue: '/load',
      },
      {
        provide: 'api_type',
        useValue: 'review'
      }
    ],
  }
}