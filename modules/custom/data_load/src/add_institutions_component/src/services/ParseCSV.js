import * as P from 'papaparse'; 

export const parse = file => 
  new Promise((resolve, reject) => {
    P.parse(file, {
      header: true,
      complete: resolve,
      error: reject,
      skipEmptyLines: true
    })
  })
  