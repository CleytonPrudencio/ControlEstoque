import api from './api'

export const login = async (username: string, password: string) => {
  const response = await api.post('/auth/login', { username, password })
  const token = response.data.token
  localStorage.setItem('authToken', token)
  api.defaults.headers['Authorization'] = `Bearer ${token}`
  return token
}

export const logout = () => {
  localStorage.removeItem('authToken')
  delete api.defaults.headers['Authorization']
}
