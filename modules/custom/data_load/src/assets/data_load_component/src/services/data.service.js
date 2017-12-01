
export const API_ROOT = `${window.location.protocol}//${window.location.hostname}`


export const fetchJson = async (endpoint, options) => {
  const response = await fetch(endpoint, options);
  const data = await response.json();
  if (response.ok)
    return data;
  else
    throw data;
}


export const toFormData = parameters => {
  let formData = new FormData();

  for (let key in parameters) {
    const value = parameters[key];
    value.constructor === window.File
      ? formData.append(key, value, value.name)
      : formData.append(key, value);
  }

  return formData;
}


export const loadProjects = async parameters =>
  await fetchJson(`${API_ROOT}/DataUploadTool/loadProjects`, {
    method: 'POST',
    credentials: 'same-origin',
    body: toFormData(parameters),
  });


export const getProjects = async parameters =>
  await fetchJson(`${API_ROOT}/DataUploadTool/getProjects`, {
    method: 'POST',
    credentials: 'same-origin',
    body: JSON.stringify(parameters),
  });


export const importProjects = async parameters =>
  await fetchJson(`${API_ROOT}/DataUploadTool/importProjects`, {
    method: 'POST',
    credentials: 'same-origin',
    body: JSON.stringify(parameters),
  });


export const getPartners = async () =>
  await fetchJson(`${API_ROOT}/DataUploadTool/getPartners`, {
    credentials: 'same-origin',
  });


export const getValidationRules = async () =>
  await fetchJson(`${API_ROOT}/DataUploadTool/getValidationRules`, {
    credentials: 'same-origin',
  });


export const integrityCheck = async parameters =>
  await fetchJson(`${API_ROOT}/DataUploadTool/integrityCheck`, {
    method: 'POST',
    credentials: 'same-origin',
    body: JSON.stringify(parameters),
  });


export const integrityCheckDetails = async parameters =>
  await fetchJson(`${API_ROOT}/DataUploadTool/integrityCheckDetails`, {
    method: 'POST',
    credentials: 'same-origin',
    body: JSON.stringify(parameters),
  });


export const getExcelExport = async parameters =>
  await fetchJson(`${API_ROOT}/api/getExcelExport`, {
    method: 'POST',
    credentials: 'same-origin',
    body: JSON.stringify(parameters),
  });
