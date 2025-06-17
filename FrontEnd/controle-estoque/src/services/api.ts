import axios from 'axios'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  headers: {
    'Content-Type': 'application/json'
  }
})

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response && error.response.status === 401) {
      localStorage.clear()
      sessionStorage.clear()
      delete api.defaults.headers['Authorization']
    }
    return Promise.reject(error)
  }
)

const token = localStorage.getItem('authToken')
if (token) {
  api.defaults.headers['Authorization'] = `Bearer ${token}`
}

export default api
